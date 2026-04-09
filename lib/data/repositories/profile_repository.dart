import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jolu_trip/data/models/location_model.dart';

class ProfileRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? get _userId => _auth.currentUser?.uid;
  bool get isUserLoggedIn => _userId != null;

  // ==================== AUTH OPERATIONS ====================

  /// Get current authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Stream of authentication state changes
  Stream<User?> getAuthStateChanges() {
    return _auth.authStateChanges();
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ==================== FAVORITES OPERATIONS ====================

  /// Get the favorites subcollection for current user
  CollectionReference get _favoritesCollection {
    if (_userId == null) {
      throw Exception('Пользователь не авторизован');
    }
    return _firestore.collection('users').doc(_userId).collection('favorites');
  }

  /// Add location to favorites
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
      rethrow;
    }
  }

  /// Remove location from favorites
  Future<void> removeFromFavorites(String locationId) async {
    if (!isUserLoggedIn) {
      throw Exception('Необходимо авторизоваться');
    }

    try {
      await _favoritesCollection.doc(locationId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if location is in favorites
  Future<bool> isFavorite(String locationId) async {
    if (!isUserLoggedIn) return false;

    try {
      final doc = await _favoritesCollection.doc(locationId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Stream of favorited locations
  Stream<List<LocationModel>> getFavoritesStream(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .snapshots()
          .asyncMap((snapshot) async {
        final favorites = <LocationModel>[];
        for (var doc in snapshot.docs) {
          final locationDoc = await _firestore
              .collection('locations')
              .doc(doc['locationId'])
              .get();

          if (locationDoc.exists) {
            favorites.add(
              LocationModel.fromFirestore(
                locationDoc.id,
                locationDoc.data()!,
              ),
            );
          }
        }
        return favorites;
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  /// Stream of favorite status for a specific location
  Stream<bool> isFavoriteStream(String locationId) {
    if (!isUserLoggedIn) {
      return Stream.value(false);
    }

    return _favoritesCollection
        .doc(locationId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// Get count of favorited locations
  Future<int> getFavoritesCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Stream of favorites count
  Stream<int> getFavoritesCountStream() {
    if (!isUserLoggedIn) {
      return Stream.value(0);
    }

    return _favoritesCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
