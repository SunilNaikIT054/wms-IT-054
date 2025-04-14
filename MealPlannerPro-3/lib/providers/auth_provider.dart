import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider() {
    _loadUserFromStorage();
  }

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null && _token != null;

  Future<void> _loadUserFromStorage() async {
    try {
      _isLoading = true;
      notifyListeners();

      final storageService = StorageService();
      final userData = await storageService.getUser();
      final userToken = await storageService.getToken();

      if (userData != null) {
        _user = User.fromJson(userData);
      }

      if (userToken != null) {
        _token = userToken;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load user data: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.login(email: email, password: password);

      if (response['success']) {
        _user = User.fromJson(response['user']);
        _token = response['token'];

        // Save user data to storage
        final storageService = StorageService();
        await storageService.saveUser(_user!.toJson());
        await storageService.saveToken(_token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login failed: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );

      if (response['success']) {
        _user = User.fromJson(response['user']);
        _token = response['token'];

        // Save user data to storage
        final storageService = StorageService();
        await storageService.saveUser(_user!.toJson());
        await storageService.saveToken(_token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Registration failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.forgotPassword(email: email);

      _isLoading = false;
      
      if (response['success']) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to send password reset email';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Password reset failed: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> updateUserProfile(User updatedUser) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.updateUserProfile(
        userId: updatedUser.id,
        token: _token!,
        name: updatedUser.name,
        phone: updatedUser.phone,
        address: updatedUser.address,
      );

      if (response['success']) {
        _user = User.fromJson(response['user']);

        // Update user data in storage
        final storageService = StorageService();
        await storageService.saveUser(_user!.toJson());

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Failed to update profile';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Profile update failed: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.changePassword(
        userId: _user!.id,
        token: _token!,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _isLoading = false;
      
      if (response['success']) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to change password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Password change failed: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Clear user data from storage
      final storageService = StorageService();
      await storageService.clearUser();
      await storageService.clearToken();

      // Clear user data from memory
      _user = null;
      _token = null;
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Logout failed: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
