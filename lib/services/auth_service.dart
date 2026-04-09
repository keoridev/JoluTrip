// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== ВХОД С EMAIL/PASSWORD ====================
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Пробрасываем специфичные ошибки для обработки в UI
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Произошла неизвестная ошибка');
    }
  }

  // ==================== РЕГИСТРАЦИЯ ====================
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Произошла неизвестная ошибка');
    }
  }

  // ==================== ВХОД С GOOGLE ====================
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Вход отменен');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Ошибка входа через Google');
    }
  }

  // ==================== ВХОД С APPLE ====================
  Future<UserCredential> signInWithApple() async {
    throw UnimplementedError('Sign in with Apple еще не реализован');
  }

  // ==================== ВЫХОД ====================
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
    } catch (e) {
      print('Sign-Out Error: $e');
      rethrow;
    }
  }

  // ==================== ОБНОВЛЕНИЕ ПРОФИЛЯ ====================
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
        // Важно! Обновляем профиль
        await user.reload();
      }
    } catch (e) {
      print('Update Profile Error: $e');
      rethrow;
    }
  }

  // ==================== СБРОС ПАРОЛЯ ====================
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // ==================== ОБРАБОТКА ОШИБОК ====================
  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Пользователь не найден');
      case 'wrong-password':
        return Exception('Неверный пароль');
      case 'email-already-in-use':
        return Exception('Email уже используется');
      case 'weak-password':
        return Exception('Слишком простой пароль');
      case 'network-request-failed':
        return Exception('Ошибка сети. Проверьте подключение');
      case 'invalid-email':
        return Exception('Некорректный email');
      case 'user-disabled':
        return Exception('Аккаунт заблокирован');
      case 'too-many-requests':
        return Exception('Слишком много попыток. Попробуйте позже');
      case 'operation-not-allowed':
        return Exception('Операция не разрешена');
      default:
        return Exception('Произошла ошибка: ${e.message}');
    }
  }
}
