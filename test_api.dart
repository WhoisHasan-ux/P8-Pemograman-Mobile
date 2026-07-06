import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final base = 'https://api-tb-f2wk.onrender.com/api';

  // Login
  final loginRes = await http.post(
    Uri.parse('$base/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': 'hasan@example.com', 'password': 'hasan123'}),
  );
  print('LOGIN: ${loginRes.statusCode}');
  final loginData = jsonDecode(loginRes.body);
  
  if (loginData['data'] == null) {
    print('Login failed: ${loginRes.body}');
    return;
  }
  
  final token = loginData['data']['access_token'];
  final authHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // GET /cart
  try {
    final r = await http.get(Uri.parse('$base/cart'), headers: authHeaders);
    print('GET /cart -> ${r.statusCode}: ${r.body.length > 400 ? r.body.substring(0, 400) : r.body}');
  } catch(e) { print('GET /cart ERROR: $e'); }

  // GET /orders
  try {
    final r = await http.get(Uri.parse('$base/orders'), headers: authHeaders);
    print('GET /orders -> ${r.statusCode}: ${r.body.length > 400 ? r.body.substring(0, 400) : r.body}');
    
    final data = jsonDecode(r.body);
    if (data['data'] != null && (data['data'] as List).isNotEmpty) {
      final id = data['data'][0]['id'];
      final r2 = await http.get(Uri.parse('$base/orders/$id'), headers: authHeaders);
      print('GET /orders/$id -> ${r2.statusCode}: ${r2.body.length > 600 ? r2.body.substring(0, 600) : r2.body}');
    }
  } catch(e) { print('GET /orders ERROR: $e'); }

  // POST /cart
  try {
    final r = await http.post(Uri.parse('$base/cart'), headers: authHeaders,
      body: jsonEncode({'product_id': '23d4a234-ce74-4504-8f1c-c0bd4f1a18ef', 'quantity': 1}));
    print('POST /cart -> ${r.statusCode}: ${r.body.length > 400 ? r.body.substring(0, 400) : r.body}');
  } catch(e) { print('POST /cart ERROR: $e'); }

  // DELETE /cart/:id - test
  try {
    final cartR = await http.get(Uri.parse('$base/cart'), headers: authHeaders);
    final cartData = jsonDecode(cartR.body);
    if (cartData['data'] != null && cartData['data']['items'] != null && (cartData['data']['items'] as List).isNotEmpty) {
      final itemId = cartData['data']['items'][0]['id'];
      final r = await http.delete(Uri.parse('$base/cart/$itemId'), headers: authHeaders);
      print('DELETE /cart/$itemId -> ${r.statusCode}: ${r.body}');
    }
  } catch(e) { print('DELETE /cart/:id ERROR: $e'); }

  // DELETE /cart (clear all)
  try {
    final r = await http.delete(Uri.parse('$base/cart'), headers: authHeaders);
    print('DELETE /cart -> ${r.statusCode}: ${r.body}');
  } catch(e) { print('DELETE /cart ERROR: $e'); }

  // POST /orders (checkout)
  try {
    // First add item to cart
    await http.post(Uri.parse('$base/cart'), headers: authHeaders,
      body: jsonEncode({'product_id': '23d4a234-ce74-4504-8f1c-c0bd4f1a18ef', 'quantity': 1}));
    final r = await http.post(Uri.parse('$base/orders'), headers: authHeaders,
      body: jsonEncode({'shipping_address': 'Jl. Test No. 123, Jakarta Selatan 12345', 'notes': 'Test catatan'}));
    print('POST /orders -> ${r.statusCode}: ${r.body.length > 500 ? r.body.substring(0, 500) : r.body}');
  } catch(e) { print('POST /orders ERROR: $e'); }

  // PUT /cart/:id
  try {
    await http.post(Uri.parse('$base/cart'), headers: authHeaders,
      body: jsonEncode({'product_id': '23d4a234-ce74-4504-8f1c-c0bd4f1a18ef', 'quantity': 1}));
    final cartR = await http.get(Uri.parse('$base/cart'), headers: authHeaders);
    final cartData = jsonDecode(cartR.body);
    if (cartData['data'] != null && cartData['data']['items'] != null && (cartData['data']['items'] as List).isNotEmpty) {
      final itemId = cartData['data']['items'][0]['id'];
      final r = await http.put(Uri.parse('$base/cart/$itemId'), headers: authHeaders,
        body: jsonEncode({'quantity': 3}));
      print('PUT /cart/$itemId -> ${r.statusCode}: ${r.body}');
    }
  } catch(e) { print('PUT /cart/:id ERROR: $e'); }
}
