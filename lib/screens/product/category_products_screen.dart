import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import 'product_details_screen.dart';

/// Shows all products for a given category (e.g. "Cakes", "Donuts").
/// NOTE: this filters client-side by category name for the scaffold;
/// wire it up to pass the real categoryId once category list is fetched
/// from GET /api/categories and cached, then call fetchProducts(category: id).
class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts(search: widget.categoryName));
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.68,
              ),
              itemCount: productProvider.products.length,
              itemBuilder: (context, i) {
                final product = productProvider.products[i];
                return ProductCard(
                  product: product,
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId: product.id))),
                  onAddToCart: () => context.read<CartProvider>().addProduct(product),
                );
              },
            ),
    );
  }
}
