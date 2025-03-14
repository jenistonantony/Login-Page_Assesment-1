import 'logger_mode.dart';

/// A singleton class for managing application logs and errors.
///
/// The `LoggerManager` allows configurable logging modes and supports
/// callback functions to send logs back to the app for custom handling.
///
/// It supports logging at various levels: info, warning, error, and non-fatal errors.
class LoggerManager {
  // Singleton instance
  static final LoggerManager _instance = LoggerManager._internal();

  /// Factory constructor to return the singleton instance.
  factory LoggerManager() => _instance;

  /// Private internal constructor.
  LoggerManager._internal();

  /// Current logging mode. Default is [LoggerMode.noLogs].
  LoggerMode _mode = LoggerMode.noLogs;

  /// Optional callback to notify the app about logs.
  LoggerCallback? _loggerCallback;

  /// Sets the logging mode.
  void setMode(LoggerMode mode) {
    _mode = mode;
  }

  /// Sets an optional callback to notify the app about logs.
  void setLoggerCallback(LoggerCallback callback) {
    _loggerCallback = callback;
  }

  /// Logs an informational message.
  void logInfo(String module, String subModule, String method, String message) {
    if (_mode == LoggerMode.traceOnly ||
        _mode == LoggerMode.traceAndException) {
      final formattedMessage = _formatMessage(module, subModule, method, message);
      _invokeCallback('INFO', formattedMessage);
    }
  }

  /// Logs a warning message.
  void logWarning(String module, String subModule, String method, String message) {
    if (_mode == LoggerMode.traceOnly ||
        _mode == LoggerMode.traceAndException) {
      final formattedMessage = _formatMessage(module, subModule, method, message);
      _invokeCallback('WARNING', formattedMessage);
    }
  }

  /// Logs an error message with optional exception and stack trace.
  void logError(String module, String subModule, String method, String message,
      [Exception? exception, StackTrace? stackTrace]) {
    if (_mode == LoggerMode.exceptionOnly ||
        _mode == LoggerMode.traceAndException) {
      final formattedMessage = _formatMessage(module, subModule, method, message);
      _invokeCallback('ERROR', formattedMessage, exception, stackTrace);
    }
  }

  /// Captures non-fatal errors and invokes the callback.
  void captureNonFatalError(
      String module, String subModule, String method, String message,
      [Exception? exception, StackTrace? stackTrace]) {
    if (_mode == LoggerMode.exceptionOnly ||
        _mode == LoggerMode.traceAndException) {
      final formattedMessage = _formatMessage(module, subModule, method, message);
      _invokeCallback('NON_FATAL', formattedMessage, exception, stackTrace);
    }
  }

  /// Internal method to invoke the callback, if set.
  void _invokeCallback(String level, String message,
      [Exception? exception, StackTrace? stackTrace]) {
    _loggerCallback?.call(level, message, exception, stackTrace);
  }

  /// Formats the log message with module, sub-module, and method.
  String _formatMessage(
      String module, String subModule, String method, String message) {
    return '[$module]:[$subModule]:[$method]: $message';
  }
}
