import 'package:connectivity_plus/connectivity_plus.dart';
import '../logger/logger_manager.dart';
import 'network_constants.dart';

/// A utility class to check network connectivity status.
class NetworkInfo {
  /// Checks the current connectivity status using [connectivity_plus].
  ///
  /// Returns [true] if connected, otherwise [false].
  static Future<bool> isConnected() async {
    final connectivityResult =
        (await Connectivity().checkConnectivity());
    final hasConnection = connectivityResult != ConnectivityResult.none;

    if (!hasConnection) {
      LoggerManager().logWarning(
        NetworkConstants.moduleNetwork,
        NetworkConstants.subModuleConnectivity,
        'isConnected',
        'No internet connection',
      );
    }
    return hasConnection;
  }
}
