import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../logger/logger_manager.dart'; // <-- Adjust import path as needed

/// A service class for encrypting and decrypting data using AES,
/// with optional key generation and secure key storage.
///
/// **Usage Example:**
/// ```dart
/// // 1) Generate and store key (only once, or when you need a new key).
/// await EncryptionService.generateAndStoreKey('my_aes_key', keySize: 32);
///
/// // 2) Retrieve the key
/// final key = await EncryptionService.retrieveKey('my_aes_key');
///
/// // 3) Encrypt and decrypt
/// final encrypted = EncryptionService.encryptAES('Hello World', key!);
/// final decrypted = EncryptionService.decryptAES(encrypted, key);
/// print(decrypted); // "Hello World"
/// ```
class EncryptionService {
  static const _module = 'EncryptionService';
  static const _subModule = 'AES';

  /// The [FlutterSecureStorage] instance for storing and retrieving keys securely.
  static const _secureStorage = FlutterSecureStorage();

  // --------------------------------------------------------------------------
  // Key Generation and Secure Storage
  // --------------------------------------------------------------------------

  /// Generates a **random AES key** of length [keySize] (default 32 bytes = 256 bits)
  /// and stores it securely using [FlutterSecureStorage] under [storageKey].
  ///
  /// [keySize] can be 16 (128 bits), 24 (192 bits), or 32 (256 bits).
  ///
  /// If a key already exists under [storageKey], it will be **overwritten**.
  static Future<void> generateAndStoreKey(String storageKey, {int keySize = 32}) async {
    try {
      final randomKey = _generateRandomBytes(keySize);
      // Store base64-encoded key in secure storage
      final base64Key = base64UrlEncode(randomKey);
      await _secureStorage.write(key: storageKey, value: base64Key);

      LoggerManager().logInfo(
        _module,
        _subModule,
        'generateAndStoreKey',
        'Key generated and stored under $storageKey',
      );
    } catch (e, stack) {
      LoggerManager().logError(
        _module,
        _subModule,
        'generateAndStoreKey',
        'Error generating/storing key: $e',
        e is Exception ? e : Exception(e.toString()),
        stack,
      );
    }
  }

  /// Retrieves the AES key stored under [storageKey], returning it as a **Base64 string**.
  ///
  /// Returns `null` if no key is found.
  ///
  /// **Note**: If you plan to store the key as a Base64 string, you can decode
  /// back to bytes or keep it in string form. For the default approach below,
  /// we store it as base64 but rely on `Key.fromBase64` for encryption/decryption.
  static Future<String?> retrieveKey(String storageKey) async {
    try {
      final base64Key = await _secureStorage.read(key: storageKey);
      if (base64Key == null) {
        LoggerManager().logInfo(
          _module,
          _subModule,
          'retrieveKey',
          'No key found under $storageKey',
        );
        return null;
      }

      LoggerManager().logInfo(
        _module,
        _subModule,
        'retrieveKey',
        'Key retrieved for $storageKey',
      );
      return base64Key;
    } catch (e, stack) {
      LoggerManager().logError(
        _module,
        _subModule,
        'retrieveKey',
        'Error retrieving key: $e',
        e is Exception ? e : Exception(e.toString()),
        stack,
      );
      return null;
    }
  }

  /// Deletes the AES key stored under [storageKey].
  static Future<void> deleteKey(String storageKey) async {
    try {
      await _secureStorage.delete(key: storageKey);
      LoggerManager().logInfo(
        _module,
        _subModule,
        'deleteKey',
        'Key deleted for $storageKey',
      );
    } catch (e, stack) {
      LoggerManager().logError(
        _module,
        _subModule,
        'deleteKey',
        'Error deleting key: $e',
        e is Exception ? e : Exception(e.toString()),
        stack,
      );
    }
  }

  // --------------------------------------------------------------------------
  // AES Encryption / Decryption
  // --------------------------------------------------------------------------

