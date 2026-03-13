import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceM,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[100],
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Поиск мест...',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                    icon: Icon(
                      Icons.clear,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceM,
              vertical: AppDimens.spaceS,
            ),
          ),
        ),
      ),
    );
  }
}
