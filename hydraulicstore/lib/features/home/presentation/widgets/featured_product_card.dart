import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../product/domain/product_model.dart';

class FeaturedProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const FeaturedProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  // ── Helper: deteksi asset lokal vs URL ──────────
  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: AppTheme.lightGrey,
        child: const Icon(
          Icons.precision_manufacturing_outlined,
          size: 48,
          color: AppTheme.darkNavy,
        ),
      );
    }

    if (imageUrl.startsWith('assets/')) {
      // Gambar dari asset lokal
      return Image.asset(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: AppTheme.lightGrey,
          child: const Icon(
            Icons.precision_manufacturing_outlined,
            size: 48,
            color: AppTheme.darkNavy,
          ),
        ),
      );
    }

    // Gambar dari URL internet
    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppTheme.lightGrey,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, _, _) => Container(
        color: AppTheme.lightGrey,
        child: const Icon(
          Icons.precision_manufacturing_outlined,
          size: 48,
          color: AppTheme.darkNavy,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ──────────────────────
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: _buildImage(product.imageUrl), // ← pakai helper
              ),
            ),

            // ── Product Info ───────────────────────
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  const Row(
                    children: [
                      Icon(Icons.star,
                        color: AppTheme.starYellow, size: 14),
                      SizedBox(width: 2),
                      Text('4.8',
                        style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Nama produk
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Harga — tanpa tombol Add
                  Text(
                    product.formattedPrice,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}