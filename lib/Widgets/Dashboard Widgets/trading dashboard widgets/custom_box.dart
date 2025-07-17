import 'package:flutter/material.dart';

Widget customBox({
  required String title,
  required Widget value,
  double? width,
  int? flex,
}) {
  final container = Container(
    width: width,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey.shade300,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 10),
        value,
      ],
    ),
  );

  // Use Expanded only if width is not specified
  return width == null ? Expanded(flex: flex ?? 1, child: container) : container;
}
