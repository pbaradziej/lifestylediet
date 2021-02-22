import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifestylediet/models/models.dart';

class UserRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  register(Users users) async {
    UserCredential result;
    try {
      result = await _auth.createUserWithEmailAndPassword(
        email: users.email,
        password: users.password,
      );
    } catch (PlatformException) {}
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  login(Users users) async {
    UserCredential result;
    try {
      _auth.idTokenChanges();
      result = await _auth.signInWithEmailAndPassword(
        email: users.email,
        password: users.password,
      );
      _user = result.user;
    } catch (PlatformException) {}
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (Exception) {}
  }

  verifyEmail() async {
    await _auth.currentUser.sendEmailVerification();
  }

  logout() async {
    return await _auth.signOut();
  }

  String get uid => _user.uid;

  bool get emailVerified => _user.emailVerified;
}
