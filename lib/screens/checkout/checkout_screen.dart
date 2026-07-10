import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/app_theme.dart';
import '../../services/api_service.dart';
import '../../utils/api_constants.dart';
import 'address_screen.dart';
import 'payment_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;
  final _instructionsController = TextEditingController();
  String _paymentMethod = 'cod'; // cod | razorpay | upi | card
  bool _placingOrder = false;

  Future<void> _pickAddress() async {
    final user = context.read<AuthProvider>().user;
    final result = await Navigator.of(context).push<Address>(
      MaterialPageRoute(builder: (_) => AddressScreen(savedAddresses: user?.addresses ?? [])),
    );
    if (result != null) setState(() => _selectedAddress = result);
  }

  Future<void> _pickPaymentMethod() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => PaymentScreen(selected: _paymentMethod)),
    );
    if (result != null) setState(() => _paymentMethod = result);
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a delivery address')));
      return;
    }
    setState(() => _placingOrder = true);
    try {
      final response = await ApiService.instance.post(ApiConstants.orders, data: {
        'addressId': _selectedAddress!.id,
        'deliveryInstructions': _instructionsController.text,
        'paymentMethod': _paymentMethod,
      });
      final orderNumber = response.data['data']['orderNumber'];
      final orderId = response.data['data']['_id'];

      // For online payment methods, kick off the Razorpay flow here using
      // POST /api/payments/razorpay/order + the razorpay_flutter package,
      // then verify with POST /api/payments/razorpay/verify.

      context.read<CartProvider>().clear();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: orderId, orderNumber: orderNumber)),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not place order. Please try again.')));
    } finally {
      if (mounted) setState(() => _placingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    const deliveryCharge = 40.0;
    const gstRate = 0.05;
    final subtotal = cart.subtotal;
    final gst = subtotal * gstRate;
    final total = subtotal + deliveryCharge + gst;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionCard(
            title: 'Delivery Address',
            trailing: TextButton(onPressed: _pickAddress, child: Text(_selectedAddress == null ? 'Select' : 'Change')),
            child: _selectedAddress == null
                ? const Text('No address selected', style: TextStyle(color: AppColors.textSecondary))
                : Text('${_selectedAddress!.line1}, ${_selectedAddress!.city}, ${_selectedAddress!.state} ${_selectedAddress!.pincode}'),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Delivery Instructions',
            child: TextField(
              controller: _instructionsController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'E.g. Ring the bell, leave at door...'),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Payment Method',
            trailing: TextButton(onPressed: _pickPaymentMethod, child: const Text('Change')),
            child: Text(_paymentLabel(_paymentMethod)),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Order Summary',
            child: Column(
              children: [
                _priceRow('Subtotal', subtotal),
                _priceRow('Delivery charge', deliveryCharge),
                _priceRow('GST (5%)', gst),
                const Divider(),
                _priceRow('Total', total, bold: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _placingOrder ? null : _placeOrder,
            child: _placingOrder
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('Place Order · ₹${total.toStringAsFixed(0)}'),
          ),
        ),
      ),
    );
  }

  String _paymentLabel(String method) {
    switch (method) {
      case 'razorpay':
        return 'Razorpay (Netbanking / Wallets)';
      case 'upi':
        return 'UPI';
      case 'card':
        return 'Debit / Credit Card';
      default:
        return 'Cash on Delivery';
    }
  }

  Widget _sectionCard({required String title, required Widget child, Widget? trailing}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text('₹${value.toStringAsFixed(0)}', style: style)],
      ),
    );
  }
}
