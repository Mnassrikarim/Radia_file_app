// lib/core/models/api_error.dart

class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final String? datetime;

  ApiError({required this.message, this.statusCode, this.datetime});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['response'] as String? ?? 'Unknown error occurred',
      statusCode: json['status_code'] as int?,
      datetime: json['_datetime'] as String?,
    );
  }

  @override
  String toString() => message;
}
