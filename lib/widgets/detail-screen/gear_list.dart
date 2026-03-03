import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class GearList extends StatelessWidget {
  final List<String> gearList;
  final bool isDark;
  final Color textSecondary;
  final Color cardColor;

  const GearList({
    super.key,
    required this.gearList,
    required this.isDark,
    required this.textSecondary,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Что взять с собой",
          style: AppTextStyles.headlineMedium.copyWith(
            color: textSecondary,
          ),
        ),
        const SizedBox(height: AppDimens.spaceS),
        Wrap(
          spacing: AppDimens.spaceXS,
          runSpacing: AppDimens.spaceXS,
          children: gearList
              .map((item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceM,
                      vertical: AppDimens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.black.withOpacity(0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.backpack_outlined,
                          color: AppColors.primary,
                          size: AppDimens.iconSizeS,
                        ),
                        const SizedBox(width: AppDimens.spaceXXS),
                        Text(
                          item,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
