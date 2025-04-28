// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'indoor_map_screen.dart';
import 'login_page.dart';

void main() {
  runApp(IndoorNavigationApp());
}

class IndoorNavigationApp extends StatefulWidget {
  const IndoorNavigationApp({Key? key}) : super(key: key);

  @override
  State<IndoorNavigationApp> createState() => _IndoorNavigationAppState();
}

class _IndoorNavigationAppState extends State<IndoorNavigationApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        isDarkTheme: _isDarkTheme,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
