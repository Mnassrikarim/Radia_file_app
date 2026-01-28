// lib/features/auth/data/services/auth_service.dart

import 'package:app_v1/core/constants/api_constants.dart';
import 'package:app_v1/core/services/api_client.dart';
import 'package:app_v1/features/auth/data/models/auth_response.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<AuthResponse> authorize({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authorize,
      body: {'username': username, 'password': password},
    );

    return AuthResponse.fromJson(response);
  }

  Future<AccountInfo> getAccountInfo({
    required String accessToken,
    required int accountId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.accountInfo,
      body: {'access_token': accessToken, 'account_id': accountId.toString()},
    );

    return AccountInfo.fromJson(response);
  }

  Future<void> disableAccessToken({
    required String accessToken,
    required int accountId,
  }) async {
    await _apiClient.post(
      ApiConstants.disableAccessToken,
      body: {'access_token': accessToken, 'account_id': accountId.toString()},
    );
  }

  void dispose() {
    _apiClient.dispose();
  }
}
