import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/photo_service.dart';


class PhotoProvider extends ChangeNotifier {
  //Inilisasi variabel untuk menyimpan data photo list berdasarkan model photo
  List<PhotoModel> photos = [];

  //state default
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchPhotos() async {
    try {
      isLoading = true;
      notifyListeners();

      //memanggil service untuk mendapatkan data photo
      photos = await PhotoService.getPhotos();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
