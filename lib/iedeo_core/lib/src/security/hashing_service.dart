import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

/// A service class for hashing data using various algorithms (SHA-256, HMAC, etc.).
///
/// Example usage:
/// ```dart
/// final sha256Hash = HashingService.sha256('Hello World');
/// final hmacSha256 = HashingService.hmacSha256('Hello World', 'SecretKey');
/// ```
class HashingService {
  /// Returns the SHA-256 hash of the given [input] string.
  static String sha256(String input) {
    final bytes = utf8.encode(input);
    final digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }

  /// Returns the HMAC-SHA256 of [input] using the provided [key].
  static String hmacSha256(String input, String key) {
    final hmac = crypto.Hmac(crypto.sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(input));
    return digest.toString();
  }
}
