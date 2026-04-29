import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../category/presentation/category_provider.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  // Icon fallback per kategori
  IconData _iconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'pumps':      return Icons.water_drop_outlined;
      case 'valves':     return Icons.settings_input_component_outlined;
      case 'cylinders':  return Icons.height_outlined;
      case 'hoses':      return Icons.cable_outlined;
      case 'fittings':   return Icons.build_outlined;
      case 'accessories':return Icons.extension_outlined;
      default:           return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final cats = provider.categories;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: cats.length,
          itemBuilder: (_, i) {
            final cat = cats[i];
            return GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_iconForCategory(cat.name),
                      size: 32, color: AppTheme.darkNavy),
                    const SizedBox(height: 8),
                    Text(cat.name,
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500,
                        color: AppTheme.darkNavy,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}