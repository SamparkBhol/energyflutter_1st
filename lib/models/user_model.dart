import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String avatarUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  static UserModel empty() {
    return UserModel(uid: '', name: '', email: '', avatarUrl: '');
  }

  bool get isEmpty => uid.isEmpty;
}

class UserPreferences {
  final bool receiveNotifications;
  final bool darkMode;

  UserPreferences({
    required this.receiveNotifications,
    required this.darkMode,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> data) {
    return UserPreferences(
      receiveNotifications: data['receiveNotifications'] ?? true,
      darkMode: data['darkMode'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiveNotifications': receiveNotifications,
      'darkMode': darkMode,
    };
  }

  static UserPreferences defaultPreferences() {
    return UserPreferences(receiveNotifications: true, darkMode: false);
  }
}

class UserModelProvider with ChangeNotifier {
  UserModel _user = UserModel.empty();
  UserPreferences _preferences = UserPreferences.defaultPreferences();

  UserModel get user => _user;
  UserPreferences get preferences => _preferences;

  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updatePreferences(UserPreferences newPreferences) {
    _preferences = newPreferences;
    notifyListeners();
  }

  void clearUserData() {
    _user = UserModel.empty();
    _preferences = UserPreferences.defaultPreferences();
    notifyListeners();
  }
}
