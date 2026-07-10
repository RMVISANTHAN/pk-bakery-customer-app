import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PaymentScreen extends StatelessWidget {
  final String selected;
  const PaymentScreen({super.key, required this.selected});

  static const _methods = [
    ['cod', 'Cash on Delivery', Icons.payments_outlined],
    ['razorpay', 'Razorpay (Netbanking / Wallets)', Icons.account_balance_outlined],
    ['upi', 'UPI', Icons.qr_code_rounded],
    ['card', 'Debit / Credit Card', Icons.credit_card_rounded],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _methods.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final id = _methods[i][0] as String;
          final label = _methods[i][1] as String;
          final icon = _methods[i][2] as IconData;
          final isSelected = id == selected;
          return Card(
            color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.white,
            child: ListTile(
              leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
              title: Text(label),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () => Navigator.of(context).pop(id),
            ),
          );
        },
      ),
    );
  }
}
