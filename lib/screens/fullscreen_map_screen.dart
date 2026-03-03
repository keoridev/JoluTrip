import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jolu_trip/widgets/detail-screen/map/map_components.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jolu_trip/data/models/coordinates.model.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

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

  String get _tileUrl => isDark
      ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png'
      : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName, style: AppTextStyles.bodyLarge),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: _openInGoogleMaps,
            tooltip: "Открыть в Google Maps",
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
            subdomains: isDark ? [] : ['a', 'b', 'c'],
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
        onPressed: _openInGoogleMapsDirections,
        icon: const Icon(Icons.directions_car),
        label: const Text("Построить маршрут"),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> _openInGoogleMaps() async {
    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1"
      "&query=${coordinates.latitude},${coordinates.longitude}",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openInGoogleMapsDirections() async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&destination=${coordinates.latitude},${coordinates.longitude}",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openInGoogleMapsDirections,
                    icon: const Icon(Icons.directions_car),
                    label: const Text("Маршрут"),
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
      ),
    );
  }
}
