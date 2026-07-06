// Membuat class untuk data kategori produk
class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String imageUrl;
  final String createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  // Mengubah data JSON kategori dari API menjadi object CategoryModel
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}