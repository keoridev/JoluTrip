import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class ModeButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const ModeButton({
    super.key,
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.spaceS,
          horizontal: AppDimens.spaceXS,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDimens.iconSizeS,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(width: AppDimens.spaceXS),
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white60 : Colors.black54),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
