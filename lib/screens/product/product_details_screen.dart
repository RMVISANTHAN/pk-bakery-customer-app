import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';
import '../cart/cart_screen.dart';
import '../checkout/checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product? _product;
  bool _loading = true;
  String? _selectedWeight;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final product = await context.read<ProductProvider>().fetchProductById(widget.productId);
    setState(() {
      _product = product;
      _selectedWeight = product?.weightOptions.isNotEmpty == true ? product!.weightOptions.first.label : null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_product == null) return const Scaffold(body: Center(child: Text('Product not found')));

    final product = _product!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: product.images.isNotEmpty
                  ? CachedNetworkImage(imageUrl: product.images.first, fit: BoxFit.cover)
                  : Container(color: AppColors.surface),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹${product.finalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      if (product.discountPercent > 0) ...[
                        const SizedBox(width: 8),
                        Text('₹${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppColors.textSecondary)),
                      ],
                      const Spacer(),
                      Icon(Icons.star_rounded, color: AppColors.secondary, size: 20),
                      Text(' ${product.ratingAverage.toStringAsFixed(1)} (${product.ratingCount})'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (product.weightOptions.isNotEmpty) ...[
                    const Text('Weight', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: product.weightOptions.map((w) {
                        final selected = _selectedWeight == w.label;
                        return ChoiceChip(
                          label: Text(w.label),
                          selected: selected,
                          onSelected: (_) => setState(() => _selectedWeight = w.label),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => setState(() => _quantity = (_quantity > 1) ? _quantity - 1 : 1),
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(product.description, style: const TextStyle(color: AppColors.textSecondary)),
                  if (product.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(product.ingredients.join(', '), style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                  const SizedBox(height: 100), // room for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<CartProvider>().addProduct(product, weightOption: _selectedWeight, quantity: _quantity);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().addProduct(product, weightOption: _selectedWeight, quantity: _quantity);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                  },
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
