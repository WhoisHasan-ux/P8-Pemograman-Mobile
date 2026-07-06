// Model untuk menyimpan data item di keranjang belanja
class CartModel {
  final String id; // ID dari item keranjang itu sendiri
  final String productId;
  final String productName;
  final String imageUrl;
  final int price;
  int quantity;
  final int stock;

  CartModel({
    this.id = '',
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    required this.stock,
  });

  // Getter untuk menghitung subtotal dari produk ini
  int get subtotal => price * quantity;

  // Mengubah data JSON dari API menjadi object CartModel
  factory CartModel.fromJson(Map<String, dynamic> json) {
    // Mengekstrak object product yang bersarang (nested) di dalam items
    final productMap = json['product'] ?? {};

    return CartModel(
      id: json['id'] ?? '',
      productId: productMap['id'] ?? '',
      productName: productMap['name'] ?? 'Unknown Product',
      imageUrl: productMap['image_url'] ?? '',
      price: int.tryParse(productMap['price'].toString()) ?? 0,
      stock: int.tryParse(productMap['stock'].toString()) ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
    );
  }
}
