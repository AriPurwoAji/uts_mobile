import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/cart_provider.dart';
import '../../domain/product_model.dart';

class ProductBottomSheet extends StatefulWidget {
  final ProductModel product;
  const ProductBottomSheet({super.key, required this.product});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  int _qty = 1;

  String _formatRp(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(imageUrl,
          height: 180, width: double.infinity, fit: BoxFit.cover);
    }
    if (imageUrl.isNotEmpty) {
      return Image.network(imageUrl,
          height: 180, width: double.infinity, fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const SizedBox(height: 180,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
          },
          errorBuilder: (context2, err, stack) => _placeholder());
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        height: 180,
        color: AppTheme.lightGrey,
        child: const Center(
          child: Icon(Icons.precision_manufacturing_outlined,
              size: 64, color: AppTheme.darkNavy),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Gambar produk
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _buildImage(product.imageUrl),
          ),
          const SizedBox(height: 16),

          // Nama + harga
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkNavy,
                    )),
              ),
              const SizedBox(width: 12),
              Text(_formatRp(product.price),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryOrange,
                  )),
            ],
          ),
          const SizedBox(height: 6),

          // Stok
          Text('Stok: ${product.stock}',
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 20),

          // Qty selector + tombol
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                    ),
                    Text('$_qty',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: _qty < product.stock
                          ? () => setState(() => _qty++)
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context3, cart, child) => ElevatedButton(
                    onPressed: cart.isLoading
                        ? null
                        : () async {
                            await context
                                .read<CartProvider>()
                                .addToCart(product.id, _qty);
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${product.name} ditambahkan ke keranjang'),
                                  backgroundColor: AppTheme.primaryOrange,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: cart.isLoading
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Tambah ke Keranjang'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
