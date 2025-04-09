import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
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
