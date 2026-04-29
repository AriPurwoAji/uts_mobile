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
              blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12)),
                child: product.imageUrl.isNotEmpty
                  ? Image.network(product.imageUrl,
                      width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 50))
                  : Container(
                      color: AppTheme.lightGrey,
                      child: const Icon(Icons.water_drop,
                        size: 50, color: AppTheme.darkNavy)),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star,
                        color: AppTheme.starYellow, size: 14),
                      const SizedBox(width: 2),
                      const Text('4.8',
                        style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold,
                          color: AppTheme.darkNavy,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Add',
                          style: TextStyle(
                            color: Colors.white, fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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