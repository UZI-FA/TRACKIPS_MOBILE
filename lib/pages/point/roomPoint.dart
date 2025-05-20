import 'package:flutter/material.dart';
import 'package:trackips_mobile/pages/point/point.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class RoomPoint extends StatefulWidget  implements Point{
  final String name;
  final List<LatLng> coordinates;
  bool visible = true;

  RoomPoint({super.key, required this.name, required this.coordinates});

  final GlobalKey<_RoomPointState> _key = GlobalKey<_RoomPointState>();

  @override
  State<RoomPoint> createState() => _RoomPointState();

  @override
  bool togglePoint(){
    visible = !visible;
    return visible;
  }

  @override
  Widget getDesc() => _key.currentState?.getDesc() ?? const SizedBox.shrink();

  LatLng center_coordinate(List<LatLng> points){
    double totalLat = 0;
    double totalLng = 0;
    
    for (final point in points) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }
    
    return LatLng(
      totalLat / points.length,
      totalLng / points.length,
    );
  }
  @override
  Marker buildMarker() {
    return Marker(
      point: center_coordinate(coordinates),
      width: 100,
      height: 12,
      child: this,
    );
  }

  @override
  Polygon buildPolygon() {
    return Polygon(
      hitValue: "Akademik",
      points: [
        LatLng(-6.409106, 108.281527),
        LatLng(-6.409156, 108.281528), 
        LatLng(-6.409156, 108.281494),
        LatLng(-6.409308, 108.281461),
        LatLng(-6.409310, 108.281403),
        LatLng(-6.409105, 108.281405),
      ],
      color: Colors.blue.withValues(alpha: 0.2),
      borderColor: Colors.red.withValues(alpha: 0.4),
      borderStrokeWidth: 2
    );
  }
}

class _RoomPointState extends State<RoomPoint>{
  int iconState = 1;

  TextStyle getDefaultTextStyle(){
    return const TextStyle(
      fontSize: 12,
      // backgroundColor: Colors.black,
      color: Colors.black,
    );
  }

  Container buildTextWidget(String word) {
    return Container(
        alignment: Alignment.center,
        child: Text(
            word,
            textAlign: TextAlign.center,
            style: getDefaultTextStyle()
        )
    );
  }

  Widget getDesc(){
    return Container();
  }
  void togglePoint(){
    setState(() {
      iconState++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 200,
      width: 200,
      child: Text(
          widget.name,
          textAlign: TextAlign.center,
          style: getDefaultTextStyle()
      )
    );
  }
}