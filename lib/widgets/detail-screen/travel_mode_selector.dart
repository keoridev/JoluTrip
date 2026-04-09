import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/widgets/detail-screen/mode_button.dart';
import 'package:jolu_trip/widgets/detail-screen/self_guided_section.dart';
import 'package:jolu_trip/widgets/guide/guide_card_widget.dart';

import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class TravelModeSelector extends StatefulWidget {
  final LocationModel location;
  final List<GuidesModel> guides;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardColor;

  const TravelModeSelector({
    super.key,
    required this.location,
    required this.guides,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardColor,
  });

  @override
  State<TravelModeSelector> createState() => _TravelModeSelectorState();
}

class _TravelModeSelectorState extends State<TravelModeSelector> {
  bool _isWithGuide = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.howWillWeGo,
          style: AppTextStyles.headlineMedium.copyWith(
            color: widget.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimens.spaceM),

        // Сегментированный контроллер
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceXS),
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          ),
          child: Row(
            children: [
              Expanded(
                child: ModeButton(
                  isSelected: _isWithGuide,
                  label: l10n.withGuide,
                  icon: Icons.person_outline,
                  isDark: widget.isDark,
                  onTap: () => setState(() => _isWithGuide = true),
                ),
              ),
              const SizedBox(width: AppDimens.spaceXS),
              Expanded(
                child: ModeButton(
                  isSelected: !_isWithGuide,
                  label: l10n.selfGuided,
                  icon: Icons.directions_car_outlined,
                  isDark: widget.isDark,
                  onTap: () => setState(() => _isWithGuide = false),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimens.spaceL),

        // Контент в зависимости от режима
        if (_isWithGuide) ...[
          _buildGuidesSection(),
        ] else ...[
          SelfGuidedSection(
            location: widget.location,
            isDark: widget.isDark,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
            cardColor: widget.cardColor,
          ),
        ],
      ],
    );
  }

  Widget _buildGuidesSection() {
    final l10n = AppLocalizations.of(context)!;

    if (widget.guides.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.availableGuides,
            style: AppTextStyles.headlineMedium.copyWith(
              color: widget.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),
          SizedBox(
            height: AppDimens.guideVideoThumbHeight + 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.guides.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == widget.guides.length - 1
                        ? 0
                        : AppDimens.spaceS,
                  ),
                  child: GuideCardWidget(
                    guide: widget.guides[index],
                    location: widget.location,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // Если гидов нет
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceL),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.black.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_off_outlined,
            size: AppDimens.iconSizeL,
            color: widget.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Text(
            l10n.temporarilyNoGuidesAvailable,
            style: AppTextStyles.bodyMedium.copyWith(
              color: widget.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
