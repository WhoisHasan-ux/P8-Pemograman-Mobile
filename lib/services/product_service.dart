import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/category_model.dart';

// Membuat service untuk mengambil data produk dan kategori dari API
class ProductService {
  static const String baseUrl = 'https://api-tb-f2wk.onrender.com/api';

  // Membuat function untuk mengambil daftar produk
  Future<List<ProductModel>> getProducts({
    String search = '',
    String categoryId = '',
    String sort = '',
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      if (search.isNotEmpty) 'search': search,
      if (categoryId.isNotEmpty) 'category': categoryId,
      if (sort.isNotEmpty) 'sort': sort,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final url = Uri.parse('$baseUrl/products').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(url);

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List data = jsonData['data'] ?? [];

      return data.map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    } else {
      throw Exception(jsonData['message'] ?? 'Gagal mengambil produk');
    }
  }

  // Membuat function untuk mengambil daftar kategori
  Future<List<CategoryModel>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');

    final response = await http.get(url);

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List data = jsonData['data'] ?? [];

      return data.map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
    } else {
      throw Exception(jsonData['message'] ?? 'Gagal mengambil kategori');
    }
  }
}
