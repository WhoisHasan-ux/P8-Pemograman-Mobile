import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CheckoutService {
  static const String baseUrl = 'https://api-tb-f2wk.onrender.com/api';

  // Mengirim data checkout ke server
  // Mengembalikan true jika berhasil, atau throw exception jika gagal
  Future<bool> checkout({
    required List<CartModel> items,
    required int totalPrice,
    required String shippingAddress,
    required String notes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Belum login');

      final url = Uri.parse('$baseUrl/orders');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'shipping_address': shippingAddress,
          'notes': notes,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final jsonData = jsonDecode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal melakukan checkout');
      }
    } catch (e) {
      throw Exception('Gagal melakukan checkout: $e');
    }
  }
}
