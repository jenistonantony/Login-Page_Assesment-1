import 'package:dio/dio.dart';
import '../../../iedeo_core.dart';
import '../network_constants.dart';

/// A Dio interceptor that logs requests and responses using [LoggerManager].
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggerManager().logInfo(
      NetworkConstants.moduleNetwork,
      'LoggingInterceptor',
      'onRequest',
      'REQUEST[${options.method}] => PATH: ${options.path} | '
          'HEADERS: ${options.headers} | DATA: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggerManager().logInfo(
      NetworkConstants.moduleNetwork,
      'LoggingInterceptor',
      'onResponse',
      'RESPONSE[${response.statusCode}] => DATA: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerManager().logError(
      NetworkConstants.moduleNetwork,
      'LoggingInterceptor',
      'onError',
      'ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}',
      err,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}
