import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jolu_trip/screens/fullscreen_map_screen.dart';
import 'package:jolu_trip/utils/map_utils.dart';
import 'package:jolu_trip/widgets/detail-screen/map/map_components.dart';
import 'package:latlong2/latlong.dart';
import 'package:jolu_trip/data/models/coordinates.model.dart';

import 'package:jolu_trip/constants/app_dimens.dart';

class LocationMap extends StatefulWidget {
  final Coordinates coordinates;
  final String locationName;
  final bool isDark;

  const LocationMap({
    super.key,
    required this.coordinates,
    required this.locationName,
    required this.isDark,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late final MapController _mapController = MapController();
  late final LatLng _point = LatLng(
    widget.coordinates.latitude,
    widget.coordinates.longitude,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        border: Border.all(
          color: widget.isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.black.withOpacity(0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _point,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: MapUtils.getTileUrl(widget.isDark),
                  subdomains: MapUtils.getSubdomains(widget.isDark),
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

            Positioned(
              top: AppDimens.spaceM,
              left: AppDimens.spaceM,
              right: AppDimens.spaceM,
              child: LocationInfoCard(
                locationName: widget.locationName,
                coordinates: widget.coordinates,
                isDark: widget.isDark,
              ),
            ),

            // Кнопки управления
            MapControls(
              onOpenMaps: _openInGoogleMaps,
              isDark: widget.isDark,
              onOpen2GIS: _openIn2GIS,
              onFullscreen: () => _openFullscreenMap(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullscreenMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullscreenMapScreen(
          coordinates: widget.coordinates,
          locationName: widget.locationName,
          isDark: widget.isDark,
        ),
      ),
    );
  }

  Future<void> _openInGoogleMaps() async {
    await MapUtils.openInGoogleMaps(
      latitude: widget.coordinates.latitude,
      longitude: widget.coordinates.longitude,
    );
  }

  Future<void> _openIn2GIS() async {
    await MapUtils.openIn2GISWeb(
      latitude: widget.coordinates.latitude,
      longitude: widget.coordinates.longitude,
      placeName: widget.locationName,
    );
  }

  void _showPlaceInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationInfoBottomSheet(
        locationName: widget.locationName,
        coordinates: widget.coordinates,
        isDark: widget.isDark,
        onOpenGoogleMaps: _openInGoogleMaps,
        onOpen2GIS: _openIn2GIS,
      ),
    );
  }
}
