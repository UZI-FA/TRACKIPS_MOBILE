import 'package:flutter/material.dart';
import 'package:trackips_mobile/pages/point/point.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class UserPoint extends StatefulWidget  implements Point{
  final String name;
  final LatLng coordinates;

  UserPoint({super.key, required this.name, required this.coordinates});

  final GlobalKey<_UserPointState> _key = GlobalKey<_UserPointState>();

  @override
  State<UserPoint> createState() => _UserPointState();

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

class _UserPointState extends State<UserPoint>{
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