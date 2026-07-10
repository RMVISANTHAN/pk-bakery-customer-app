import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Populated from a future GET /api/notifications endpoint (order updates,
/// offers, new products). Real-time delivery is handled by FCM; this screen
/// is the in-app inbox / history view of past notifications.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.textSecondary),
              SizedBox(height: 16),
              Text("You're all caught up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('Order updates and offers will show up here.', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
