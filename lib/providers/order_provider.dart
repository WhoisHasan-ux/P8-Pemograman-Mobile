import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/order_detail_model.dart';
import '../services/auth_order_services.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi mengambil semua riwayat pesanan (History)
  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      final fetchedOrders = await _orderService.getOrders();
      _orders = fetchedOrders;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Fungsi mengambil spesifik detail pesanan
  Future<OrderDetailModel?> fetchOrderDetail(String orderId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final detail = await _orderService.getOrderDetail(orderId);
      
      _isLoading = false;
      notifyListeners();
      
      return detail;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}
