import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository());

// StreamProvider для текущего пользователя - отслеживает изменения аутентификации
final currentUserProvider = StreamProvider<User?>((ref) {
  final repo = ref.read(profileRepositoryProvider);
  return repo.getAuthStateChanges();
});

// Provider для потока избранных локаций
final favoritesStreamProvider =
    StreamProvider.family<List<LocationModel>, String>((ref, userId) {
  final repo = ref.read(profileRepositoryProvider);
  return repo.getFavoritesStream(userId);
});

// Provider для количества избранных
final favoritesCountProvider =
    FutureProvider.family<int, String>((ref, userId) {
  final repo = ref.read(profileRepositoryProvider);
  return repo.getFavoritesCount(userId);
});

// Provider для выхода из аккаунта
final signOutProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(profileRepositoryProvider);
  await repo.signOut();
});
