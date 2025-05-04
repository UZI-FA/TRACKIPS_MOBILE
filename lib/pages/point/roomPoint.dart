import 'package:flutter/material.dart';
import 'package:trackips_mobile/pages/point/point.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class RoomPoint extends StatefulWidget  implements Point{
  final String name;
  final LatLng coordinates;

  RoomPoint({super.key, required this.name, required this.coordinates});

  final GlobalKey<_RoomPointState> _key = GlobalKey<_RoomPointState>();

  @override
  State<RoomPoint> createState() => _RoomPointState();

  @override
  void togglePoint() => _key.currentState?.togglePoint();

  @override
  Widget getDesc() => _key.currentState?.getDesc() ?? const SizedBox.shrink();

  @override
  Marker buildMarker() {
    return Marker(
      point: coordinates,
      width: 100,
      height: 12,
      child: this,
    );
  }
}

class _RoomPointState extends State<RoomPoint>{
  int iconState = 1;

  TextStyle getDefaultTextStyle(){
    return const TextStyle(
      fontSize: 12,
      backgroundColor: Colors.black,
      color: Colors.white,
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
      child: Text(
          widget.name,
          textAlign: TextAlign.center,
          style: getDefaultTextStyle()
      )
    );
  }
}