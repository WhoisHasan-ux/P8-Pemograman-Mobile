class OrderModel {
  final String orderId;
  final String orderNumber;
  final String orderDate;
  final int totalItem;
  final int totalPrice;
  final String status;

  OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.orderDate,
    required this.totalItem,
    required this.totalPrice,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['id']?.toString() ?? '',
      orderNumber: (json['id']?.toString() ?? '').length > 8 
          ? 'ORD-${json['id'].toString().substring(0, 8).toUpperCase()}'
          : 'ORD-XXXXX',
      orderDate: json['created_at'] ?? '',
      totalItem: int.tryParse(json['items_count']?.toString() ?? '0') ?? 0,
      totalPrice: int.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': orderId,
      'order_number': orderNumber,
      'created_at': orderDate,
      'items_count': totalItem,
      'total_amount': totalPrice,
      'status': status,
    };
  }
}
