import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../order/order_tracking_screen.dart';
import '../home/home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final String orderNumber;
  const OrderSuccessScreen({super.key, required this.orderId, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72),
              ),
              const SizedBox(height: 24),
              const Text('Order Placed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Order #$orderNumber', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              const Text(
                "We're getting your bakes ready. You can track your order live.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderId: orderId)),
                  ),
                  child: const Text('Track Order'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  ),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
