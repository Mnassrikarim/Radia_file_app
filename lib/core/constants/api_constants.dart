// lib/core/constants/api_constants.dart

class ApiConstants {
  // Prevent instantiation
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://apps.rediafile.com/api/v2';

  // Endpoints
  static const String authorize = '/authorize';
  static const String accountInfo = '/account/info';
  static const String disableAccessToken = '/disable_access_token';
  static const String fileUpload = '/file/upload';
  static const String fileDownload = '/file/download';
  static const String folderListing = '/folder/listing';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
