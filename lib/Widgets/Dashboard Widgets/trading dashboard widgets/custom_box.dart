import 'package:flutter/material.dart';

Widget customBox({
  required String title,
  required Widget value,
  double? width,
  Widget? addValue,
  Widget? refresh,
  int? flex,
}) {
  final container = Container(
    width: width,
    height: 70,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey.shade300,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              addValue ?? const SizedBox(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [value, refresh ?? const SizedBox()],
          ),
        ),
      ],
    ),
  );

  // Use Expanded only if width is not specified
  return width == null
      ? Expanded(flex: flex ?? 1, child: container)
      : container;
}
