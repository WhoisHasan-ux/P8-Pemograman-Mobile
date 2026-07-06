import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CartService {
  static const String baseUrl = 'https://api-tb-f2wk.onrender.com/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Mendapatkan data keranjang dari server
  Future<List<CartModel>> getCart() async {
    final token = await _getToken();
    if (token == null) throw Exception('Belum login');

    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (jsonData['data'] != null && jsonData['data']['items'] != null) {
        final List items = jsonData['data']['items'];
        return items.map((item) => CartModel.fromJson(item)).toList();
      }
      return [];
    } else {
      throw Exception(jsonData['message'] ?? 'Gagal mengambil keranjang');
    }
  }

  // Menambahkan produk ke keranjang
  Future<bool> addToCart({
    required String productId,
    required int quantity,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Belum login');

    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Gagal menambahkan ke keranjang');
    }
  }

  // Memperbarui kuantitas produk di keranjang
  Future<bool> updateQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Belum login');

    final response = await http.put(
      Uri.parse('$baseUrl/cart/$cartItemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Gagal memperbarui kuantitas');
    }
  }

  // Menghapus item dari keranjang
  Future<bool> removeItem(String cartItemId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Belum login');

    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$cartItemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Gagal menghapus item');
    }
  }

  // Mengosongkan keranjang
  Future<bool> clearCart() async {
    final token = await _getToken();
    if (token == null) throw Exception('Belum login');

    final response = await http.delete(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Gagal mengosongkan keranjang');
    }
  }
}
