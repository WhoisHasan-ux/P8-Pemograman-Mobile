// Membuat class untuk data produk
class ProductModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int price;
  final int stock;
  final String categoryId;
  final String imageUrl;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String categoryName;
  final String categorySlug;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
    required this.categorySlug,
  });

  // Mengubah data JSON produk dari API menjadi object ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      categoryId: json['category_id'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      categoryName: json['categories']?['name'] ?? '',
      categorySlug: json['categories']?['slug'] ?? '',
    );
  }
}
