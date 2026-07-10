import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;
  bool _isLoading = false;

  AppUser? get user => _user;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<bool> login(String identifier, String password) async {
    return _runAuthCall(() => ApiService.instance.post(
          ApiConstants.login,
          data: {'identifier': identifier, 'password': password},
        ));
  }

  Future<bool> register(String name, String? email, String? phone, String password) async {
    return _runAuthCall(() => ApiService.instance.post(
          ApiConstants.register,
          data: {'name': name, 'email': email, 'phone': phone, 'password': password},
        ));
  }

  Future<bool> loginWithGoogle({
    required String googleId,
    required String email,
    required String name,
    String? avatar,
  }) async {
    return _runAuthCall(() => ApiService.instance.post(
          ApiConstants.googleAuth,
          data: {'googleId': googleId, 'email': email, 'name': name, 'avatar': avatar},
        ));
  }

  Future<bool> forgotPassword(String identifier) async {
    try {
      await ApiService.instance.post(ApiConstants.forgotPassword, data: {'identifier': identifier});
      return true;
    } catch (e) {
      _errorMessage = 'Could not send reset code. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.instance.clearToken();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> _runAuthCall(Future Function() call) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await call();
      final data = response.data;
      await ApiService.instance.saveToken(data['token']);
      _user = AppUser.fromJson(data['user']);
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please check your details and try again.';
      _status = AuthStatus.unauthenticated;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
