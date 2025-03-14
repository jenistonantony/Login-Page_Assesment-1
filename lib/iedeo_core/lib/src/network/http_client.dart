import 'dart:io' as io show HttpClient, SecurityContext;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio/browser.dart' as browser;

import '../../iedeo_core.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_constants.dart';

/// A class responsible for creating and configuring the Dio instance.
class HttpDioClient {
  static Dio createDio({
    required String baseUrl,
    required int connectTimeoutMs,
    required int receiveTimeoutMs,
    bool enableSSL = false,
    bool enableLogging = false,
    String? sslFingerprint,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeoutMs),
        receiveTimeout: Duration(milliseconds: receiveTimeoutMs),
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      AuthInterceptor(),
      if (enableLogging) LoggingInterceptor(),
    ]);

    // SSL pinning if enabled and fingerprint is provided
    if (enableSSL && sslFingerprint != null && sslFingerprint.isNotEmpty) {
      _setUpSSLPinning(dio, sslFingerprint);
    }

    return dio;
  }

  /// Sets up SSL pinning by comparing the SHA-256 fingerprint.
  static void _setUpSSLPinning(Dio dio, String fingerprint) {
    // If running on the web, browsers don't allow raw access to certificates
    // for custom pinning. Attempting to do so will either fail silently or is
    // simply not supported by the environment.
    if (kIsWeb) {
      dio.httpClientAdapter = browser.BrowserHttpClientAdapter();
      LoggerManager().logInfo(
        NetworkConstants.moduleNetwork,
        NetworkConstants.subModuleSSLValidation,
        '_setUpSSLPinning',
        'SSL pinning is not supported on the Web; using BrowserHttpClientAdapter.',
      );
      return;
    }

    // For mobile/desktop (non-Web):
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // If you want to rely only on pinned certs, set `withTrustedRoots: false`
        final client =
        io.HttpClient(context: io.SecurityContext(withTrustedRoots: false));

        // Typically, you'd want more robust logic than simply accepting any
        // certificate in the badCertificateCallback, but you can tweak this
        // based on your needs.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
      validateCertificate: (cert, host, port) {
        if (cert == null) {
          LoggerManager().logError(
            NetworkConstants.moduleNetwork,
            NetworkConstants.subModuleSSLValidation,
            'validateCertificate',
            'Certificate is null',
          );
          return false;
        }

        // Compare the remote certificate's SHA-256 fingerprint with our known fingerprint
        final certFingerprint = sha256.convert(cert.der).toString();
        final isValid = certFingerprint == fingerprint;

        if (isValid) {
          LoggerManager().logInfo(
            NetworkConstants.moduleNetwork,
            NetworkConstants.subModuleSSLValidation,
            'validateCertificate',
            'Certificate is valid (fingerprint matched).',
          );
        } else {
          LoggerManager().logError(
            NetworkConstants.moduleNetwork,
            NetworkConstants.subModuleSSLValidation,
            'validateCertificate',
            'Fingerprint mismatch: $certFingerprint (expected $fingerprint)',
          );
        }
        return isValid;
      },
    );

    LoggerManager().logInfo(
      NetworkConstants.moduleNetwork,
      NetworkConstants.subModuleSSLValidation,
      '_setUpSSLPinning',
      'SSL pinning is set up on native platforms.',
    );
  }
}
