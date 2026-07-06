// Membuat class untuk data review produk
class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Mengubah data JSON review dari API menjadi object ReviewModel
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? json['userName'] ?? 'User',
      rating: int.tryParse(json['rating'].toString()) ?? 5,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  // Mengubah object ReviewModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}
