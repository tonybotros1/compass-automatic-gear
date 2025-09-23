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
