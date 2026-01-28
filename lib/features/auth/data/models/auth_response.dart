// lib/features/auth/data/models/auth_response.dart

class AuthResponse {
  final String accessToken;
  final int accountId;
  final String status;
  final String datetime;

  AuthResponse({
    required this.accessToken,
    required this.accountId,
    required this.status,
    required this.datetime,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['data']['access_token'] as String,
      accountId: int.parse(json['data']['account_id'].toString()),
      status: json['_status'] as String,
      datetime: json['_datetime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'access_token': accessToken, 'account_id': accountId},
      '_status': status,
      '_datetime': datetime,
    };
  }
}

// lib/features/auth/data/models/account_info.dart

class AccountInfo {
  final int id;
  final String username;
  final int levelId;
  final String email;
  final String? lastLoginDate;
  final String? lastLoginIp;
  final String status;
  final String? title;
  final String? firstname;
  final String? lastname;
  final String? languageId;
  final String? dateCreated;
  final String? lastPayment;
  final String? paidExpiryDate;
  final String? storageLimitOverride;

  AccountInfo({
    required this.id,
    required this.username,
    required this.levelId,
    required this.email,
    this.lastLoginDate,
    this.lastLoginIp,
    required this.status,
    this.title,
    this.firstname,
    this.lastname,
    this.languageId,
    this.dateCreated,
    this.lastPayment,
    this.paidExpiryDate,
    this.storageLimitOverride,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AccountInfo(
      id: int.parse(data['id'].toString()),
      username: data['username'] as String,
      levelId: int.parse(data['level_id'].toString()),
      email: data['email'] as String,
      lastLoginDate: data['lastlogindate'] as String?,
      lastLoginIp: data['lastloginip'] as String?,
      status: data['status'] as String,
      title: data['title'] as String?,
      firstname: data['firstname'] as String?,
      lastname: data['lastname'] as String?,
      languageId: data['languageId']?.toString(),
      dateCreated: data['datecreated'] as String?,
      lastPayment: data['lastPayment'] as String?,
      paidExpiryDate: data['paidExpiryDate'] as String?,
      storageLimitOverride: data['storageLimitOverride']?.toString(),
    );
  }

  String get fullName {
    if (firstname != null && lastname != null) {
      return '$firstname $lastname';
    }
    return username;
  }
}

// lib/core/models/api_error.dart

class ApiError {
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
