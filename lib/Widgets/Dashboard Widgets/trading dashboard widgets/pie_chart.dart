
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> showingSections(
    int touchedIndex, newPercentage, solePercentage, width, height) {
  return List.generate(2, (i) {
    final isTouched = i == touchedIndex;
    // final fontSize = isTouched ? 20.0 : 16.0;
    // final radius = isTouched ? 110.0 : 100.0;
    var r = sqrt(pow(height, 2) + pow(width, 2)) / 2;
    final fontSize = isTouched ? 20.0 : 12.0;
    final radius = isTouched ? (r / 2) - 20 : (r / 2) - 30;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: Colors.green,
          value: newPercentage,
          title: '$newPercentage%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            // fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
        );
      case 1:
        return PieChartSectionData(
          color: Colors.blueGrey,
          value: solePercentage,
          title: '$solePercentage%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            // fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
        );

      default:
        throw Exception('Oh no');
    }
  });
}
