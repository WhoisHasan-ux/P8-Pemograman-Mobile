import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Membuat service untuk mengambil data review produk dari API
class ReviewService {
  static const String baseUrl = 'https://api-tb-f2wk.onrender.com/api';

  // Mengambil daftar review berdasarkan product_id
  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      final url = Uri.parse('$baseUrl/reviews?product_id=$productId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        // Memeriksa struktur JSON, jika berupa array dalam properti 'data'
        if (jsonData['data'] != null) {
          List<dynamic> data = jsonData['data'];
          return data.map((json) => ReviewModel.fromJson(json)).toList();
        } else if (jsonData is List) {
          return jsonData.map((json) => ReviewModel.fromJson(json)).toList();
        }
        
        return [];
      } else {
        // Jika endpoint belum tersedia (misal 404), kembalikan list kosong
        return [];
      }
    } catch (e) {
      print('Error getReviews: $e');
      return [];
    }
  }

  // Menambahkan review baru
  Future<bool> addReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      final url = Uri.parse('$baseUrl/reviews');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'product_id': productId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error addReview: $e');
      return false;
    }
  }
}
