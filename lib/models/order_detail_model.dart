class OrderProductModel {
  final String imageUrl;
  final String productName;
  final int price;
  final int quantity;
  final int subtotal;

  OrderProductModel({
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    int price = int.tryParse(json['price']?.toString() ?? '0') ?? 0;
    int quantity = int.tryParse(json['quantity']?.toString() ?? '1') ?? 1;

    return OrderProductModel(
      imageUrl: json['image_url'] ?? '',
      productName: json['product_name'] ?? 'Unknown Product',
      price: price,
      quantity: quantity,
      subtotal: int.tryParse(json['subtotal']?.toString() ?? '0') ?? (price * quantity),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

class OrderDetailModel {
  final String orderId;
  final String orderNumber;
  final List<OrderProductModel> products;
  final int totalItem;
  final int totalPrice;
  final String orderDate;
  final String status;
  final String shippingAddress;
  final String notes;

  OrderDetailModel({
    required this.orderId,
    required this.orderNumber,
    required this.products,
    required this.totalItem,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    this.shippingAddress = '',
    this.notes = '',
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    var productList = json['items'] as List? ?? [];
    List<OrderProductModel> parsedProducts = productList
        .map((p) => OrderProductModel.fromJson(p))
        .toList();

    return OrderDetailModel(
      orderId: json['id']?.toString() ?? '',
      orderNumber: (json['id']?.toString() ?? '').length > 8 
          ? 'ORD-${json['id'].toString().substring(0, 8).toUpperCase()}'
          : 'ORD-XXXXX',
      products: parsedProducts,
      totalItem: int.tryParse(json['items_count']?.toString() ?? '0') ?? parsedProducts.fold(0, (sum, item) => sum + item.quantity),
      totalPrice: int.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      orderDate: json['created_at'] ?? '',
      status: json['status'] ?? 'pending',
      shippingAddress: json['shipping_address'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': orderId,
      'order_number': orderNumber,
      'items': products.map((p) => p.toJson()).toList(),
      'items_count': totalItem,
      'total_amount': totalPrice,
      'created_at': orderDate,
      'status': status,
      'shipping_address': shippingAddress,
      'notes': notes,
    };
  }
}
