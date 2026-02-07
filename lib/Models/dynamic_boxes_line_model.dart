import 'package:flutter/material.dart';

class DynamicBoxesLineModel {
  final String label;
  final String value;
  final IconData icon;
  final double? width;
  final Color? valueColor;
  final double? valueFontSize;
  final double? labelFontSize;
  final bool? isFormated;
  final Color? iconColor;

  DynamicBoxesLineModel({
    required this.label,
    required this.value,
    required this.icon,
    this.width,
    this.valueColor,
    this.labelFontSize,
    this.valueFontSize,
    this.isFormated,
    this.iconColor,
  });
}
