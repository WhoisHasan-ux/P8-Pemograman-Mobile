import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/auth_cart_services.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  Map<String, CartModel> _items = {};
  bool _isLoading = false;

  Map<String, CartModel> get items => _items;
  bool get isLoading => _isLoading;

  int get totalItem {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  int get totalPrice {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.subtotal;
    });
    return total;
  }

  // Mengambil data keranjang dari API
  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      final cartItems = await _cartService.getCart();
      _items.clear();
      for (var item in cartItems) {
        _items[item.productId] = item;
      }
    } catch (e) {
      print('Gagal mengambil keranjang: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(ProductModel product) async {
    // Optimistic UI
    if (_items.containsKey(product.id)) {
      if (_items[product.id]!.quantity < product.stock) {
        _items.update(
          product.id,
          (existing) => CartModel(
            id: existing.id,
            productId: existing.productId,
            productName: existing.productName,
            imageUrl: existing.imageUrl,
            price: existing.price,
            quantity: existing.quantity + 1,
            stock: existing.stock,
          ),
        );
      }
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartModel(
          id: '',
          productId: product.id,
          productName: product.name,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: 1,
          stock: product.stock,
        ),
      );
    }
    notifyListeners();

    try {
      await _cartService.addToCart(productId: product.id, quantity: 1);
      // Sync dengan API untuk mendapatkan ID cart item yang baru
      await fetchCart();
    } catch (e) {
      print('Gagal addToCart: $e');
      await fetchCart(); // Revert
      rethrow;
    }
  }

  Future<void> increaseQuantity(String productId) async {
    if (_items.containsKey(productId)) {
      final cartItem = _items[productId]!;
      if (cartItem.quantity < cartItem.stock) {
        final newQty = cartItem.quantity + 1;
        final cartItemId = cartItem.id;
        
        _items.update(
          productId,
          (existing) => CartModel(
            id: existing.id,
            productId: existing.productId,
            productName: existing.productName,
            imageUrl: existing.imageUrl,
            price: existing.price,
            quantity: newQty,
            stock: existing.stock,
          ),
        );
        notifyListeners();

        try {
          if (cartItemId.isNotEmpty) {
            await _cartService.updateQuantity(cartItemId: cartItemId, quantity: newQty);
          }
        } catch (e) {
          print('Gagal increaseQuantity: $e');
          await fetchCart(); // Revert
        }
      }
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    if (_items.containsKey(productId)) {
      final cartItem = _items[productId]!;
      if (cartItem.quantity > 1) {
        final newQty = cartItem.quantity - 1;
        final cartItemId = cartItem.id;

        _items.update(
          productId,
          (existing) => CartModel(
            id: existing.id,
            productId: existing.productId,
            productName: existing.productName,
            imageUrl: existing.imageUrl,
            price: existing.price,
            quantity: newQty,
            stock: existing.stock,
          ),
        );
        notifyListeners();

        try {
          if (cartItemId.isNotEmpty) {
            await _cartService.updateQuantity(cartItemId: cartItemId, quantity: newQty);
          }
        } catch (e) {
          print('Gagal decreaseQuantity: $e');
          await fetchCart(); // Revert
        }
      } else {
        removeItem(productId);
      }
    }
  }

  Future<void> removeItem(String productId) async {
    if (_items.containsKey(productId)) {
      final cartItemId = _items[productId]!.id;
      _items.remove(productId);
      notifyListeners();

      try {
        if (cartItemId.isNotEmpty) {
          await _cartService.removeItem(cartItemId);
        }
      } catch (e) {
        print('Gagal removeItem: $e');
        await fetchCart(); // Revert
      }
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();

    try {
      await _cartService.clearCart();
    } catch (e) {
      print('Gagal clearCart: $e');
      await fetchCart(); // Revert
    }
  }
}
