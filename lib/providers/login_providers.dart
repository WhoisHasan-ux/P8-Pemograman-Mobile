import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_login_services.dart';

// Membuat provider untuk mengatur proses login, token, loading, dan logout
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? user;
  String? token;
  bool isLoading = false;
  String? errorMessage;

  bool get isLogin => token != null && token!.isNotEmpty;

  // Mengecek token yang tersimpan untuk fitur auto-login
  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
    
    // Ambil nama user yang disimpan
    final userName = prefs.getString('user_name');
    if (userName != null && userName.isNotEmpty) {
      user = UserModel(
        id: '',
        email: '',
        fullName: userName,
        phone: '',
        avatarUrl: '',
        role: '',
      );
    }

    notifyListeners();
  }

  // Membuat function register dan menyimpan token ke local storage
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      if (result.accessToken.isEmpty) {
        isLoading = false;
        notifyListeners();
        return true;
      }

      token = result.accessToken;
      user = result.user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token!);
      if (result.refreshToken.isNotEmpty) {
        await prefs.setString('refresh_token', result.refreshToken);
      }
      if (user != null) {
        await prefs.setString('user_name', user!.fullName);
      }

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Membuat function login dan menyimpan token ke local storage
  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email: email, password: password);

      token = result.accessToken;
      user = result.user;

      if (token == null || token!.isEmpty) {
        throw Exception('Access token tidak ditemukan');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token!);
      if (result.refreshToken.isNotEmpty) {
        await prefs.setString('refresh_token', result.refreshToken);
      }
      if (user != null) {
        await prefs.setString('user_name', user!.fullName);
      }

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Membuat function logout dan menghapus token dari local storage
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_name');

    token = null;
    user = null;

    notifyListeners();
  }
}
