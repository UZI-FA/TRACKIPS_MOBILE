import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class Point extends Widget{

  Widget getDesc();
  void togglePoint();
  Marker buildMarker();
}