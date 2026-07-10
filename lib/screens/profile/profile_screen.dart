import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
import '../product/wishlist_screen.dart';
import '../checkout/address_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 32, backgroundColor: AppColors.surface, child: Icon(Icons.person, size: 32, color: AppColors.textSecondary)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.name ?? 'Guest', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(user?.email ?? user?.phone ?? '', style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _tile(context, Icons.location_on_outlined, 'Saved Addresses', () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddressScreen(savedAddresses: user?.addresses ?? [])))),
          _tile(context, Icons.favorite_border_rounded, 'Wishlist', () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const WishlistScreen()))),
          _tile(context, Icons.settings_outlined, 'Settings', () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const SettingsScreen()))),
          _tile(context, Icons.help_outline_rounded, 'Help & Support', () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HelpSupportScreen()))),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
