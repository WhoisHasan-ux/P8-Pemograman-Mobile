import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  //Inilisasi variabel untuk menyimpan data post list berdasarkan model post
  List<PostModel> posts = [];

  //state default
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchPosts() async {
    try {
      isLoading = true;
      notifyListeners();

      //memanggil service untuk mendapatkan data post
      posts = await PostService.getPosts();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}