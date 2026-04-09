// lib/services/favorites_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jolu_trip/data/models/location_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Получить ID текущего пользователя
  String? get _userId => _auth.currentUser?.uid;

  // Проверить, авторизован ли пользователь
  bool get isUserLoggedIn => _userId != null;

  // Получить путь к избранному пользователя
  CollectionReference get _favoritesCollection {
    if (_userId == null) {
      throw Exception('Пользователь не авторизован');
    }
    return _firestore.collection('users').doc(_userId).collection('favorites');
  }

  // Добавить в избранное
  Future<void> addToFavorites(String locationId) async {
    if (!isUserLoggedIn) {
      throw Exception('Необходимо авторизоваться');
    }

    try {
      await _favoritesCollection.doc(locationId).set({
        'locationId': locationId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Ошибка добавления в избранное: $e');
      rethrow;
    }
  }

  // Удалить из избранного
  Future<void> removeFromFavorites(String locationId) async {
    if (!isUserLoggedIn) {
      throw Exception('Необходимо авторизоваться');
    }

    try {
      await _favoritesCollection.doc(locationId).delete();
    } catch (e) {
      print('Ошибка удаления из избранного: $e');
      rethrow;
    }
  }

  // Проверить, в избранном ли
  Future<bool> isFavorite(String locationId) async {
    if (!isUserLoggedIn) return false;

    try {
      final doc = await _favoritesCollection.doc(locationId).get();
      return doc.exists;
    } catch (e) {
      print('Ошибка проверки избранного: $e');
      return false;
    }
  }

  // Получить все избранные локации
  Stream<List<LocationModel>> getFavoritesStream() {
    if (!isUserLoggedIn) {
      return Stream.value([]);
    }

    return _favoritesCollection.snapshots().asyncMap((snapshot) async {
      final List<LocationModel> favorites = [];

      for (var doc in snapshot.docs) {
        final locationId = doc.id;
        try {
          final locationDoc =
              await _firestore.collection('locations').doc(locationId).get();

          if (locationDoc.exists) {
            final data = locationDoc.data();
            if (data != null) {
              favorites.add(LocationModel.fromFirestore(
                locationDoc.id,
                data,
              ));
            }
          }
        } catch (e) {
          print('Ошибка загрузки локации $locationId: $e');
        }
      }

      return favorites;
    });
  }

  // Подписка на изменения статуса избранного для конкретной локации
  Stream<bool> isFavoriteStream(String locationId) {
    if (!isUserLoggedIn) {
      return Stream.value(false);
    }

    return _favoritesCollection
        .doc(locationId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Получить количество избранных локаций
  Stream<int> getFavoritesCountStream() {
    if (!isUserLoggedIn) {
      return Stream.value(0);
    }

    return _favoritesCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
