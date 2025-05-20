import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class Point extends Widget{

  String get name;
  Widget getDesc();
  bool togglePoint();
  Marker buildMarker();
  Polygon buildPolygon();
}