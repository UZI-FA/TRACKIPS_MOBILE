// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
