import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/pie_chart.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/tabel_section.dart';
import '../../consts.dart';

class TradingDashboard extends StatelessWidget {
  const TradingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: GetX<TradingDashboardController>(
                      init: TradingDashboardController(),
                      builder: (controller) {
                        bool isYearsLoading = controller.allYears.isEmpty;
                        bool isMonthsLoading = controller.allMonths.isEmpty;
                        bool isDaysLoading = controller.allDays.isEmpty;
                        bool isBrandLoading = controller.allBrands.isEmpty;
                        bool isModelLoading = controller.allModels.isEmpty;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            Expanded(
                                child: CustomDropdown(
                              hintText: 'Year',
                              textcontroller: controller.year.value.text,
                              showedSelectedName: 'name',
                              items: isYearsLoading ? {} : controller.allYears,
                              onChanged: (key, value) {
                                controller.year.value.text = value['name'];
                                controller.filterTradesByDate();
                                controller.filterType.value = '';
                                controller.calculateMonthlyTotals(
                                    int.parse(value['name']));
                              },
                            )),
                            Expanded(
                                child: CustomDropdown(
                              hintText: 'Month',
                              textcontroller: controller.month.text,
                              showedSelectedName: 'name',
                              items:
                                  isMonthsLoading ? {} : controller.allMonths,
                              onChanged: (key, value) {
                                controller.allDays.assignAll(
                                    controller.getDaysInMonth(value['name']));
                                controller.month.text = value['name'];
                                controller.filterTradesByDate();
                                controller.filterType.value = '';
                              },
                            )),
                            Expanded(
                                child: CustomDropdown(
                              hintText: 'Day',
                              textcontroller: controller.day.text,
                              showedSelectedName: 'name',
                              items: isDaysLoading ? {} : controller.allDays,
                              onChanged: (key, value) {
                                controller.day.text = value['name'];
                                controller.filterTradesByDate();
                                controller.filterType.value = '';
                              },
                            )),
                            ElevatedButton(
                                style: allButtonStyle,
                                onPressed: () {
                                  controller.filterByCurrentDate('all');
                                  controller.filterType.value = 'All';
                                  // controller.isAllSelected.value = true;
                                  controller.isTodaySelected.value = false;
                                  controller.isThisMonthSelected.value = false;
                                  controller.isThisYearSelected.value = false;
                                  controller.carBrand.value.clear();
                                  controller.carModel.value.clear();
                                  controller.carBrandId.value = '';
                                  controller.carModelId.value = '';
                                  controller.allModels.clear();
                                },
                                child: Text('All')),
                            ElevatedButton(
                                style: todayButtonStyle,
                                onPressed: controller.isTodaySelected.isFalse
                                    ? () {
                                        controller.filterByCurrentDate('today');
                                        controller.filterType.value = 'Today';
                                        // controller.isAllSelected.value = false;
                                        controller.isTodaySelected.value = true;
                                        controller.isThisMonthSelected.value =
                                            false;
                                        controller.isThisYearSelected.value =
                                            false;
                                      }
                                    : null,
                                child: Text('Today')),
                            ElevatedButton(
                                style: thisMonthButtonStyle,
                                onPressed: controller
                                        .isThisMonthSelected.isFalse
                                    ? () {
                                        controller.filterByCurrentDate('month');
                                        controller.filterType.value =
                                            'This Month';
                                        // controller.isAllSelected.value = false;
                                        controller.isTodaySelected.value =
                                            false;
                                        controller.isThisMonthSelected.value =
                                            true;
                                        controller.isThisYearSelected.value =
                                            false;
                                      }
                                    : null,
                                child: Text('This Month')),
                            ElevatedButton(
                                style: thisYearButtonStyle,
                                onPressed: controller.isThisYearSelected.isFalse
                                    ? () {
                                        controller.filterByCurrentDate('year');
                                        controller.filterType.value =
                                            'This Year';
                                        // controller.isAllSelected.value = false;
                                        controller.isTodaySelected.value =
                                            false;
                                        controller.isThisMonthSelected.value =
                                            false;
                                        controller.isThisYearSelected.value =
                                            true;
                                      }
                                    : null,
                                child: Text('This Year')),
                            ElevatedButton(
                                style: newButtonStyle,
                                onPressed: controller
                                        .isNewStatusSelected.isFalse
                                    ? () {
                                        controller.filterType.value =
                                            'Buy Date';
                                        controller.isNewStatusSelected.value =
                                            true;
                                        controller.isSoldStatusSelected.value =
                                            false;
                                        controller.filterTradesByDate();
                                      }
                                    : null,
                                child: Text('Buy Date')),
                            ElevatedButton(
                                style: soldButtonStyle,
                                onPressed: controller
                                        .isSoldStatusSelected.isFalse
                                    ? () {
                                        controller.filterType.value =
                                            'Sell Date';
                                        controller.isSoldStatusSelected.value =
                                            true;
                                        controller.isNewStatusSelected.value =
                                            false;
                                        controller.filterTradesByDate();
                                      }
                                    : null,
                                child: Text('Sell Date')),
                            Expanded(
                              child: CustomDropdown(
                                showedSelectedName: 'name',
                                textcontroller: controller.carBrand.value.text,
                                hintText: 'Car Brand',
                                items:
                                    isBrandLoading ? {} : controller.allBrands,
                                onChanged: (key, value) {
                                  controller.carModel.value.clear();
                                  controller.getModelsByCarBrand(key);
                                  controller.carBrand.value.text =
                                      value['name'];
                                  controller.carBrandId.value = key;
                                  controller.carModelId.value = '';
                                  controller.filterTradesByDate();
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomDropdown(
                                showedSelectedName: 'name',
                                textcontroller: controller.carModel.value.text,
                                hintText: 'Car Model',
                                items:
                                    isModelLoading ? {} : controller.allModels,
                                onChanged: (key, value) {
                                  controller.carModel.value.text =
                                      value['name'];
                                  controller.carModelId.value = key;
                                  controller.filterTradesByDate();
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      GetX<TradingDashboardController>(builder: (controller) {
                    return Row(
                      spacing: 5,
                      children: [
                        customBox(
                            title: 'NUMBER OF CARS',
                            value: Text(
                              '${controller.numberOfCars.value}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                  fontSize: 16),
                            )),
                        customBox(
                            title: 'REVENUE',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalReceivesForAllTrades.value}',
                                color: Colors.green,
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalPaysForAllTrades.value}',
                                color: Colors.red,
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'NET',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalNETsForAllTrades.value}',
                                color: Colors.blueGrey,
                                fontSize: 16,
                                isBold: true)),
                      ],
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 300),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child:
                        GetX<TradingDashboardController>(builder: (controller) {
                      return controller.filteredTrades.isNotEmpty
                          ? tableOfTrades(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            )
                          : controller.filteredTrades.isEmpty &&
                                  controller.isScreenLoding.isTrue
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No Data'),
                                  ),
                                );
                    }),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    double chartWidth = constraints.maxWidth / 4;
                    // double lineChartWidth = constraints.maxWidth * (3 / 4);
                    double chartHeight = 300; // chartWidth * (11 / 16);
                    double lineChartHeight = 300;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.grey.shade300,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          hintMark(color: Colors.green),
                                          Text(
                                            'New',
                                            style: hintMarkTestStyle,
                                          ),
                                          hintMark(color: Colors.blueGrey),
                                          Text(
                                            'Sold',
                                            style: hintMarkTestStyle,
                                          ),
                                        ],
                                      ),
                                      GetX<TradingDashboardController>(
                                          builder: (controller) {
                                        return Text(controller.filterType.value,
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.bold));
                                      })
                                    ],
                                  ),
                                ),
                                GetX<TradingDashboardController>(
                                    builder: (controller) {
                                  return SizedBox(
                                    width: chartWidth,
                                    height: chartHeight,
                                    child: PieChart(
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              pieTouchResponse) {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              controller.touchedIndex.value =
                                                  -1;
                                              return;
                                            }
                                            controller.touchedIndex.value =
                                                pieTouchResponse.touchedSection!
                                                    .touchedSectionIndex;
                                          },
                                        ),
                                        borderData: FlBorderData(
                                          border: Border.all(),
                                          show: true,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 0,
                                        sections: showingSections(
                                            controller.touchedIndex.value,
                                            controller.newPercentage.value,
                                            controller.soldPercentage.value,
                                            chartWidth,
                                            chartWidth),
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.grey.shade300,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          spacing: 10,
                                          children: [
                                            hintMark(color: Colors.green),
                                            Text(
                                              'Revenue',
                                              style: hintMarkTestStyle,
                                            ),
                                            hintMark(color: Colors.red),
                                            Text(
                                              'Expenses',
                                              style: hintMarkTestStyle,
                                            ),
                                            hintMark(color: Colors.blueGrey),
                                            Text(
                                              'Net',
                                              style: hintMarkTestStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  GetX<TradingDashboardController>(
                                      builder: (controller) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      width: double.infinity,
                                      height: lineChartHeight,
                                      child: LineChart(
                                        _buildMonthlyLineData(
                                            controller.revenue,
                                            controller.expenses,
                                            controller.net),
                                        duration:
                                            const Duration(milliseconds: 250),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            )),
                      ],
                    );
                  }),
                )),
              ],
            ),
          );
        }));
  }

  Container hintMark({required Color color}) {
    return Container(
      height: 10,
      width: 10,
      color: color,
    );
  }
}

