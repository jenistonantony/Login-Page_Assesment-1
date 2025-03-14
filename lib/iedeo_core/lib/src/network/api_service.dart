import 'package:dio/dio.dart';
import '../../iedeo_core.dart';
import 'http_client.dart';
import 'network_constants.dart';

/// A service class to handle all API requests (GET, POST, PUT, DELETE).
class ApiService {
  late Dio _dio;

  void setDioInstance(Dio dio) {
    _dio = dio;
  }

  void setupApiService() {
    final config = ConfigManager().currentEnvironment;

    init(
      baseUrl: config.baseUrl,
      connectTimeoutMs: 30000,
      receiveTimeoutMs: 30000,
      enableSSL: config.enableSSL,
      sslFingerprint: config.sslFingerprint,
      enableLogging: config.enableLogging,
    );
  }
  /// Initializes the [ApiService] by creating a [Dio] instance with the provided configuration.
  void init({
    required String baseUrl,
    required int connectTimeoutMs,
    required int receiveTimeoutMs,
    bool enableSSL = false,
    bool enableLogging = false,
    String? sslFingerprint,
  }) {
    _dio = HttpDioClient.createDio(
      baseUrl: baseUrl,
      connectTimeoutMs: connectTimeoutMs,
      receiveTimeoutMs: receiveTimeoutMs,
      enableSSL: enableSSL,
      sslFingerprint: sslFingerprint,
      enableLogging: enableLogging,
    );

    LoggerManager().logInfo(
      NetworkConstants.moduleNetwork,
      'ApiService',
      'init',
      'API Service initialized',
    );
  }

  /// Sends a GET request and handles the response.
  Future<ApiResponse<dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) async {
    if (!await NetworkInfo.isConnected()) {
      return ApiResponse(errorMessage: 'No internet connection');
    }
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      LoggerManager().logInfo(
        NetworkConstants.moduleNetwork,
        'ApiService',
        'get',
        'GET request to $endpoint successful',
      );
      return _handleResponse(response);
    } catch (e) {
      return NetworkExceptionHandler.handleException(e);
    }
  }

  /// Sends a POST request and handles the response.
  Future<ApiResponse<dynamic>> post(
      String endpoint, {
        dynamic data,
      }) async {
    if (!await NetworkInfo.isConnected()) {
      return ApiResponse(errorMessage: 'No internet connection');
    }
    try {
      final response = await _dio.post(endpoint, data: data);
      LoggerManager().logInfo(
        NetworkConstants.moduleNetwork,
        'ApiService',
        'post',
        'POST request to $endpoint successful',
      );
      return _handleResponse(response);
    } catch (e) {
      return NetworkExceptionHandler.handleException(e);
    }
  }

  /// Sends a PUT request and handles the response.
  Future<ApiResponse<dynamic>> put(
      String endpoint, {
        dynamic data,
      }) async {
    if (!await NetworkInfo.isConnected()) {
      return ApiResponse(errorMessage: 'No internet connection');
    }
    try {
      final response = await _dio.put(endpoint, data: data);
      LoggerManager().logInfo(
        NetworkConstants.moduleNetwork,
        'ApiService',
        'put',
        'PUT request to $endpoint successful',
      );
      return _handleResponse(response);
    } catch (e) {
      return NetworkExceptionHandler.handleException(e);
    }
  }

  /// Sends a DELETE request and handles the response.
  Future<ApiResponse<dynamic>> delete(
      String endpoint,
      ) async {
    if (!await NetworkInfo.isConnected()) {
      return ApiResponse(errorMessage: 'No internet connection');
    }
    try {
      final response = await _dio.delete(endpoint);
      LoggerManager().logInfo(
        NetworkConstants.moduleNetwork,
        'ApiService',
        'delete',
        'DELETE request to $endpoint successful',
      );
      return _handleResponse(response);
    } catch (e) {
      return NetworkExceptionHandler.handleException(e);
    }
  }

  /// Handles the Dio response and wraps it in an [ApiResponse].
  ApiResponse<dynamic> _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return ApiResponse(data: response.data, statusCode: response.statusCode);
    } else {
      return ApiResponse(
        errorMessage: 'Unexpected error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}
