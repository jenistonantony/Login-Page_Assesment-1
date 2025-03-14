/// Represents the different environments your app can run in.
enum EnvironmentType {
  development,
  staging,
  production,
}

/// A simple class that holds configuration values for a specific environment.
///
/// You can expand this to include various environment variables:
/// - baseUrl (API endpoint)
/// - debug flags
/// - feature toggles
/// - third-party service keys, etc.
class Environment {
  final String name;
  final String baseUrl;
  final bool enableLogging;
  final bool enableSSL;
  final String? sslFingerprint; // If applicable

  Environment({
    required this.name,
    required this.baseUrl,
    this.enableLogging = false,
    this.enableSSL = false,
    this.sslFingerprint,
  });
}

/// A static map of all possible environments your app supports.
/// Each environment is associated with a unique [Environment] object.
/// Add or modify fields as per your project’s requirements.
class AppEnvironments {
  static final Map<EnvironmentType, Environment> environments = {
    EnvironmentType.development: Environment(
      name: 'Development',
      baseUrl: 'https://api-dev.example.com',
      enableLogging: true,
      enableSSL: false,
      sslFingerprint: null,
    ),
    EnvironmentType.staging: Environment(
      name: 'Staging',
      baseUrl: 'https://api-staging.example.com',
      enableLogging: true,
      enableSSL: true,
      sslFingerprint: 'SHA256_STAGING_CERT_FINGERPRINT',
    ),
    EnvironmentType.production: Environment(
      name: 'Production',
      baseUrl: 'https://api.example.com',
      enableLogging: false,
      enableSSL: true,
      sslFingerprint: 'SHA256_PRODUCTION_CERT_FINGERPRINT',
    ),
  };
}
