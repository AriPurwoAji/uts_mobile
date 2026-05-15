import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../product_provider.dart';
import '../../../cart/presentation/cart_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _selectedShaft   = 'Splined';
  String _selectedPorting = 'Side';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (_, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = provider.selectedProduct;
          if (product == null) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  height: 250,
                  width: double.infinity,
                  color: AppTheme.lightGrey,
                  child: product.imageUrl.isNotEmpty
                    ? Image.network(product.imageUrl, fit: BoxFit.contain)
                    : const Icon(Icons.water_drop,
                        size: 80, color: AppTheme.darkNavy),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(product.name,
                              style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold,
                                color: AppTheme.darkNavy,
                              ),
                            ),
                          ),
                          Column(
                            children: const [
                              Row(children: [
                                Icon(Icons.star,
                                  color: AppTheme.starYellow, size: 16),
                                Text(' 4.8',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              ]),
                              Text('128 Reviews',
                                style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Specifications
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _specItem('Flow Rate', product.flowRate)),
                                Expanded(child: _specItem('Mount', product.mountType)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(child: _specItem('Max Pressure', product.maxPressure)),
                                Expanded(child: _specItem('Condition', product.condition)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Options — Shaft Type
                      const Text('Options',
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold,
                          color: AppTheme.darkNavy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Shaft Type',
                                  style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Row(
                                  children: ['Splined', 'Keyed'].map((type) =>
                                    _optionChip(
                                      type, _selectedShaft,
                                      () => setState(() => _selectedShaft = type)),
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Porting',
                                  style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Row(
                                  children: ['Side', 'Rear'].map((type) =>
                                    _optionChip(
                                      type, _selectedPorting,
                                      () => setState(() => _selectedPorting = type)),
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Price + Buttons
                      Text(product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold,
                          color: AppTheme.darkNavy,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await context.read<CartProvider>()
                                  .addToCart(product.id, 1);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ditambahkan ke cart'),
                                      backgroundColor: AppTheme.primaryOrange,
                                    ),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(
                                  color: AppTheme.darkNavy),
                              ),
                              child: const Text('ADD TO CART',
                                style: TextStyle(color: AppTheme.darkNavy)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('BUY NOW'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _specItem(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
        style: const TextStyle(fontSize: 11, color: Colors.grey)),
      Text(value.isNotEmpty ? value : '-',
        style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold,
          color: AppTheme.darkNavy,
        ),
      ),
    ],
  );

  Widget _optionChip(String label, String selected, VoidCallback onTap) {
    final isSelected = label == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade300),
        ),
        child: Text(label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.darkNavy,
            fontSize: 12, fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}