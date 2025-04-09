import 'package:flutter/material.dart';

class CategoryIcons extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.directions_walk, 'label': 'Facilities'},
    {'icon': Icons.restaurant, 'label': 'Food & Beverage'},
    {'icon': Icons.local_mall, 'label': 'Shops'},
    {'icon': Icons.event, 'label': 'Events'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((category) {
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(category['icon'], color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(category['label']),
          ],
        );
      }).toList(),
    );
  }
}
