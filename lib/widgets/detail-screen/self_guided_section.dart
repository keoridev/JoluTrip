import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/widgets/detail-screen/map/coordinates_card.dart';
import 'package:jolu_trip/widgets/detail-screen/map/location_map.dart';
import 'package:jolu_trip/widgets/detail-screen/road_notes_list.dart';
import 'package:jolu_trip/widgets/ui/divider.dart';

class SelfGuidedSection extends StatelessWidget {
  final LocationModel location;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardColor;

  const SelfGuidedSection({
    super.key,
    required this.location,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Заголовок секции ─────────────────────────────────────────
        _SectionHeader(isDark: isDark, textPrimary: textPrimary),
        const SizedBox(height: AppDimens.spaceM),

        // ── Карта ────────────────────────────────────────────────────
        LocationMap(
          coordinates: location.coordinates,
          locationName: location.name,
          isDark: isDark,
        ),
        const SizedBox(height: AppDimens.spaceM),

        // ── Координаты ───────────────────────────────────────────────
        CoordinatesCard(
          coordinates: location.coordinates,
          isDark: isDark,
          cardColor: cardColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),

        // ── Разделитель ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceL),
          child: DashedDivider(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.07),
          ),
        ),

        // ── Road Notes ───────────────────────────────────────────────
        RoadNotesList(
          roadNotes: location.roadNotes,
          isDark: isDark,
          cardColor: cardColor,
          textSecondary: textSecondary,
          textPrimary: textPrimary,
        ),
      ],
    );
  }
}

// ── Заголовок с pill-badge ───────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final bool isDark;
  final Color textPrimary;

  const _SectionHeader({required this.isDark, required this.textPrimary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.near_me_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: AppDimens.spaceS),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.howToGet.toUpperCase(),
              style: AppTextStyles.featureLabel.copyWith(
                color: AppColors.primary,
                letterSpacing: 1.4,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              "Маршрут и координаты",
              style: AppTextStyles.bodyMedium.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
