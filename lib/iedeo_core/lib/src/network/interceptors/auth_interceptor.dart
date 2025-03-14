import 'package:dio/dio.dart';
import '../../../iedeo_core.dart';
import '../network_constants.dart';

/// A Dio interceptor to add authorization headers to each request.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? token = StorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = token;
      LoggerManager().logInfo(
        NetworkConstants.moduleNetwork,
        'AuthInterceptor',
        'onRequest',
        'Authorization header added.',
      );
    }
    super.onRequest(options, handler);
  }
}
