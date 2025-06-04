import 'package:flutter/material.dart';
import 'pages/point/point.dart';
import 'pages/point/userPoint.dart';
import 'pages/point/roomPoint.dart';
import 'package:flutter_map/flutter_map.dart';

class CustomSearchBar extends StatefulWidget {
  final List<Point> points;
  final MapController mapController;

  const CustomSearchBar({
    Key? key,
    required this.points,
    required this.mapController,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Point> _filteredPoints = [];

  @override
  void initState() {
    super.initState();
    _filteredPoints = widget.points;
  }

  void _filterPoints(String query) {
    setState(() {
      _filteredPoints = widget.points.where((point) {
        return point.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _goToMarker(Point poin) {
    if (poin is RoomPoint) {
      widget.mapController.move(poin.center_coordinate(), 20.0);
    }else if(poin is UserPoint){
      widget.mapController.move(poin.coordinates, 20.0);
    }
  }
  
  @override
Widget build(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      FocusScope.of(context).unfocus(); // dismiss keyboard
      setState(() {
        _searchQuery = '';
      });
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterPoints(_searchQuery);
              });
            },
            onTap: () {
              // Show suggestions again if there's a query
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: "Search...",
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_searchQuery.isNotEmpty && _filteredPoints.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _filteredPoints.length > 5 ? 5 : _filteredPoints.length,
              itemBuilder: (context, index) {
                final point = _filteredPoints[index];
                return ListTile(
                  title: Text(point.name),
                  onTap: () {
                    _searchController.text = point.name;
                    _goToMarker(point);
                    setState(() {
                      _searchQuery = '';
                      _filteredPoints = [point]; // Optional: limit to selected
                    });
                    FocusScope.of(context).unfocus(); // close keyboard
                  },
                );
              },
            ),
          ),
      ],
    ),
  );
}


}
