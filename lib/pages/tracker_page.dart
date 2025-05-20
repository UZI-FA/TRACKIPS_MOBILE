import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'point/point.dart';
import 'point/userPoint.dart';
import 'point/roomPoint.dart';
// import '../search_bar.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'search_bar.dart';
// import 'category_icons.dart';

class Tracker extends StatefulWidget {
  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  final LayerHitNotifier roomNotifier = ValueNotifier(null);
  
  List<Point> points = [
    UserPoint(name: "Alice", coordinates: LatLng(-6.40920, 108.28148)),
    UserPoint(name: "Bob", coordinates: LatLng(-6.40935, 108.28138)),
    RoomPoint(name: "LAB", coordinates: 
      [LatLng(-6.40920, 108.28144)]
    ),
  ];

  Future<bool> fetchResouces() async {
    var url = Uri.parse('http://192.168.137.1:8000/api/map/1');
    var response = await http.get(url,headers: {
      'Authorization' : 'Bearer 9fBbqvSou7dl5X1GUTrsCzqgQO6nrAQBKCkhieom2908c496'
    });
    if (response.statusCode == 200) {
      //retrieve data
      var data = jsonDecode(response.body)['data'];
      
      //RoomPoint
      for (var value in data['room']) {
        List<LatLng> bounds = [];
        for (var bound in value['bounds']) {
          // assign bounds 
          bounds.add(LatLng(double.parse(bound['latitude']),double.parse(bound['longitude'])));
        }
        // add new RoomPoint
        points.add(RoomPoint(name: value['name'],coordinates: bounds,));
      }

      //UserPoint
      // for (var value in data['user']) {
      //   points.add(UserPoint(name: value['name'],coordinates: bounds,));
      // }
      return true;
    }
    return false;
  }

  @override
  void initState(){
    buildPoint(points);
    // fetchResouces();
    super.initState();
    roomNotifier.addListener((){
      final hitVal = roomNotifier.value;
      var valhit = hitVal?.hitValues.toString();
      if(valhit != "Akademik"){
        setState(() {
          _showOverlay = true;
        });
      }
    });
  }



  final markers = <Marker>[];
  final polygons = <Polygon>[];
  void buildPoint(List<Point> points){
    for (final point in points) {
      if(point is UserPoint){
        markers.add(
          point.buildMarker()
        );
      }else if (point is RoomPoint){
        markers.add(
          point.buildMarker()
        );
        polygons.add(
          point.buildPolygon()
        );
      }
    }
  }

  String selectedMap ="1";
  bool _showOverlay = false;
  
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
    // List<Marker> markers = points.map((p) => p.buildMarker()).toList();
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
          // // Coordinates info box
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
          if (_showOverlay)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.35,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with Title and Close Button
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "_selectedPolygonId" ?? 'Location',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.close, size: 20),
                              padding: EdgeInsets.zero,
                              onPressed: () => setState(() => _showOverlay = false),
                            ),
                          ],
                        ),
                      ),
                      // Scrollable Content
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (ctx, index) => ListTile(
                            title: Text('Option ${index + 1}'),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            onTap: () {
                              print('Selected option ${index + 1}');
                              setState(() => _showOverlay = false);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Positioned(
          //   top: 40,
          //   left: 20,
          //   right: 20,
          //   child: StandardSearchAnchor(
          //         searchBar: StandardSearchBar(
          //           bgColor: Colors.white,
          //         ),
          //         suggestions: StandardSuggestions(
          //           suggestions: [
          //             StandardSuggestion(text: 'Suggestion 1',),
          //             StandardSuggestion(text: 'Suggestion 2'),
          //             StandardSuggestion(text: 'Suggestion 3'),
          //           ],
          //         ),
          //       ),
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
