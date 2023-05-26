import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesProvider {
  const SharedPreferencesProvider();

  Future<T> withPreferences<T>(FutureOr<T> closure(final SharedPreferences preferences)) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return closure(preferences);
  }
}
