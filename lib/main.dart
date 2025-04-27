// main.dart
import 'package:flutter/material.dart';
// 54e
import 'indoor_map_screen.dart';

void main() {
  runApp(IndoorNavigationApp());
}

class IndoorNavigationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IndoorMapScreen(),
    );
  }
}
