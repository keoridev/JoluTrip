import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jolu_trip/data/models/coordinates.model.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class CoordinatesCard extends StatelessWidget {
  final Coordinates coordinates;
  final bool isDark;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;

  const CoordinatesCard({
    super.key,
    required this.coordinates,
    required this.isDark,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceM),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.black.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Метка места
          if (coordinates.label.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: AppDimens.iconSizeS,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimens.spaceXXS),
                Expanded(
                  child: Text(
                    coordinates.label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceS),
          ],

          // Координаты + кнопки действий
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimens.spaceS,
              horizontal: AppDimens.spaceM,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Строка с координатами и кнопкой копирования
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${coordinates.latitude.toStringAsFixed(6)}, "
                          "${coordinates.longitude.toStringAsFixed(6)}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXXS),
                        Text(
                          "Координаты места",
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    // Кнопка копирования
                    GestureDetector(
                      onTap: () => _copyCoordinates(context),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.spaceXS),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.06),
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusRound),
                        ),
                        child: Icon(
                          Icons.copy_rounded,
                          color: textSecondary,
                          size: AppDimens.iconSizeS,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimens.spaceS),

                // Разделитель
                Divider(
                  height: 1,
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.06),
                ),

                const SizedBox(height: AppDimens.spaceS),

                Row(
                  children: [
                    Expanded(
                      child: _MapButton(
                        label: "Google Maps",
                        icon: Icons.map_rounded,
                        color: const Color(0xFF4285F4),
                        onTap: () => _openInGoogleMaps(context),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceS),
                    // Маршрут
                    Expanded(
                      child: _MapButton(
                        label: "Маршрут",
                        icon: Icons.directions_rounded,
                        color: AppColors.primary,
                        onTap: () => _openDirections(context),
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyCoordinates(BuildContext context) {
    final text =
        "${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}";
    Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Координаты скопированы"),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      );
    }
  }

  Future<void> _openInGoogleMaps(BuildContext context) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1"
      "&query=${coordinates.latitude},${coordinates.longitude}",
    );
    await _launchUri(context, uri);
  }

  Future<void> _openDirections(BuildContext context) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&destination=${coordinates.latitude},${coordinates.longitude}",
    );
    await _launchUri(context, uri);
  }

  Future<void> _launchUri(BuildContext context, Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Не удалось открыть Google Maps"),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Ошибка открытия карты: $e");
    }
  }
}

// ── Кнопка для открытия в картах ─────────────────────────────────
class _MapButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _MapButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.spaceXS,
          horizontal: AppDimens.spaceS,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          border: Border.all(
            color: color.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppDimens.iconSizeS),
            const SizedBox(width: AppDimens.spaceXXS),
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
