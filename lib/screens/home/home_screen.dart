import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/product_card.dart';
import '../product/product_details_screen.dart';
import '../product/category_products_screen.dart';
import '../search/search_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import '../order/order_history_screen.dart';
import '../profile/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  static const _categories = [
    ['Cakes', Icons.cake_rounded],
    ['Birthday Cakes', Icons.celebration_rounded],
    ['Wedding Cakes', Icons.favorite_rounded],
    ['Breads', Icons.bakery_dining_rounded],
    ['Buns', Icons.lunch_dining_rounded],
    ['Cookies', Icons.cookie_rounded],
    ['Pastries', Icons.icecream_rounded],
    ['Donuts', Icons.circle_outlined],
    ['Sandwiches', Icons.food_bank_rounded],
    ['Beverages', Icons.local_cafe_rounded],
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      const OrderHistoryScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_navIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final productProvider = context.watch<ProductProvider>();

    return RefreshIndicator(
      onRefresh: () => context.read<ProductProvider>().fetchProducts(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('PK Bakery', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        Text('Freshly baked, delivered fast', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded),
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.button)),
                  child: const Row(children: [
                    Icon(Icons.search, color: AppColors.textSecondary),
                    SizedBox(width: 10),
                    Text('Search cakes, breads, pastries...', style: TextStyle(color: AppColors.textSecondary)),
                  ]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final name = _categories[i][0] as String;
                  final icon = _categories[i][1] as IconData;
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CategoryProductsScreen(categoryName: name)),
                    ),
                    child: Container(
                      width: 76,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), shape: BoxShape.circle),
                            child: Icon(icon, color: AppColors.primary),
                          ),
                          const SizedBox(height: 6),
                          Text(name, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            sliver: SliverToBoxAdapter(
              child: Text('Popular right now', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          if (productProvider.isLoading)
            const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())))
          else if (productProvider.error != null)
            SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(40), child: Center(child: Text(productProvider.error!))))
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final product = productProvider.products[i];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId: product.id))),
                      onAddToCart: () {
                        context.read<CartProvider>().addProduct(product);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
                      },
                    );
                  },
                  childCount: productProvider.products.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
