import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> products = [];
  List<CategoryModel> categories = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? errorMessage;

  String search = '';
  String selectedCategory = '';
  String selectedSort = '';
  int currentPage = 1;
  final int limit = 10;

  Future<void> getInitialData() async {
    await getCategories();
    await getProducts();
  }

  Future<void> getProducts() async {
    isLoading = true;
    errorMessage = null;
    currentPage = 1;
    hasMore = true;
    notifyListeners();

    try {
      final newProducts = await _productService.getProducts(
        search: search,
        categoryId: selectedCategory,
        sort: selectedSort,
        page: currentPage,
        limit: limit,
      );

      products = newProducts;
      if (newProducts.length < limit) {
        hasMore = false;
      }
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      currentPage++;
      final newProducts = await _productService.getProducts(
        search: search,
        categoryId: selectedCategory,
        sort: selectedSort,
        page: currentPage,
        limit: limit,
      );

      if (newProducts.isEmpty) {
        hasMore = false;
      } else {
        products.addAll(newProducts);
        if (newProducts.length < limit) {
          hasMore = false;
        }
      }

      isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    try {
      categories = await _productService.getCategories();
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void setSearch(String value) {
    search = value;
    getProducts();
  }

  void setCategory(String value) {
    selectedCategory = value;
    getProducts();
  }

  void setSort(String value) {
    selectedSort = value;
    getProducts();
  }

  void resetFilter() {
    search = '';
    selectedCategory = '';
    selectedSort = '';
    getProducts();
  }
}