// lib/services/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateToVideo(BuildContext context, LocationModel location) {
    // Вариант 1: Используем именованные маршруты (рекомендуется)
    return Navigator.pushNamed(
      context,
      '/video-feed',
      arguments: location.id,
    );
  }

  Future<void> navigateToVideoWithData(
      BuildContext context, LocationModel location) {
    // Вариант 2: Передаем всю модель (если нужно)
    return Navigator.pushNamed(
      context,
      '/video-player',
      arguments: location,
    );
  }
}
