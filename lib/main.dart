// main.dart
import 'package:flutter/material.dart';
// 54e
import 'pages/tracker_page.dart';

void main() {
  runApp(IndoorNavigationApp());
}

class IndoorNavigationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tracker(),
    );
  }
}
