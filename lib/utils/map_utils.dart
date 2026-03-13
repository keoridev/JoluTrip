import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  // Получение URL тайлов для карты
  static String getTileUrl(bool isDark) {
    if (isDark) {
      // CartoDB Dark Matter (работает без ключа)
      return 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
    } else {
      return 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  static List<String> getSubdomains(bool isDark) {
    return isDark ? ['a', 'b', 'c', 'd'] : ['a', 'b', 'c'];
  }

  // Google Maps
  static Future<void> openInGoogleMaps({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1"
      "&query=$latitude,$longitude",
    );
    await _launchUrl(uri);
  }

  static Future<void> buildRouteInGoogleMaps({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&destination=$latitude,$longitude",
    );
    await _launchUrl(uri);
  }

  // 2ГИС (веб-версия, без ключа)
  static Future<void> openIn2GISWeb({
    required double latitude,
    required double longitude,
    String? placeName,
  }) async {
    // Веб-версия 2ГИС
    final uri = Uri.parse('https://2gis.ru/geo/$longitude,$latitude');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      debugPrint('Error opening 2GIS: $e');
    }
  }

  // Построение маршрута в 2ГИС
  static Future<void> buildRouteIn2GIS({
    required double latitude,
    required double longitude,
    String? placeName,
  }) async {
    // Маршрут в веб-версии 2ГИС
    final uri = Uri.parse('https://2gis.ru/geo/$longitude,$latitude/route');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening 2GIS route: $e');
    }
  }

  // Попытка открыть в приложении 2ГИС (если установлено)
  static Future<void> openIn2GISApp({
    required double latitude,
    required double longitude,
    String? placeName,
  }) async {
    // Deep link для мобильного приложения 2ГИС
    final uri =
        Uri.parse('dgis://2gis.ru/routeSearch/rsType/car/from/undefined/'
            'to/$longitude,$latitude');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Если приложение не установлено, открываем веб-версию
        await openIn2GISWeb(
          latitude: latitude,
          longitude: longitude,
          placeName: placeName,
        );
      }
    } catch (e) {
      debugPrint('Error opening 2GIS app: $e');
    }
  }

  static Future<void> _launchUrl(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
