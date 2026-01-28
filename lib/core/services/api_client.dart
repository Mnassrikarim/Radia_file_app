// lib/core/services/api_client.dart

import 'dart:convert';
import 'package:app_v1/core/constants/api_constants.dart';
import 'package:app_v1/features/auth/data/models/auth_response.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await _client
          .post(
            url,
            headers:
                headers ??
                {'Content-Type': 'application/x-www-form-urlencoded'},
            body: body,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiError(message: 'Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ).replace(queryParameters: queryParameters);

      final response = await _client
          .get(url, headers: headers)
          .timeout(ApiConstants.receiveTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiError(message: 'Network error: ${e.toString()}');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      final status = jsonResponse['_status'] as String?;

      if (status == 'error') {
        throw ApiError.fromJson(jsonResponse);
      }

      return jsonResponse;
    } else {
      throw ApiError(
        message: jsonResponse['response'] as String? ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
