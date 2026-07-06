import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../services/auth_checkout_services.dart';

// Provider untuk menangani logika Checkout
class CheckoutProvider extends ChangeNotifier {
  final CheckoutService _checkoutService = CheckoutService();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi untuk menjalankan proses checkout
  Future<bool> checkout({
    required List<CartModel> items,
    required int totalPrice,
    required String shippingAddress,
    required String notes,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final success = await _checkoutService.checkout(
        items: items,
        totalPrice: totalPrice,
        shippingAddress: shippingAddress,
        notes: notes,
      );

      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
