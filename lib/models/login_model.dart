import 'user_model.dart';

// Membuat class untuk response login dari API
class LoginResponseModel {
  final bool success;
  final String message;
  final LoginDataModel data;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  // Mengubah response JSON login menjadi object LoginResponseModel
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: LoginDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

// Membuat class untuk data login seperti token dan user
class LoginDataModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginDataModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  // Mengubah data JSON login menjadi object LoginDataModel
  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      accessToken: json['access_token'] ?? json['accessToken'] ?? '',
      refreshToken: json['refresh_token'] ?? json['refreshToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