  /// Encrypts a given [plainText] using AES with the provided [key].
  ///
  /// The [key] can be a base64-encoded string (from [retrieveKey]) if you plan
  /// to use `encrypt.Key.fromBase64(key)`.
  ///
  /// Or, if you use `Key.fromUtf8(key)`, then [key] must be exactly 16, 24, or 32 chars.
  static String encryptAES(String plainText, String key) {
    try {
      if (plainText.isEmpty || key.isEmpty) {
        throw ArgumentError('Plain text and key must not be empty.');
      }

      // If the key is base64
      final encrypterKey = encrypt.Key.fromBase64(key);

      final iv = encrypt.IV.fromSecureRandom(16); // Generate a random IV
      final encrypter = encrypt.Encrypter(encrypt.AES(
        encrypterKey,
        mode: encrypt.AESMode.cbc,
      ));

      final encrypted = encrypter.encrypt(plainText, iv: iv);

      // Return IV + ciphertext, base64-encoded
      final combined = iv.bytes + encrypted.bytes;
      final result = base64UrlEncode(combined);

      LoggerManager().logInfo(
        _module,
        _subModule,
        'encryptAES',
        'Encryption successful. PlainText length: ${plainText.length}, Encrypted length: ${result.length}',
      );

      return result;
    } catch (e, stack) {
      LoggerManager().logError(
        _module,
        _subModule,
        'encryptAES',
        'Error during AES encryption: $e',
        e is Exception ? e : Exception(e.toString()),
        stack,
      );
      return plainText;
    }
  }

  /// Decrypts a given [cipherText] using AES with the provided [key].
  ///
  /// Expects the first 16 bytes of [cipherText] to be the IV, followed by the ciphertext.
  ///
  /// [key] can be the same base64 string used in [encryptAES] above if using `Key.fromBase64`.
  static String decryptAES(String cipherText, String key) {
    try {
      // Validate input
      if (cipherText.isEmpty || key.isEmpty) {
        throw ArgumentError('Cipher text and key must not be empty.');
      }

      final encrypterKey = encrypt.Key.fromBase64(key);
      final fullBytes = base64Url.decode(cipherText);

      if (fullBytes.length < 16) {
        throw FormatException('Invalid encrypted data: Too short to contain IV.');
      }

      final ivBytes = fullBytes.sublist(0, 16);
      final cipherBytes = fullBytes.sublist(16);
      final iv = encrypt.IV(ivBytes);

      final encrypter = encrypt.Encrypter(encrypt.AES(
        encrypterKey,
        mode: encrypt.AESMode.cbc,
      ));

      final decrypted = encrypter.decrypt(
        encrypt.Encrypted(cipherBytes),
        iv: iv,
      );

      LoggerManager().logInfo(
        _module,
        _subModule,
        'decryptAES',
        'Decryption successful. CipherText length: ${cipherText.length}',
      );

      return decrypted;
    } catch (e, stack) {
      LoggerManager().logError(
        _module,
        _subModule,
        'decryptAES',
        'Error during AES decryption: $e',
        e is Exception ? e : Exception(e.toString()),
        stack,
      );
      // Return the original cipherText or a special marker
      return cipherText;
    }
  }

  // --------------------------------------------------------------------------
  // Private Helpers
  // --------------------------------------------------------------------------

  /// Generates a list of random bytes of length [length] using [Random.secure()].
  static List<int> _generateRandomBytes(int length) {
    final rand = Random.secure();
    return List<int>.generate(length, (_) => rand.nextInt(256));
  }

  /// The input must be exactly **16, 24, or 32** characters to match AES key sizes.
  static String encodeKeyToBase64(String rawKey) {
    if (!(rawKey.length == 16 || rawKey.length == 24 || rawKey.length == 32)) {
      throw ArgumentError('AES key must be exactly 16, 24, or 32 characters.');
    }
    return base64UrlEncode(utf8.encode(rawKey)); // Converts key to Base64
  }
}
