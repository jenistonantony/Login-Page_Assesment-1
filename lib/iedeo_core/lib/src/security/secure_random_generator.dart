import 'dart:math';
import 'dart:convert';

/// A utility class for generating cryptographically secure random values.
class SecureRandomGenerator {
  // Use a secure random generator if available (e.g., `dart:math` is not fully secure on all platforms).
  // For stronger security on web, consider using `package:crypto` or platform channels.

  /// Generates a random alphanumeric string of length [length].
  static String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    final sb = StringBuffer();

    for (int i = 0; i < length; i++) {
      sb.write(chars[rand.nextInt(chars.length)]);
    }
    return sb.toString();
  }

  /// Generates a random byte array of [length].
  static List<int> generateRandomBytes(int length) {
    final rand = Random.secure();
    return List<int>.generate(length, (_) => rand.nextInt(256));
  }

  /// Generates a base64 string of random bytes (useful for tokens).
  static String generateRandomBase64(int byteLength) {
    final bytes = generateRandomBytes(byteLength);
    return base64UrlEncode(bytes);
  }
}
