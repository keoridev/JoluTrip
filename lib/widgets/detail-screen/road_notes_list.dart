import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/utils/road_helpers.dart';

class RoadNotesList extends StatelessWidget {
  final List<String> roadNotes;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardColor;

  const RoadNotesList({
    super.key,
    required this.roadNotes,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    if (roadNotes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimens.spaceL),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : Colors.black.withOpacity(0.08),
          ),
        ),
        child: Center(
          child: Text(
            "Информация о дороге отсутствует",
            style: AppTextStyles.bodyMedium.copyWith(
              color: textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.route_outlined,
              color: AppColors.primary,
              size: AppDimens.iconSizeM,
            ),
            const SizedBox(width: AppDimens.spaceXS),
            Text(
              "Особенности дороги",
              style: AppTextStyles.bodyLarge.copyWith(
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        ...roadNotes.map((note) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceS),
              child: Container(
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
              ),
            )),
      ],
    );
  }
}
