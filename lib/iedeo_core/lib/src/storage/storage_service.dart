import 'package:shared_preferences/shared_preferences.dart';

/// A service class to manage local storage of app-specific data using SharedPreferences.
///
/// Example usage:
/// ```dart
/// await StorageService.init();
/// StorageService.saveAccessToken('mytoken');
/// final token = StorageService.getAccessToken();
/// ```
class StorageService {
  static SharedPreferences? _prefs;

  /// Keys for stored items (you can define more as needed)
  static const String _keyAccessToken = 'access_token';

  /// Keys for stored items (you can define more as needed)
  static const String _keyPushToken = 'push_token';

  /// Initializes the StorageService by loading SharedPreferences instance.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Stores the access token.
  static Future<bool> saveAccessToken(String token) async {
    if (_prefs == null) {
      await init();
    }
    return _prefs?.setString(_keyAccessToken, token) ?? Future.value(false);
  }

  /// Retrieves the stored access token.
  static String? getAccessToken() {
    return _prefs?.getString(_keyAccessToken);
  }

  /// Clears the stored access token.
  static Future<bool> clearAccessToken() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs?.remove(_keyAccessToken) ?? Future.value(false);
  }

  /// Stores the push token.
  static Future<bool> savePushToken(String token) async {
    if (_prefs == null) {
      await init();
    }
    return _prefs?.setString(_keyPushToken, token) ?? Future.value(false);
  }

  /// Retrieves the stored push token.
  static String? getPushToken() {
    return _prefs?.getString(_keyPushToken);
  }

  /// Clears the stored access token.
  static Future<bool> clearPushToken() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs?.remove(_keyPushToken) ?? Future.value(false);
  }

  // Example for storing any generic key-value pair
  static Future<bool> setValue(String key, String value) async {
    if (_prefs == null) {
      await init();
    }
    return _prefs?.setString(key, value) ?? Future.value(false);
  }

  static String? getValue(String key) {
    return _prefs?.getString(key);
  }

  /// Clear all local storage (use with caution!)
  static Future<bool> clearAll() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs?.clear() ?? Future.value(false);
  }
}
