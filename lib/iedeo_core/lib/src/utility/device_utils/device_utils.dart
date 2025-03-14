import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:login_page/iedeo_core/lib/src/utility/core_constants.dart';

import '../../../iedeo_core.dart';

/// Utility class to fetch and manage device details across multiple platforms:
/// - Android
/// - iOS
/// - Web
/// - Windows
/// - macOS
/// - Linux
///
/// Uses `device_info_plus` to retrieve platform-specific information.
class DeviceUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Sets the push token received from the app class.
  ///
  /// This method should be called once the push token is obtained using
  /// Firebase Messaging or any other push notification service.
  static void setPushToken(String token) {
    StorageService.savePushToken(token);
    LoggerManager().logInfo(
      UtilityConstants.moduleUtility,
      UtilityConstants.subModuleDeviceUtils,
      'setPushToken',
      'Push token set successfully',
    );
  }

  /// Returns a map containing device details such as:
  /// - deviceId
  /// - deviceModel
  /// - osVersion
  /// - pushToken
  ///
  /// This method retrieves platform-specific information using the
  /// `device_info_plus` package. If an error occurs, it logs the error
  /// and provides default values.
  static Future<Map<String, String>> getDeviceDetails() async {
    // Default fallback values
    String deviceId = 'unknown-device-id';
    String deviceModel = 'Unknown Device';
    String osVersion = 'Unknown OS';
    String pushToken = StorageService.getPushToken() is String
        ? StorageService.getPushToken().toString()
        : UtilityConstants.tagEmpty;

    try {
      if (kIsWeb) {
        // Web platform
        final webInfo = await _deviceInfo.webBrowserInfo;
        deviceId = webInfo.userAgent ?? 'web-device';
        deviceModel = webInfo.browserName.name; // e.g., Chrome, Safari, etc.
        osVersion = 'Web';
        LoggerManager().logInfo(
          UtilityConstants.moduleUtility,
          UtilityConstants.subModuleDeviceUtils,
          'getDeviceDetails',
          'Fetched Web device details',
        );
      } else {
        // Non-Web platforms
        if (Platform.isAndroid) {
          // Android
          final androidInfo = await _deviceInfo.androidInfo;
          deviceId = androidInfo.id;
          deviceModel = androidInfo.model;
          osVersion = androidInfo.version.release;
          LoggerManager().logInfo(
            UtilityConstants.moduleUtility,
            UtilityConstants.subModuleDeviceUtils,
            'getDeviceDetails',
            'Fetched Android device details',
          );
        } else if (Platform.isIOS) {
          // iOS
          final iosInfo = await _deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? 'unknown-ios-id';
          deviceModel = iosInfo.utsname.machine;
          osVersion = iosInfo.systemVersion;
          LoggerManager().logInfo(
            UtilityConstants.moduleUtility,
            UtilityConstants.subModuleDeviceUtils,
            'getDeviceDetails',
            'Fetched iOS device details',
          );
        } else if (Platform.isWindows) {
          // Windows
          final windowsInfo = await _deviceInfo.windowsInfo;
          deviceId = windowsInfo.deviceId;
          deviceModel = windowsInfo.computerName;
          osVersion = 'Windows (build: ${windowsInfo.displayVersion})';
          LoggerManager().logInfo(
            UtilityConstants.moduleUtility,
            UtilityConstants.subModuleDeviceUtils,
            'getDeviceDetails',
            'Fetched Windows device details',
          );
        } else if (Platform.isMacOS) {
          // macOS
          final macInfo = await _deviceInfo.macOsInfo;
          deviceId = macInfo.systemGUID ?? 'unknown-macos-id';
          deviceModel = 'Mac: ${macInfo.model}';
          osVersion = 'macOS (version: ${macInfo.osRelease})';
          LoggerManager().logInfo(
            UtilityConstants.moduleUtility,
            UtilityConstants.subModuleDeviceUtils,
            'getDeviceDetails',
            'Fetched macOS device details',
          );
        } else if (Platform.isLinux) {
          // Linux
          final linuxInfo = await _deviceInfo.linuxInfo;
          deviceId = linuxInfo.machineId ?? 'unknown-linux-id';
          deviceModel = linuxInfo.prettyName;
          osVersion = 'Linux (id: ${linuxInfo.id})';
          LoggerManager().logInfo(
            UtilityConstants.moduleUtility,
            UtilityConstants.subModuleDeviceUtils,
            'getDeviceDetails',
            'Fetched Linux device details',
          );
        } else {
          // Fallback for other platforms (e.g., Fuchsia)
          deviceId = 'unknown-other-device-id';
          deviceModel = 'Unknown Device';
          osVersion = 'Unknown OS';
          LoggerManager().logInfo(
            UtilityConstants.moduleUtility,
            UtilityConstants.subModuleDeviceUtils,
            'getDeviceDetails',
            'Fallback for unsupported platform',
          );
        }
      }
    } catch (e) {
      // Log any errors that occur during device info retrieval
      LoggerManager().logError(
        UtilityConstants.moduleUtility,
        UtilityConstants.subModuleDeviceUtils,
        'getDeviceDetails',
        'Error getting device details: $e',
        e is Exception ? e : Exception(e.toString()),
      );
    }

    return {
      'deviceId': deviceId,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'pushToken': pushToken,
    };
  }
}