LineChartData _buildMonthlyLineData(
  List<double> revenue,
  List<double> expenses,
  List<double> net,
) {
  final spotsRevenue =
      revenue.asMap().entries.map((e) => FlSpot(e.key + 1, e.value)).toList();
  final spotsExpenses =
      expenses.asMap().entries.map((e) => FlSpot(e.key + 1, e.value)).toList();
  final spotsNet =
      net.asMap().entries.map((e) => FlSpot(e.key + 1, e.value)).toList();

  // Compute bounds
  final maxY = [...revenue, ...expenses]
      .fold<double>(0.0, (prev, e) => e > prev ? e : prev);
  final minY = net.fold<double>(0.0, (prev, e) => e < prev ? e : prev);

  // Determine a non-zero interval for left titles
  final diff = maxY - minY;
  double interval;
  if (diff > 0) {
    interval = diff / 5;
  } else if (maxY > 0) {
    interval = maxY / 5;
  } else {
    interval = 1.0;
  }
  if (interval <= 0) interval = 1.0;

  return LineChartData(
    minX: 1,
    maxX: 12,
    minY: minY * 1.1 < 0 ? minY * 1.1 : 0,
    maxY: maxY * 1.1,
    lineTouchData: LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData:
          LineTouchTooltipData(getTooltipColor: (spot) => Colors.black54),
    ),
    gridData: FlGridData(show: false),
    borderData: FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        left: BorderSide(color: Colors.grey.shade300, width: 2),
        right: BorderSide.none,
        top: BorderSide.none,
      ),
    ),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 32,
          getTitlesWidget: _bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: interval,
          reservedSize: 40,
          getTitlesWidget: _leftTitleWidgets,
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    lineBarsData: [
      _lineChartBarData(spotsRevenue, Colors.green),
      _lineChartBarData(spotsExpenses, Colors.red),
      _lineChartBarData(spotsNet, Colors.blueGrey),
    ],
  );
}

