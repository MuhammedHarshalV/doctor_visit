import 'package:flutter/material.dart';

class CommonSearchBar extends StatelessWidget {
  const CommonSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.close = false,
  });

  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool close;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 39.24,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],

        borderRadius: BorderRadius.circular(20.1),
      ),
      child: Row(
        spacing: 5,
        children: [
          Icon(Icons.search, color: Colors.black, size: 20),
          Expanded(
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              onChanged: onChanged,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13.29,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: 'Search Expense',
                hintStyle: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 13.29,
                  color: Colors.blueGrey,
                ),
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (close == true) Icon(Icons.close),
        ],
      ),
    );
  }
}
