import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jolu_trip/data/models/coordinates.model.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

// ==================== МАРКЕР ====================
class LocationMarker extends Marker {
  LocationMarker({
    required LatLng point,
    required VoidCallback onTap,
  }) : super(
          point: point,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.location_pin,
              color: AppColors.primary,
              size: 40,
            ),
          ),
        );
}

// ==================== ИНФОРМАЦИОННАЯ КАРТОЧКА ====================
class LocationInfoCard extends StatelessWidget {
  final String locationName;
  final Coordinates coordinates;
  final bool isDark;

  const LocationInfoCard({
    super.key,
    required this.locationName,
    required this.coordinates,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceS),
      decoration: BoxDecoration(
        color: isDark ? Colors.black54 : Colors.white70,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.place, color: Colors.white, size: 16),
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${coordinates.latitude.toStringAsFixed(4)}, "
                  "${coordinates.longitude.toStringAsFixed(4)}",
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== КНОПКИ УПРАВЛЕНИЯ ====================
class MapControls extends StatelessWidget {
  final bool isDark;
  final VoidCallback onOpenMaps;
  final VoidCallback onFullscreen;

  const MapControls({
    super.key,
    required this.isDark,
    required this.onOpenMaps,
    required this.onFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: AppDimens.spaceM,
          right: AppDimens.spaceM,
          child: FloatingActionButton.small(
            heroTag: 'osm_open',
            onPressed: onOpenMaps,
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            child: Icon(
              Icons.open_in_new,
              color: AppColors.primary,
              size: AppDimens.iconSizeS,
            ),
          ),
        ),
        Positioned(
          bottom: AppDimens.spaceM,
          right: AppDimens.spaceM + 56,
          child: FloatingActionButton.small(
            heroTag: 'osm_fullscreen',
            onPressed: onFullscreen,
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            child: Icon(
              Icons.fullscreen,
              color: AppColors.primary,
              size: AppDimens.iconSizeS,
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== НИЖНЯЯ ПАНЕЛЬ ====================
class LocationInfoBottomSheet extends StatelessWidget {
  final String locationName;
  final Coordinates coordinates;
  final bool isDark;
  final VoidCallback onOpenMaps;

  const LocationInfoBottomSheet({
    super.key,
    required this.locationName,
    required this.coordinates,
    required this.isDark,
    required this.onOpenMaps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceL),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locationName,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Text(
            "Координаты: ${coordinates.latitude.toStringAsFixed(6)}, "
            "${coordinates.longitude.toStringAsFixed(6)}",
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onOpenMaps,
                  icon: const Icon(Icons.map),
                  label: const Text("Открыть в Maps"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Закрыть"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
