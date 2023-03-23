import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _auth;

  UserRepository() : _auth = FirebaseAuth.instance;

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        //TODO obsłużyć pełna rejestracje
        email: email,
        password: password,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      _auth.idTokenChanges();
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        //TODO obsłużyć pełne logowanie
        email: email,
        password: password,
      );
      return result.user;
    } catch (_) {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (_) {}
  }

  Future<void> verifyEmail() async {
    final User? currentUser = _auth.currentUser;
    await currentUser?.sendEmailVerification();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
