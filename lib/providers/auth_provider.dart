import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jolu_trip/data/repositories/auth_repository.dart';

// ==================== REPOSITORY PROVIDER ====================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// ==================== AUTH STATE STREAM ====================

/// Watches Firebase authentication state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Convenience alias for current user
final currentUserProvider = FutureProvider<User?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  return user;
});

// ==================== SIGN IN / SIGN UP ====================

final signInWithEmailProvider =
    FutureProvider.family<UserCredential, (String, String)>(
        (ref, params) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.signInWithEmail(params.$1, params.$2);
});

final signUpWithEmailProvider =
    FutureProvider.family<UserCredential, (String, String)>(
        (ref, params) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.signUpWithEmail(params.$1, params.$2);
});

final signInWithGoogleProvider = FutureProvider<UserCredential>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.signInWithGoogle();
});

// ==================== SIGN OUT ====================

final signOutProvider = FutureProvider<void>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.signOut();
});

// ==================== HELPER FUNCTIONS ====================

/// Get the current user synchronously if already loaded
extension AuthStateProviderExt on ProviderContainer {
  User? getCurrentUserSync() {
    final authState = read(authStateProvider);
    return authState.maybeWhen(data: (user) => user, orElse: () => null);
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return getCurrentUserSync() != null;
  }
}
