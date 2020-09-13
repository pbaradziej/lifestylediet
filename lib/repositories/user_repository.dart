import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifestylediet/models/models.dart';

class UserRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  register(Users user) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
    } catch (LocalizedException) {
      return false;
    }
    return true;
  }

  login(Users user) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
    } catch (LocalizedException) {
      return false;
    }
    return true;
  }

  logout() async {
    return await _auth.signOut();
  }
}
