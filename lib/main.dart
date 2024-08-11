import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:community_energy_optimizer/screens/login_screen.dart';
import 'package:community_energy_optimizer/screens/dashboard_screen.dart';
import 'package:community_energy_optimizer/screens/settings_screen.dart';
import 'package:community_energy_optimizer/screens/trading_screen.dart';
import 'package:community_energy_optimizer/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Energy Optimizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/settings': (context) => SettingsScreen(),
        '/trading': (context) => TradingScreen(),
      },
    );
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Energy Optimizer',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}
