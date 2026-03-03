import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/constants/app_colors.dart';

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXS,
        vertical: AppDimens.spaceXXS,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : AppColors.textPrimaryLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : AppColors.textSecondaryLight.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
            size: AppDimens.iconSizeS,
          ),
          const SizedBox(width: AppDimens.spaceXXS),
          Text(
            label,
            style: AppTextStyles.featureLabel.copyWith(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
