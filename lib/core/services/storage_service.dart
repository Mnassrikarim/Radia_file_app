// lib/core/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _accountIdKey = 'account_id';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Save auth data
  Future<void> saveAuthData({
    required String accessToken,
    required int accountId,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setInt(_accountIdKey, accountId);
    await _prefs.setBool(_isLoggedInKey, true);
  }

  // Get access token
  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  // Get account ID
  int? getAccountId() {
    return _prefs.getInt(_accountIdKey);
  }

  // Check if logged in
  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear all data (logout)
  Future<void> clearAuthData() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_accountIdKey);
    await _prefs.setBool(_isLoggedInKey, false);
  }

  // Clear all storage
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
