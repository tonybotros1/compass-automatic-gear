
  import 'package:flutter/material.dart';

Expanded customBox(
      {required String title, required Widget value, double? width}) {
    return Expanded(
        child: Container(
      width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.grey.shade300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
          ),
          value
        ],
      ),
    ));
  }
