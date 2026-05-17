import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  UserModel? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFirstLaunch = true;

  AuthProvider(this._repository);

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFirstLaunch => _isFirstLaunch;

  Future<void> checkSession() async {
    _isLoading = true;
    notifyListeners();

    _isFirstLaunch = await _repository.isFirstLaunch();
    _isLoggedIn = await _repository.isLoggedIn();
    if (_isLoggedIn) {
      _user = await _repository.getUser();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    await _repository.setFirstLaunch(false);
    _isFirstLaunch = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _repository.login(email, password);
      if (user != null) {
        _user = user;
        _isLoggedIn = true;
        _errorMessage = null;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Email atau kata sandi salah';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final user = await _repository.register(name, email, password);
      _user = user;
      _isLoggedIn = true;
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateProfile(String name, String email, {String? profileImage}) async {
    if (_user == null) return false;
    _setLoading(true);
    try {
      final updatedUser = await _repository.updateProfile(_user!.id, name, email, profileImage);
      _user = updatedUser;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
