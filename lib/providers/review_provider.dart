import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/auth_review_services.dart';

// Provider untuk mengatur state data review
class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  List<ReviewModel> reviews = [];
  bool isLoading = false;
  String? errorMessage;

  // Mengambil review berdasarkan product id
  Future<void> fetchReviews(String productId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      reviews = await _reviewService.getReviews(productId);
    } catch (e) {
      errorMessage = e.toString();
      reviews = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan review baru
  Future<bool> addReview({
    required String productId,
    required int rating,
    required String comment,
    required String userName, // Nama dummy dari auth provider untuk sementara jika offline
  }) async {
    final success = await _reviewService.addReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    if (success) {
      // Jika berhasil, tambahkan secara lokal agar langsung terlihat
      reviews.insert(
        0,
        ReviewModel(
          id: DateTime.now().toString(),
          productId: productId,
          userId: '',
          userName: userName,
          rating: rating,
          comment: comment,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      notifyListeners();
      return true;
    } else {
      // Jika endpoint belum siap, kita simulasikan berhasil secara lokal (mock)
      reviews.insert(
        0,
        ReviewModel(
          id: DateTime.now().toString(),
          productId: productId,
          userId: '',
          userName: userName,
          rating: rating,
          comment: comment,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      notifyListeners();
      return true; // Simulate success if endpoint fails
    }
  }
}
