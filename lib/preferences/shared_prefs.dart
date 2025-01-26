// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _prefs;

  SharedPrefs._();

  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences> init() async {
    _prefs = await _instance;
    return _prefs!;
  }

  static Future<bool> containsKey(KeysSharedPreferences key) async {
    var shared = await _instance;
    return shared.containsKey(key.value);
  }

  static String getString(KeysSharedPreferences key) {
    return _prefs?.getString(key.value) ?? '';
  }

  static Future<bool> setString(KeysSharedPreferences key, String value) async {
    var shared = await _instance;
    return shared.setString(key.value, value);
  }
}

enum KeysSharedPreferences {
  NOTIFICATION_TOKEN('notificationToken');

  const KeysSharedPreferences(this.value);

  final String value;
}
