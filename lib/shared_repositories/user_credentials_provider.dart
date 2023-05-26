import 'package:lifestylediet/shared_repositories/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCredentialsProvider extends SharedPreferencesProvider {
  static const String _uidKey = 'USER_UID';
  static const String _emailKey = 'USER_EMAIL';

  Future<void> saveUid(final String uid) async {
    await withPreferences<void>((final SharedPreferences preferences) async {
      await preferences.setString(_uidKey, uid);
    });
  }

  Future<String> readUid() async {
    return withPreferences<String>((final SharedPreferences preferences) {
      return preferences.getString(_uidKey) ?? '';
    });
  }

  Future<void> clearUid() async {
    return withPreferences<void>((final SharedPreferences preferences) {
      preferences.remove(_uidKey);
    });
  }

  Future<void> saveEmail(final String uid) async {
    await withPreferences<void>((final SharedPreferences preferences) async {
      await preferences.setString(_emailKey, uid);
    });
  }

  Future<String> readEmail() async {
    return withPreferences<String>((final SharedPreferences preferences) {
      return preferences.getString(_emailKey) ?? '';
    });
  }
}
