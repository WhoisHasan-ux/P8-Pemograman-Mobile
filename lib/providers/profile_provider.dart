import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_profile_services.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthProfileService _profileService = AuthProfileService();

  UserModel? _profile;
  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi internal untuk memuat token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Membersihkan data provider (saat logout)
  void clearData() {
    _profile = null;
    _errorMessage = '';
    notifyListeners();
  }

  // Mengambil profil dari API
  Future<bool> loadProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan, silakan login ulang.');
      }

      final fetchedProfile = await _profileService.getProfile(token);
      _profile = fetchedProfile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Update profil
  Future<bool> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan, silakan login ulang.');
      }

      final updatedProfile = await _profileService.updateProfile(token, fullName, phone);
      _profile = updatedProfile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
