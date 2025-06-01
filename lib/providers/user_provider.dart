import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final responseJson = await fetchUserProfile();

      if (responseJson != null && responseJson['status'] == 'success') {
        _userProfile = UserProfile.fromJson(responseJson['data']);
      } else {
        _error = 'Failed to load profile';
        _userProfile = null;
      }
    } catch (e) {
      _error = e.toString();
      _userProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