SideTitleWidget _bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  const monthLabels = [
    '',
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  final text = (value.toInt() >= 1 && value.toInt() <= 12)
      ? monthLabels[value.toInt()]
      : '';
  return SideTitleWidget(meta: meta, space: 8, child: Text(text, style: style));
}

SideTitleWidget _leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  return SideTitleWidget(
      meta: meta, child: Text(value.toStringAsFixed(0), style: style));
}

LineChartBarData _lineChartBarData(List<FlSpot> spots, Color color) {
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    color: color,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
  );
}

// LineChartData get sampleData1 => LineChartData(
//       lineTouchData: lineTouchData1,
//       gridData: gridData,
//       titlesData: titlesData1,
//       borderData: borderData,
//       lineBarsData: lineBarsData1,
//       minX: 0,
//       maxX: 14,
//       maxY: 4,
//       minY: 0,
//     );

// FlGridData get gridData => const FlGridData(show: false);
// FlBorderData get borderData => FlBorderData(
//       show: true,
//       border: Border(
//         bottom: BorderSide(color: Colors.green, width: 4),
//         left: const BorderSide(color: Colors.transparent),
//         right: const BorderSide(color: Colors.transparent),
//         top: const BorderSide(color: Colors.transparent),
//       ),
//     );

// LineTouchData get lineTouchData1 => LineTouchData(
//       handleBuiltInTouches: true,
//       touchTooltipData: LineTouchTooltipData(
//         getTooltipColor: (touchedSpot) =>
//             Colors.blueGrey.withValues(alpha: 0.8),
//       ),
//     );

