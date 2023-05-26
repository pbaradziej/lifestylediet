import 'package:lifestylediet/shared_repositories/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightProvider extends SharedPreferencesProvider {
  static const String _key = 'DAILY_WEIGHT_UPDATED';

  Future<void> saveWeightUpdate(final bool uid) async {
    await withPreferences<void>((final SharedPreferences preferences) async {
      await preferences.setBool(_key, uid);
    });
  }

  Future<bool> readWeightUpdate() async {
    return withPreferences<bool>((final SharedPreferences preferences) {
      return preferences.getBool(_key) ?? false;
    });
  }
}
