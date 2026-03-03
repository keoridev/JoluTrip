import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/utils/road_helpers.dart';

class RoadNoteItem extends StatelessWidget {
  final String note;
  final bool isDark;
  final Color cardColor;
  final Color textSecondary;

  const RoadNoteItem({
    super.key,
    required this.note,
    required this.isDark,
    required this.cardColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceM),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceXS),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              RoadHelpers.getRoadNoteIcon(note),
              color: AppColors.primary,
              size: AppDimens.iconSizeS,
            ),
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