// FlTitlesData get titlesData1 => FlTitlesData(
//       bottomTitles: AxisTitles(
//         sideTitles: bottomTitles,
//       ),
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: leftTitles(),
//       ),
//     );

// List<LineChartBarData> get lineBarsData1 => [
//       lineChartBarData1_1,
//       lineChartBarData1_2,
//       lineChartBarData1_3,
//     ];

// SideTitles leftTitles() => SideTitles(
//       getTitlesWidget: leftTitleWidgets,
//       showTitles: true,
//       interval: 1,
//       reservedSize: 40,
//     );

// Widget leftTitleWidgets(double value, TitleMeta meta) {
//   const style = TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 14,
//   );
//   String text;
//   switch (value.toInt()) {
//     case 1:
//       text = '1m';
//       break;
//     case 2:
//       text = '2m';
//       break;
//     case 3:
//       text = '3m';
//       break;
//     case 4:
//       text = '5m';
//       break;
//     case 5:
//       text = '6m';
//       break;
//     default:
//       return Container();
//   }

//   return SideTitleWidget(
//     meta: meta,
//     child: Text(
//       text,
//       style: style,
//       textAlign: TextAlign.center,
//     ),
//   );
// }

// Widget bottomTitleWidgets(double value, TitleMeta meta) {
//   const style = TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 16,
//   );
//   Widget text;
//   switch (value.toInt()) {
//     case 1:
//       text = const Text('JAN', style: style);
//       break;
//     case 2:
//       text = const Text('FEB', style: style);
//       break;
//     case 3:
//       text = const Text('MAR', style: style);
//       break;
//     case 4:
//       text = const Text('APR', style: style);
//       break;
//     case 5:
//       text = const Text('MAY', style: style);
//       break;
//     case 6:
//       text = const Text('JUN', style: style);
//       break;
//     case 7:
//       text = const Text('JUL', style: style);
//       break;
//     case 8:
//       text = const Text('AUG', style: style);
//       break;
//     case 9:
//       text = const Text('SEP', style: style);
//       break;
//     case 10:
//       text = const Text('OCT', style: style);
//       break;
//     case 11:
//       text = const Text('NOV', style: style);
//       break;
//     case 12:
//       text = const Text('DEC', style: style);
//       break;
//     default:
//       text = const Text('', style: style);
//       break;
//   }

//   return SideTitleWidget(
//     meta: meta,
//     space: 10,
//     child: text,
//   );
// }

// SideTitles get bottomTitles => SideTitles(
//       showTitles: true,
//       reservedSize: 32,
//       interval: 1,
//       getTitlesWidget: bottomTitleWidgets,
//     );

// LineChartBarData get lineChartBarData1_1 => LineChartBarData(
//       isCurved: true,
//       color: Colors.green,
//       barWidth: 8,
//       isStrokeCapRound: true,
//       dotData: const FlDotData(show: false),
//       belowBarData: BarAreaData(show: false),
//       spots: const [
//         FlSpot(1, 1),
//         FlSpot(3, 1.5),
//         FlSpot(5, 1.4),
//         FlSpot(7, 3.4),
//         FlSpot(10, 2),
//         FlSpot(12, 2.2),
//         FlSpot(13, 1.8),
//       ],
//     );

// LineChartBarData get lineChartBarData1_2 => LineChartBarData(
//       isCurved: true,
//       color: Colors.pink,
//       barWidth: 8,
//       isStrokeCapRound: true,
//       dotData: const FlDotData(show: false),
//       belowBarData: BarAreaData(
//         show: false,
//         color: Colors.pinkAccent,
//       ),
//       spots: const [
//         FlSpot(1, 1),
//         FlSpot(3, 2.8),
//         FlSpot(7, 1.2),
//         FlSpot(10, 2.8),
//         FlSpot(12, 2.6),
//         FlSpot(13, 3.9),
//       ],
//     );

// LineChartBarData get lineChartBarData1_3 => LineChartBarData(
//       isCurved: true,
//       color: Colors.cyan,
//       barWidth: 8,
//       isStrokeCapRound: true,
//       dotData: const FlDotData(show: false),
//       belowBarData: BarAreaData(show: false),
//       spots: const [
//         FlSpot(1, 2.8),
//         FlSpot(3, 1.9),
//         FlSpot(6, 3),
//         FlSpot(10, 1.3),
//         FlSpot(13, 2.5),
//       ],
//     );
