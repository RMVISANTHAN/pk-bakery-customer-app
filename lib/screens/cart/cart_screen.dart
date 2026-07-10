import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  String? _appliedCoupon;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.lines.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Cart')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text('Your cart is empty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
    }

    const deliveryCharge = 40.0; // TODO: mirror backend free-delivery threshold logic
    const gstRate = 0.05;
    final subtotal = cart.subtotal;
    final gst = subtotal * gstRate;
    final total = subtotal + deliveryCharge + gst;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...cart.lines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: line.product.images.isNotEmpty
                            ? CachedNetworkImage(imageUrl: line.product.images.first, fit: BoxFit.cover)
                            : Container(color: AppColors.surface),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(line.product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          if (line.weightOption != null) Text(line.weightOption!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Text('₹${line.lineTotal.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () {
                            if (line.quantity > 1) {
                              context.read<CartProvider>().updateQuantity(line.product.id, line.weightOption, line.quantity - 1);
                            } else {
                              context.read<CartProvider>().removeLine(line.product.id, line.weightOption);
                            }
                          },
                        ),
                        Text('${line.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          onPressed: () => context.read<CartProvider>().updateQuantity(line.product.id, line.weightOption, line.quantity + 1),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: const InputDecoration(hintText: 'Enter coupon code'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: call POST /api/coupons/validate and apply discount
                  setState(() => _appliedCoupon = _couponController.text.trim().toUpperCase());
                },
                child: const Text('Apply'),
              ),
            ],
          ),
          if (_appliedCoupon != null && _appliedCoupon!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Coupon "$_appliedCoupon" will be validated at checkout', style: const TextStyle(color: AppColors.success, fontSize: 12)),
            ),
          const Divider(height: 32),
          _priceRow('Subtotal', subtotal),
          _priceRow('Delivery charge', deliveryCharge),
          _priceRow('GST (5%)', gst),
          const Divider(),
          _priceRow('Total', total, bold: true),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutScreen())),
            child: Text('Proceed to Checkout · ₹${total.toStringAsFixed(0)}'),
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 16 : 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text('₹${value.toStringAsFixed(0)}', style: style)],
      ),
    );
  }
}
