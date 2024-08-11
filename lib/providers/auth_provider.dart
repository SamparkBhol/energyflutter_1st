import 'package:flutter/material.dart';
import 'package:community_energy_optimizer/models/user_model.dart';
import 'package:community_energy_optimizer/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    _user = await _authService.signInWithEmailAndPassword(email, password);
    notifyListeners();
  }

  Future<void> register(String email, String password, String name) async {
    _user = await _authService.registerWithEmailAndPassword(email, password, name);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  Stream<UserModel?> get userStream => _authService.user;

  AuthProvider() {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }
}
