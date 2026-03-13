import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';

class CategoryGrid extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceS),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceM),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 90,
              margin: const EdgeInsets.only(right: AppDimens.spaceS),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : isDark
                        ? Colors.grey[850]
                        : Colors.grey[100],
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                border: !isSelected
                    ? Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      )
                    : null,
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Горы':
        return Icons.terrain;
      case 'Озеро':
        return Icons.water;
      case 'Исторические':
        return Icons.history_edu;
      default:
        return Icons.explore;
    }
  }
}
