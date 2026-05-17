import 'package:uuid/uuid.dart';
import '../local/auth_local.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthRepository {
  final AuthLocal _authLocal;
  final DatabaseService _dbService = DatabaseService();

  AuthRepository(this._authLocal);

  Future<bool> isFirstLaunch() => _authLocal.isFirstLaunch();
  Future<void> setFirstLaunch(bool value) => _authLocal.setFirstLaunch(value);

  Future<bool> isLoggedIn() => _authLocal.isLoggedIn();
  Future<UserModel?> getUser() async {
    final userId = await _authLocal.getUserId();
    if (userId != null) {
      try {
        return await _dbService.getUserById(userId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await _dbService.login(email, password);
    if (user != null) {
      await _authLocal.saveUserId(user.id);
      await _authLocal.setLoggedIn(true);
      return user;
    }
    return null;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final newUser = UserModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );

    final success = await _dbService.register(newUser);
    if (!success) {
      throw Exception('Email sudah terdaftar');
    }

    await _authLocal.saveUserId(newUser.id);
    await _authLocal.setLoggedIn(true);
    return newUser;
  }

  Future<UserModel> updateProfile(String userId, String name, String email, String? profileImage) async {
    await _dbService.updateUserInfo(userId, name, email, profileImage);
    return await _dbService.getUserById(userId);
  }

  Future<void> logout() async {
    await _authLocal.clearUser();
  }
}
