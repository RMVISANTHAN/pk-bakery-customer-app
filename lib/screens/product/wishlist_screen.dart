import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Wishlist is populated from GET /api/auth/me (user.wishlist, populated) and
/// toggled via a "favorite" icon on ProductDetailsScreen / ProductCard that
/// calls a wishlist add/remove endpoint. Add PUT /api/users/wishlist/:productId
/// (toggle) on the backend when wiring this screen up fully.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.textSecondary),
              SizedBox(height: 16),
              Text('Your wishlist is empty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('Tap the heart icon on any product to save it here.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
