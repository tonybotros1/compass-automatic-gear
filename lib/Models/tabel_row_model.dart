import 'package:flutter/material.dart';

class RowCellConfig {
  final String initialValue;
  final int flex;
  final bool isEnabled;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  // You can extend this class with more properties (e.g., decoration, keyboard type)

  RowCellConfig({
    required this.initialValue,
    this.flex = 1,
    this.isEnabled = false,
    this.controller,
    this.onChanged,
  });
}
