class CheckoutModel {
  final String id;
  final String userId;
  final int totalPrice;
  final String status;
  final String createdAt;

  CheckoutModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      totalPrice: int.tryParse(json['total_price'].toString()) ?? 0,
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt,
    };
  }
}
