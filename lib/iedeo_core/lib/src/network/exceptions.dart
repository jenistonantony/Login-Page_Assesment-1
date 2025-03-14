import 'package:dio/dio.dart';
import '../logger/logger_manager.dart';
import 'network_constants.dart';
import 'api_response.dart';

/// A utility class for handling network exceptions.
class NetworkExceptionHandler {
  /// Handles exceptions and returns an [ApiResponse] with an error message and status code.
  static ApiResponse<dynamic> handleException(dynamic exception) {
    String errorMessage = 'Unknown error occurred';
    int? statusCode;

    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timed out while trying to connect to the server.';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'Connection timed out while sending data to the server.';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Connection timed out while waiting for a response from the server.';
          break;
        case DioExceptionType.badResponse:
          statusCode = exception.response?.statusCode;
          errorMessage = _handleBadResponse(exception.response);
          break;
        case DioExceptionType.badCertificate:
          errorMessage = 'The server’s SSL certificate could not be verified.';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'The request was cancelled by the user.';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Failed to establish a connection to the server.';
          break;
        case DioExceptionType.unknown:
          errorMessage = 'An unknown error occurred: ${exception.error.toString()}';
          break;
      }
    } else {
      errorMessage = exception.toString();
    }

    LoggerManager().logError(
      NetworkConstants.moduleNetwork,
      NetworkConstants.subModuleErrorHandling,
      'handleException',
      errorMessage,
      exception is Exception ? exception : Exception(errorMessage),
      StackTrace.current,
    );

    return ApiResponse(errorMessage: errorMessage, statusCode: statusCode);
  }

  /// Handles detailed error messages for bad responses.
  static String _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return 'Received an empty response from the server.';
    }

    final statusCode = response.statusCode ?? 0;
    String message = 'Unexpected error occurred.';

    switch (statusCode) {
      case 400:
        message = 'Bad request. Please check your input.';
        break;
      case 401:
        message = 'Unauthorized. Please check your credentials.';
        break;
      case 403:
        message = 'Forbidden. You do not have permission to access this resource.';
        break;
      case 404:
        message = 'Resource not found. The requested endpoint does not exist.';
        break;
      case 500:
        message = 'Internal server error. Please try again later.';
        break;
      case 502:
        message = 'Bad gateway. There is an issue with the server.';
        break;
      case 503:
        message = 'Service unavailable. The server is temporarily down.';
        break;
      case 504:
        message = 'Gateway timeout. The server is not responding.';
        break;
      default:
        message = 'Received HTTP status code $statusCode: ${response.statusMessage}';
        break;
    }
    return message;
  }
}
