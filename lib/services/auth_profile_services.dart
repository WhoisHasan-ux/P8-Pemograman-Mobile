import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthProfileService {
  static const String baseUrl = 'https://api-tb-f2wk.onrender.com/api';

  // Mengambil data profil dari API
  Future<UserModel> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/auth/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Profile Status: ${response.statusCode}');
      print('Get Profile Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return UserModel.fromJson(jsonData['data']);
      } else if (response.statusCode == 429) {
        throw Exception('Terlalu banyak request. Silakan coba lagi dalam beberapa menit.');
      } else {
        final jsonData = jsonDecode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal mengambil profil');
      }
    } catch (e) {
      print('Error getProfile: $e');
      if (e is Exception) rethrow;
      throw Exception('Gagal mengambil data profil: $e');
    }
  }

  // Mengupdate data profil ke API
  Future<UserModel> updateProfile(String token, String fullName, String phone) async {
    final url = Uri.parse('$baseUrl/auth/profile');

    final body = {
      'full_name': fullName,
      'phone': phone,
    };

    try {
      print('--- DEBUG UPDATE PROFILE ---');
      print('URL: $url');
      print('Method: PUT');
      print('Headers: {Content-Type: application/json, Authorization: Bearer <TOKEN_HIDDEN>}');
      print('Body: ${jsonEncode(body)}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('--------------------------');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          return UserModel.fromJson(jsonData['data']);
        } else {
          throw Exception('Data tidak dikembalikan oleh server');
        }
      } else if (response.statusCode == 429) {
        throw Exception('Terlalu banyak request. Silakan coba lagi dalam beberapa menit.');
      } else {
        final jsonData = jsonDecode(response.body);
        final message = jsonData['message'] ?? 'Gagal memperbarui profil (Status ${response.statusCode})';
        throw Exception(message);
      }
    } catch (e) {
      print('Error updateProfile: $e');
      // Jangan double-wrap jika sudah Exception
      if (e is Exception) rethrow;
      throw Exception('Gagal memperbarui data profil: $e');
    }
  }
}
