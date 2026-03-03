import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> openInGoogleMaps({
    required double latitude,
    required double longitude,
    bool forDirections = false,
  }) async {
    final String baseUrl = forDirections
        ? "https://www.google.com/maps/dir/?api=1"
        : "https://www.google.com/maps/search/?api=1";

    final uri = Uri.parse(
      "$baseUrl&query=$latitude,$longitude",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static String getTileUrl(bool isDark) {
    return isDark
        ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png'
        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  }

  static List<String> getSubdomains(bool isDark) {
    return isDark ? [] : ['a', 'b', 'c'];
  }
}
