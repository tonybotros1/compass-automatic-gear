// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class BarChartSample4 extends StatelessWidget {
//   /// Monthly data lists of equal length (e.g., 12 values for each month)
//   final List<double> revenue;
//   final List<double> expenses;
//   final List<double> net;

//   const BarChartSample4({
//     super.key,
//     required this.revenue,
//     required this.expenses,
//     required this.net,
//   })  : assert(revenue.length == expenses.length && expenses.length == net.length);

//   // Color tiers for bars
//   final Color dark = Colors.black;
//   final Color normal = Colors.green;
//   final Color light = Colors.cyan;

//   static const List<String> _monthLabels = [
//     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//   ];

//   Widget _buildBottomTitle(double value, TitleMeta meta) {
//     const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
//     final idx = value.toInt();
//     final text = (idx >= 0 && idx < _monthLabels.length)
//         ? _monthLabels[idx]
//         : '';
//     return SideTitleWidget(meta: meta, child: Text(text, style: style));
//   }

//   Widget _buildLeftTitle(double value, TitleMeta meta) {
//     if (value == meta.max) return Container();
//     const style = TextStyle(fontSize: 10);
//     return SideTitleWidget(meta: meta, child: Text(meta.formattedValue, style: style));
//   }

//   /// Computes the maximum of all provided values
//   double _maxValue() => [...revenue, ...expenses, ...net].reduce((a, b) => a > b ? a : b);

//   /// Computes the minimum of all provided values
//   double _minValue() => [...revenue, ...expenses, ...net].reduce((a, b) => a < b ? a : b);

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.7,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final barsSpace = 6.0 * constraints.maxWidth / 400;
//             final barsWidth = 8.0 * constraints.maxWidth / 400; // thinner bars

//             final minY = (_minValue() * 1.1) < 0 ? _minValue() * 1.1 : 0.0;
//             final maxY = _maxValue() * 1.1;
//             final step = (maxY - minY) / 5;

//             return BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 barTouchData: BarTouchData(enabled: true),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 28,
//                       getTitlesWidget: _buildBottomTitle,
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       interval: step,
//                       getTitlesWidget: _buildLeftTitle,
//                     ),
//                   ),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 gridData: FlGridData(
//                   show: true,
//                   checkToShowHorizontalLine: (v) => (v - minY) % step == 0,
//                   getDrawingHorizontalLine: (v) => FlLine(
//                     color: Colors.red,
//                     strokeWidth: 0.5, // thinner grid lines
//                   ),
//                   drawVerticalLine: false,
//                 ),
//                 borderData: FlBorderData(show: false),
//                 groupsSpace: barsSpace,
//                 barGroups: _buildBarGroups(barsWidth, barsSpace),
//                 minY: minY,
//                 maxY: maxY,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   /// Generates bar groups for each month index
//   List<BarChartGroupData> _buildBarGroups(double barsWidth, double barsSpace) {
//     return List.generate(
//       revenue.length,
//       (i) => BarChartGroupData(
//         x: i,
//         barsSpace: barsSpace,
//         barRods: [
//           BarChartRodData(toY: revenue[i], color: light, width: barsWidth),
//           BarChartRodData(toY: expenses[i], color: normal, width: barsWidth),
//           BarChartRodData(toY: net[i], color: dark, width: barsWidth),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';

// /// A multi-series bar chart using Syncfusion Flutter Charts.
// class SyncfusionMultiBarChart extends StatelessWidget {
//   /// Monthly data lists of equal length (e.g., 12 values for each month)
//   final List<double> revenue;
//   final List<double> expenses;
//   final List<double> net;

//   const SyncfusionMultiBarChart({
//     super.key,
//     required this.revenue,
//     required this.expenses,
//     required this.net,
//   })  : assert(revenue.length == expenses.length && expenses.length == net.length);

//   static const List<String> _months = [
//     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Handle empty data gracefully
//     if (revenue.isEmpty) {
//       return Center(
//         child: Text(
//           'No data available',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       );
//     }

