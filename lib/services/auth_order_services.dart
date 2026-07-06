import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../models/order_detail_model.dart';

class OrderService {
  static const String baseUrl = 'https://api-tb-f2wk.onrender.com/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Mengambil daftar pesanan
  Future<List<OrderModel>> getOrders() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Belum login');

      final url = Uri.parse('$baseUrl/orders');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['data'] != null) {
          final List data = jsonData['data'];
          return data.map((item) => OrderModel.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception(jsonData['message'] ?? 'Gagal mengambil pesanan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil daftar pesanan: $e');
    }
  }

  // Mengambil detail pesanan berdasarkan orderId
  Future<OrderDetailModel> getOrderDetail(String orderId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Belum login');

      final url = Uri.parse('$baseUrl/orders/$orderId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['data'] != null) {
          return OrderDetailModel.fromJson(jsonData['data']);
        }
        throw Exception('Data pesanan tidak ditemukan');
      } else {
        throw Exception(jsonData['message'] ?? 'Gagal mengambil detail pesanan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil detail pesanan: $e');
    }
  }
}
