import 'package:flutter/material.dart';
import 'pages/point/point.dart';
import 'pages/point/userPoint.dart';
import 'pages/point/roomPoint.dart';

class CustomSearchBar extends StatefulWidget {
  final List<Point> points;

  const CustomSearchBar({Key? key, required this.points}) : super(key: key);

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
  
  @override
  Widget build(BuildContext context) {
    return Container(
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
        decoration: InputDecoration(
          hintText: "Search...",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
