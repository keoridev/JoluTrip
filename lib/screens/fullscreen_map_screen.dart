import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jolu_trip/widgets/detail-screen/map/map_components.dart';
import 'package:latlong2/latlong.dart';
import 'package:jolu_trip/data/models/coordinates.model.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/utils/map_utils.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

class FullscreenMapScreen extends StatelessWidget {
  final Coordinates coordinates;
  final String locationName;
  final bool isDark;

  const FullscreenMapScreen({
    super.key,
    required this.coordinates,
    required this.locationName,
    required this.isDark,
  });

  LatLng get _point => LatLng(coordinates.latitude, coordinates.longitude);

  // Используем MapUtils для получения URL тайлов
  String get _tileUrl => MapUtils.getTileUrl(isDark);
  List<String> get _subdomains => MapUtils.getSubdomains(isDark);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName, style: AppTextStyles.bodyLarge),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.map),
            tooltip: AppLocalizations.of(context)!.chooseMap,
            onSelected: (value) {
              if (value == 'google') {
                _openInGoogleMaps();
              } else if (value == '2gis') {
                _openIn2GIS();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'google',
                child: Row(
                  children: [
                    Icon(Icons.map, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text('Google Maps'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: '2gis',
                child: Row(
                  children: [
                    Icon(Icons.map, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text('2ГИС'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _point,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: _tileUrl,
            subdomains: _subdomains,
            userAgentPackageName: 'com.example.jolu_trip',
          ),
          MarkerLayer(
            markers: [
              LocationMarker(
                point: _point,
                onTap: () => _showPlaceInfo(context),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRouteOptions(context),
        icon: const Icon(Icons.directions_car),
        label: Text(AppLocalizations.of(context)!.buildRoute),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showRouteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              AppLocalizations.of(context)!.buildRoute,
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: AppDimens.spaceM),

            // Google Maps
            _buildRouteButton(
              icon: Icons.map,
              label: 'Google Maps',
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
                _openInGoogleMapsDirections();
              },
            ),
            const SizedBox(height: AppDimens.spaceS),

            // 2ГИС
            _buildRouteButton(
              icon: Icons.map,
              label: '2ГИС',
              color: Colors.orange,
              onPressed: () {
                Navigator.pop(context);
                _openIn2GISDirections();
              },
            ),
            const SizedBox(height: AppDimens.spaceS),

            // Отмена
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: Text(AppLocalizations.of(context)!.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteButton({
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

  // Открыть в Google Maps (просмотр)
  Future<void> _openInGoogleMaps() async {
    await MapUtils.openInGoogleMaps(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
  }

  // Открыть в Google Maps (маршрут)
  Future<void> _openInGoogleMapsDirections() async {
    await MapUtils.buildRouteIn2GIS(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
  }

  // Открыть в 2ГИС (просмотр)
  Future<void> _openIn2GIS() async {
    await MapUtils.openIn2GISWeb(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      placeName: locationName,
    );
  }

  // Открыть в 2ГИС (маршрут)
  Future<void> _openIn2GISDirections() async {
    await MapUtils.buildRouteIn2GIS(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      placeName: locationName,
    );
  }

  void _showPlaceInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.map,
                    label: "Google",
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                      _openInGoogleMaps();
                    },
                  ),
                ),
                const SizedBox(width: AppDimens.spaceS),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.map,
                    label: "2ГИС",
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.pop(context);
                      _openIn2GIS();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceS),

            // Кнопка маршрута
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showRouteOptions(context);
                },
                icon: const Icon(Icons.directions_car),
                label: Text(AppLocalizations.of(context)!.buildRoute),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceS),

            // Кнопка закрытия
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
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
