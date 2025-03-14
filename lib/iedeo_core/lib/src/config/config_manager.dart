import 'environment.dart';

/// A singleton ConfigManager to manage and retrieve the current environment config.
class ConfigManager {
  static final ConfigManager _instance = ConfigManager._internal();
  factory ConfigManager() => _instance;

  ConfigManager._internal();

  late EnvironmentType _currentEnvType;
  late Environment _currentEnvironment;

  /// Initializes the ConfigManager by setting the current environment.
  ///
  /// [envType] determines which environment config is loaded.
  void init(EnvironmentType envType) {
    _currentEnvType = envType;

    // Load environment details from the static AppEnvironments map
    final environment = AppEnvironments.environments[envType];
    if (environment == null) {
      throw Exception('Environment config not found for $envType');
    }
    _currentEnvironment = environment;
  }

  /// Retrieves the currently active Environment.
  Environment get currentEnvironment => _currentEnvironment;

  /// Retrieves the current environment type (development, staging, production).
  EnvironmentType get currentEnvironmentType => _currentEnvType;
}
