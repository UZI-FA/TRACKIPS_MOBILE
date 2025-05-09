import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'point/point.dart';
import 'point/userPoint.dart';
import 'point/roomPoint.dart';
// import 'search_bar.dart';
// import 'category_icons.dart';

class Tracker extends StatefulWidget {
  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  final LayerHitNotifier roomNotifier = ValueNotifier(null);

  @override
  void initState(){
    super.initState();
    roomNotifier.addListener((){
      final hitVal = roomNotifier.value;
      var valhit = hitVal?.hitValues.toString();
      if(valhit != "Akademik"){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$valhit'),
            duration: Duration(days: 20),
          )
        );
      }
    });
  }

  List<Point> points = [
    UserPoint(name: "Alice", coordinates: LatLng(-6.40920, 108.28148)),
    UserPoint(name: "Bob", coordinates: LatLng(-6.40935, 108.28138)),
    RoomPoint(name: "LAB", coordinates: LatLng(-6.40920, 108.28144)),
  ];

  String selectedMap ="1";
  
  final Map<String, String> mapImages = {
    '1': 'images/Lt_1.jpeg',
    '2': 'images/Lt_2.jpeg',
    '3': 'images/Lt_3.jpeg',
    '4': 'images/Lt_4.jpeg',
    '5': 'images/Lt_5.jpeg',
    '6': 'images/Lt_6.jpeg',
    '7': 'images/Lt_7.jpeg'
  };

  final MapController _mapController = MapController();
  LatLng _center = LatLng(-6.2, 106.816666);

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = points.map((p) => p.buildMarker()).toList();
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(-6.4091399, 108.281624),
              initialZoom: 20.0,
              onPositionChanged: (pos, _) {
                setState(() {
                  _center = pos.center!;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              OverlayImageLayer(
                overlayImages: [
                  OverlayImage(
                    opacity: 0.8,
                    imageProvider: AssetImage(mapImages[selectedMap]!),
                    bounds: LatLngBounds(
                      LatLng(-6.40890, 108.28188), // northeast corner
                      // atas, kanan
                      LatLng(-6.40935, 108.28138), // southwest corner
                      // bawah, kiri
                    ),
                  )
                ]
              ),
              MarkerLayer(
                markers: markers,
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(-6.40940, 108.28138),
                    radius: 0.5,
                    useRadiusInMeter: true,
                  ),
                ],
              ),
              
              PolygonLayer(
                hitNotifier: roomNotifier,
                polygons: 
                [
                  Polygon(
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
                    
                  )
                ]
              )
              ,
              MarkerLayer(
                markers: markers,
              ),
              // CurrentLocationLayer(),
            ],
          ),
          // Crosshair in center
          const Center(
            child: Icon(Icons.add_location, color: Colors.red, size: 32),
          ),
          // Coordinates info box
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withOpacity(0.8),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Center Coordinate:\nLat: ${_center.latitude.toStringAsFixed(6)}, "
                  "Lng: ${_center.longitude.toStringAsFixed(6)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 40,
          //   left: 20,
          //   right: 20,
          //   child: CustomSearchBar(),
          // ),
          // Positioned(
          //   bottom: 20,
          //   left: 20,
          //   right: 20,
          //   child: CategoryIcons(),
          // ),
          Positioned(
            top: 70,
            left: 20,
            child: DropdownButton<String>(
              value: selectedMap,
              items: mapImages.keys.map((label) {
                return DropdownMenuItem(
                  value: label,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMap = value!;
                });
              },
              dropdownColor: Colors.white,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
