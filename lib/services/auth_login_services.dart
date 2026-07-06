import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';

// Membuat service untuk menghubungkan aplikasi dengan API autentikasi
class AuthService {
  static const String baseUrl = 'https://api-tb-f2wk.onrender.com/api';

  // Membuat function untuk register user ke API
  Future<LoginDataModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final body = {
      'full_name': fullName,        // full_name, bukan fullName
      'email': email,
      'phone': phone.isEmpty ? '' : phone,
      'password': password,
    };

    print('Register - Sending data: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('Register - Status: ${response.statusCode}');
    print('Register - Response: ${response.body}');

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginResponse = LoginResponseModel.fromJson(jsonData);
      return loginResponse.data;
    } else {
      throw Exception(jsonData['message'] ?? 'Registrasi gagal');
    }
  }

  // Membuat function untuk login user ke API
  Future<LoginDataModel> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginResponse = LoginResponseModel.fromJson(jsonData);
      return loginResponse.data;
    } else {
      throw Exception(jsonData['message'] ?? 'Login gagal');
    }
  }
}
