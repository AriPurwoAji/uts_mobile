import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../category/presentation/category_provider.dart';
import '../../../product/presentation/product_provider.dart';
import '../../../cart/presentation/cart_provider.dart';
import '../widgets/category.grid.dart';
import '../widgets/featured_product_card.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../category/presentation/pages/category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      context.read<ProductProvider>().fetchProducts();
      context.read<CartProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop, color: AppTheme.primaryOrange),
            const SizedBox(width: 8),
            const Text('HYDRAU-LINK',
              style: TextStyle(
                color: AppTheme.darkNavy,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartPage())),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 6, top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for pumps, valves, cylinders...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: AppTheme.lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Browse Categories
            const Text('Browse Categories',
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: AppTheme.darkNavy,
              ),
            ),
            const SizedBox(height: 12),
            const CategoryGrid(),
            const SizedBox(height: 24),

            // Featured Parts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Featured Parts',
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold,
                    color: AppTheme.darkNavy,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All',
                    style: TextStyle(color: AppTheme.primaryOrange)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Featured Products Grid
            Consumer<ProductProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: provider.featuredProducts.length,
                  itemBuilder: (_, index) {
                    final product = provider.featuredProducts[index];
                    return FeaturedProductCard(
                      product: product,
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(
                            productId: product.id))),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}