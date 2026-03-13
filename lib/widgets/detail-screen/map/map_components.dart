import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final VoidCallback onOpen2GIS;
  final VoidCallback onFullscreen;
  final VoidCallback onOpenMaps;

  const MapControls({
    super.key,
    required this.isDark,
    required this.onOpen2GIS,
    required this.onFullscreen,
    required this.onOpenMaps,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Кнопка Google Maps
        Positioned(
          bottom: AppDimens.spaceM,
          right: AppDimens.spaceM,
          child: FloatingActionButton.small(
            heroTag: 'google_maps',
            onPressed: onOpenMaps,
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            child: Icon(
              Icons.map,
              color: Colors.blue,
              size: AppDimens.iconSizeS,
            ),
          ),
        ),

        // Кнопка 2ГИС
        Positioned(
          bottom: AppDimens.spaceM,
          right: AppDimens.spaceM + 56,
          child: FloatingActionButton.small(
            heroTag: '2gis',
            onPressed: onOpen2GIS,
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            child: Icon(
              Icons.map,
              color: Colors.orange,
              size: AppDimens.iconSizeS,
            ),
          ),
        ),

        // Кнопка полноэкранного режима
        Positioned(
          bottom: AppDimens.spaceM,
          right: AppDimens.spaceM + 112,
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
  final VoidCallback onOpenGoogleMaps;
  final VoidCallback onOpen2GIS;

  const LocationInfoBottomSheet({
    super.key,
    required this.locationName,
    required this.coordinates,
    required this.isDark,
    required this.onOpenGoogleMaps,
    required this.onOpen2GIS,
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

          // Кнопки для разных карт
          _buildMapButton(
            icon: Icons.map,
            label: "Открыть в Google Maps",
            color: Colors.blue,
            onPressed: onOpenGoogleMaps,
          ),
          const SizedBox(height: AppDimens.spaceS),

          _buildMapButton(
            icon: Icons.map,
            label: "Открыть в 2ГИС",
            color: Colors.orange,
            onPressed: onOpen2GIS,
          ),
          const SizedBox(height: AppDimens.spaceS),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text("Закрыть"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
