import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Community Energy Optimizer';
  static const String apiBaseUrl = 'https://api.community-energy-optimizer.com';
  static const Color primaryColor = Color(0xFF0A73EB);
  static const Color accentColor = Color(0xFF34A853);
  static const double defaultPadding = 16.0;
  static const EdgeInsets defaultMargin = EdgeInsets.all(16.0);

  static const Map<String, String> errorMessages = {
    'user-not-found': 'No user found with this email.',
    'wrong-password': 'Incorrect password. Please try again.',
    'network-request-failed': 'Network error. Please check your connection.',
  };
}
