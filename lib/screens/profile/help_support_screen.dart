import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
              title: const Text('Chat with us'),
              subtitle: const Text('Typical reply time: under 5 minutes'),
              onTap: () {
                // TODO: integrate a support chat SDK (e.g. Freshchat, Intercom) or in-app ticketing.
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.call_outlined, color: AppColors.primary),
              title: const Text('Call support'),
              subtitle: const Text('+91 98765 43210'),
              onTap: () => launchUrl(Uri.parse('tel:+919876543210')),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined, color: AppColors.primary),
              title: const Text('Email us'),
              subtitle: const Text('support@pkbakery.com'),
              onTap: () => launchUrl(Uri.parse('mailto:support@pkbakery.com')),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const ExpansionTile(
            title: Text('How do I track my order?'),
            children: [Padding(padding: EdgeInsets.all(12), child: Text('Go to My Orders and tap on an active order to see live tracking.'))],
          ),
          const ExpansionTile(
            title: Text('What payment methods are accepted?'),
            children: [Padding(padding: EdgeInsets.all(12), child: Text('Cash on Delivery, Razorpay, UPI, and Debit/Credit Cards.'))],
          ),
          const ExpansionTile(
            title: Text('Can I cancel my order?'),
            children: [Padding(padding: EdgeInsets.all(12), child: Text('Yes, as long as it has not been dispatched for delivery yet.'))],
          ),
        ],
      ),
    );
  }
}