//     // Build data points per series
//     final revenueData = <_ChartData>[];
//     final expensesData = <_ChartData>[];
//     final netData = <_ChartData>[];
//     for (var i = 0; i < revenue.length; i++) {
//       final month = (i < _months.length) ? _months[i] : 'M${i + 1}';
//       revenueData.add(_ChartData(month, revenue[i]));
//       expensesData.add(_ChartData(month, expenses[i]));
//       netData.add(_ChartData(month, net[i]));
//     }

//     // Determine Y-axis bounds with padding
//     double minY = _minValue();
//     double maxY = _maxValue();
//     double paddedMinY = minY < 0 ? minY * 1.1 : 0;
//     double paddedMaxY = maxY * 1.1;

//     // Ensure bounds are not equal to avoid zero interval
//     if (paddedMaxY <= paddedMinY) {
//       paddedMaxY = paddedMinY + 1;
//     }
//     double interval = (paddedMaxY - paddedMinY) / 5;
//     if (interval <= 0) {
//       interval = paddedMaxY > 0 ? paddedMaxY / 5 : 1;
//     }

//     // Use compact number format (e.g., 1.2K, 3M)
//     final NumberFormat compactFormat = NumberFormat.compact(locale: 'en');

//     return SfCartesianChart(
//       primaryXAxis: CategoryAxis(
//         title: AxisTitle(text: 'Month'),
//       ),
//       primaryYAxis: NumericAxis(
//         minimum: paddedMinY,
//         maximum: paddedMaxY,
//         interval: interval,
//         numberFormat: compactFormat,
//         title: AxisTitle(text: 'Value'),
//       ),
//       tooltipBehavior: TooltipBehavior(
//         enable: true,
//         format: 'point.x : point.y',
//         // Format tooltip numbers compactly
//         // numberFormat: compactFormat,
//       ),
//       legend: Legend(isVisible: true, position: LegendPosition.bottom),
//       series: <CartesianSeries<_ChartData, String>>[
//         ColumnSeries<_ChartData, String>(
//           name: 'Revenue',
//           dataSource: revenueData,
//           xValueMapper: (_ChartData data, _) => data.month,
//           yValueMapper: (_ChartData data, _) => data.value,
//           color: Colors.green,
//           width: 0.6,
//           dataLabelSettings: DataLabelSettings(
//             isVisible: false,
//             // Use compact format for data labels
//             // labelFormat: '{value}',
//             textStyle: TextStyle(fontSize: 10),
//             builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//               return Text(compactFormat.format(point.y ?? 0));
//             },
//           ),
//         ),
//         ColumnSeries<_ChartData, String>(
//           name: 'Expenses',
//           dataSource: expensesData,
//           xValueMapper: (_ChartData data, _) => data.month,
//           yValueMapper: (_ChartData data, _) => data.value,
//           color: Colors.red,
//           width: 0.6,
//           dataLabelSettings: DataLabelSettings(
//             isVisible: false,
//             builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//               return Text(compactFormat.format(point.y ?? 0));
//             },
//           ),
//         ),
//         ColumnSeries<_ChartData, String>(
//           name: 'Net',
//           dataSource: netData,
//           xValueMapper: (_ChartData data, _) => data.month,
//           yValueMapper: (_ChartData data, _) => data.value,
//           color: Colors.blueGrey,
//           width: 0.6,
//           dataLabelSettings: DataLabelSettings(
//             isVisible: false,
//             builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//               return Text(compactFormat.format(point.y ?? 0));
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   double _maxValue() {
//     final all = [...revenue, ...expenses, ...net];
//     return all.isNotEmpty
//         ? all.reduce((a, b) => a > b ? a : b)
//         : 0.0;
//   }

//   double _minValue() {
//     final all = [...revenue, ...expenses, ...net];
//     return all.isNotEmpty
//         ? all.reduce((a, b) => a < b ? a : b)
//         : 0.0;
//   }
// }

// /// Simple model for chart points
// class _ChartData {
//   final String month;
//   final double value;
//   _ChartData(this.month, this.value);
// }

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

/// A dynamic multi-series bar chart using Syncfusion Flutter Charts.
/// Accepts arbitrary labels (e.g., months, days) and corresponding data.
class SyncfusionMultiBarChart extends StatelessWidget {
  /// Labels for the X axis (e.g., ['Jan', 'Feb', ...] or ['1', '2', ...]).
  final List<String> labels;

  /// Data lists matching [labels.length].
  final List<double> revenue;
  final List<double> expenses;
  final List<double> net;
  final List<double> carsNumber;

  const SyncfusionMultiBarChart({
    super.key,
    required this.labels,
    required this.revenue,
    required this.expenses,
    required this.net,
    required this.carsNumber,
  }) : assert(labels.length == revenue.length &&
            revenue.length == expenses.length &&
            expenses.length == net.length &&
            net.length == carsNumber.length);

  @override
  Widget build(BuildContext context) {
    // Empty data handling
    if (labels.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Build data series
    final revenueData = <_ChartData>[];
    final expensesData = <_ChartData>[];
    final netData = <_ChartData>[];
    final carsNumberData = <_ChartData>[];
    for (var i = 0; i < labels.length; i++) {
      revenueData.add(_ChartData(labels[i], revenue[i]));
      expensesData.add(_ChartData(labels[i], expenses[i]));
      netData.add(_ChartData(labels[i], net[i]));
      carsNumberData.add(_ChartData(labels[i], carsNumber[i]));
    }

    // Determine Y-axis bounds
    double minY = _minValue();
    double maxY = _maxValue();
    double paddedMinY = minY < 0 ? minY * 1.1 : 0;
    double paddedMaxY = maxY * 1.1;
    if (paddedMaxY <= paddedMinY) paddedMaxY = paddedMinY + 1;
    double interval = (paddedMaxY - paddedMinY) / 5;
    if (interval <= 0) interval = paddedMaxY > 0 ? paddedMaxY / 5 : 1;

    // Compact number formatting (e.g., 1.2K, 3M)
    final NumberFormat compactFormat = NumberFormat.compact(locale: 'en');

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(text: ''),
      ),
      primaryYAxis: NumericAxis(
        minimum: paddedMinY,
        maximum: paddedMaxY,
        interval: interval,
        numberFormat: compactFormat,
        title: const AxisTitle(text: ''),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y',
        // numberFormat: compactFormat,
      ),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      series: <CartesianSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          name: 'Count',
          dataSource: carsNumberData,
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.value,
          color: Colors.pink,
          width: 0.6,
          dataLabelSettings: const DataLabelSettings(
              showZeroValue: false,
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto,
              color: Colors.black,
              useSeriesColor: true),
        ),
        ColumnSeries<_ChartData, String>(
          name: 'Revenue',
          dataSource: revenueData,
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.value,
          color: Colors.green,
          width: 0.6,
          dataLabelSettings: const DataLabelSettings(
              showZeroValue: false,
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto,
              color: Colors.black,
              useSeriesColor: true),
        ),
        ColumnSeries<_ChartData, String>(
          name: 'Expenses',
          dataSource: expensesData,
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.value,
          color: Colors.red,
          width: 0.6,
          dataLabelSettings: const DataLabelSettings(
              showZeroValue: false,
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto,
              color: Colors.black),
        ),
        ColumnSeries<_ChartData, String>(
          name: 'Net',
          dataSource: netData,
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.value,
          color: Colors.blueGrey,
          width: 0.6,
          dataLabelSettings: const DataLabelSettings(
              showZeroValue: false,
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto,
              color: Colors.black),
        ),
      ],
    );
  }

  double _maxValue() {
    final all = [...revenue, ...expenses, ...net];
    return all.isNotEmpty ? all.reduce((a, b) => a > b ? a : b) : 0;
  }

  double _minValue() {
    final all = [...revenue, ...expenses, ...net];
    return all.isNotEmpty ? all.reduce((a, b) => a < b ? a : b) : 0;
  }
}

class _ChartData {
  final String category;
  final double value;
  _ChartData(this.category, this.value);
}
