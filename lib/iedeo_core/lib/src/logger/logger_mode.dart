typedef LoggerCallback = void Function(
    String level, String message, Exception? error, StackTrace? stackTrace);

/// Enum representing the different logging modes.
enum LoggerMode {
  /// No logs will be recorded or sent.
  noLogs,

  /// Only exception logs will be recorded.
  exceptionOnly,

  /// Only trace logs (info and warnings) will be recorded.
  traceOnly,

  /// Both trace and exception logs will be recorded.
  traceAndException,
}
