/// A generic wrapper for API responses.
///
/// [T] is the data type of the successful response.
class ApiResponse<T> {
  /// The successful response data (if any).
  final T? data;

  /// The HTTP status code of the response.
  final int? statusCode;

  /// An error message (if any).
  final String? errorMessage;

  ApiResponse({this.data, this.statusCode, this.errorMessage});
}
