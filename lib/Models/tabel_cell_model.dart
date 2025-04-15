import 'package:flutter/material.dart';

class TableCellConfig {
  final String label;
  final int flex;
  final bool hasBorder;
  final AlignmentGeometry textAlignment;

  TableCellConfig(
      {required this.label,
      this.flex = 1,
      this.hasBorder = false,
      this.textAlignment = Alignment.centerLeft});
}
