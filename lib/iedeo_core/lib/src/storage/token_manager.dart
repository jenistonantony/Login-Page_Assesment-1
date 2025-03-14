import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const _accessTokenKey = 'accessToken';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }

  /// Check if the token is expired
  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return true; // Invalid JWT format
      }

      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final expiry = payload['exp'];

      if (expiry == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiry * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // If decoding fails, consider it expired
    }
  }
}
