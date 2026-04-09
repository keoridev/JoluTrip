import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/services/favorites_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Состояния
  List<LocationModel> _favorites = [];
  bool _isLoading = false;
  String? _error;
  Stream<List<LocationModel>>? _favoritesStream;
  bool _isInitialized = false;

  // Getters
  List<LocationModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isUserLoggedIn => _favoritesService.isUserLoggedIn;

  // Инициализация с проверкой авторизации
  void init() {
    if (_isInitialized) return;

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _startListeningFavorites();
      } else {
        _favorites = [];
        _favoritesStream = null;
        _isLoading = false;
        notifyListeners();
      }
    });

    _isInitialized = true;
  }

  void _startListeningFavorites() {
    _favoritesStream = _favoritesService.getFavoritesStream();
    _favoritesStream?.listen(
      (favorites) {
        _favorites = favorites;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Проверить конкретную локацию в избранном
  Stream<bool> isFavoriteStream(String locationId) {
    return _favoritesService.isFavoriteStream(locationId);
  }

  // Добавить/удалить из избранного
  Future<void> toggleFavorite(String locationId) async {
    if (!isUserLoggedIn) {
      throw Exception('Не авторизован');
    }

    try {
      final isFav = await _favoritesService.isFavorite(locationId);
      if (isFav) {
        await _favoritesService.removeFromFavorites(locationId);
      } else {
        await _favoritesService.addToFavorites(locationId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clear() {
    _favorites = [];
    _favoritesStream = null;
    _isInitialized = false;
  }
}

class ScrollUtils {
  static double calculateCollapseProgress(
      double scrollOffset, double expandedHeight, double toolbarHeight) {
    return (scrollOffset / (expandedHeight - toolbarHeight)).clamp(0.0, 1.0);
  }

  static double calculateParallaxOffset(
      double scrollOffset, double factor, double maxOffset) {
    return (scrollOffset * factor).clamp(0.0, maxOffset);
  }

  static double calculateGradientOpacity(
      double progress, double baseOpacity, double progressFactor) {
    return (baseOpacity + progress * progressFactor).clamp(0.0, 0.9);
  }

  static double calculateHeaderOpacity(double progress, double factor) {
    return (1.0 - progress * factor).clamp(0.0, 1.0);
  }

  static double calculateTitleOpacity(
      double progress, double threshold, double factor) {
    return ((progress - threshold) / factor).clamp(0.0, 1.0);
  }

  static double calculateButtonOpacity(double progress, double factor) {
    return (1.0 - progress * factor).clamp(0.0, 1.0);
  }
}
