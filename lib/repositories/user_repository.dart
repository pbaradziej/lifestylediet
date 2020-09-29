import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifestylediet/models/models.dart';

class UserRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  register(Users users) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: users.email,
        password: users.password,
      );
    } catch (LocalizedException) {
      return false;
    }
    return true;
  }

  login(Users users) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: users.email,
        password: users.password,
      );
      _user = result.user;
    } catch (LocalizedException) {
      return false;
    }
    return true;
  }

  logout() async {
    return await _auth.signOut();
  }

  String get uid => _user.uid;
}
