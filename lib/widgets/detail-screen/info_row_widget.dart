import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/utils/video_helpers.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class InfoRowWidget extends StatelessWidget {
  final LocationModel location;

  const InfoRowWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);
    final bgColor = isDark
        ? Colors.white.withOpacity(0.03)
        : Colors.black.withOpacity(0.02);

    return Container(
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: AppDimens.spaceXS,
        crossAxisSpacing: AppDimens.spaceXS,
        childAspectRatio: 2.2,
        children: [
          _buildBentoItem(
            Icons.access_time_rounded,
            "${location.travelTime} мин",
            AppLocalizations.of(context)!.travelTime,
            textSecondary,
            borderColor,
            bgColor,
          ),
          _buildBentoItem(
            Icons.terrain_outlined,
            VideoHelpers.getDifficultyLabel(location.difficult),
            AppLocalizations.of(context)!.routeDifficulty,
            textSecondary,
            borderColor,
            bgColor,
          ),
          _buildBentoItem(
            location.hasSignal
                ? Icons.sensors_rounded
                : Icons.sensors_off_rounded,
            location.hasSignal
                ? AppLocalizations.of(context)!.available
                : AppLocalizations.of(context)!.unavailable,
            AppLocalizations.of(context)!.mobileSignal,
            textSecondary,
            borderColor,
            bgColor,
          ),
          _buildBentoItem(
            Icons.directions_car_outlined,
            location.carType,
            AppLocalizations.of(context)!.carType,
            textSecondary,
            borderColor,
            bgColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBentoItem(
    IconData icon,
    String value,
    String label,
    Color textSecondary,
    Color borderColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceS,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Иконка
          Icon(
            icon,
            color: textSecondary,
            size: AppDimens.iconSizeM,
          ),
          const SizedBox(width: AppDimens.spaceS),

          // Текстовая часть
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.featureLabel.copyWith(
                    color: textSecondary.withOpacity(0.5),
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXXS),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
