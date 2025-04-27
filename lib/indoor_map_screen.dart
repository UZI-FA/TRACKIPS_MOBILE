import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'search_bar.dart';
import 'category_icons.dart';

class IndoorMapScreen extends StatefulWidget {
  @override
  _IndoorMapScreenState createState() => _IndoorMapScreenState();
}

class _IndoorMapScreenState extends State<IndoorMapScreen> {

  TextStyle getDefaultTextStyle() {
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
  
  Marker buildMarker(LatLng coordinates, String word) {
    return Marker(
        point: coordinates,
        width: 100,
        height: 12,
        child: buildTextWidget(word)
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(-6.4091399, 108.281624),
              initialZoom: 20.0,
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
                markers: [
                  buildMarker(LatLng(-6.40935, 108.28138), "Orang"),
              ]),
              CurrentLocationLayer(),
            ],
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
