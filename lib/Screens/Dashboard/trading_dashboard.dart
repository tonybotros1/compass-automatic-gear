import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import '../../Controllers/Dashboard Controllers/trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../Widgets/main screen widgets/auto_size_box.dart';
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
                              },
                            )),
                            ElevatedButton(
                                style: todayButtonStyle,
                                onPressed: () {
                                  controller.filterByCurrentDate('today');
                                },
                                child: Text('Today')),
                            ElevatedButton(
                                style: thisMonthButtonStyle,
                                onPressed: () {
                                  controller.filterByCurrentDate('month');
                                },
                                child: Text('This Month')),
                            ElevatedButton(
                                style: thisYearButtonStyle,
                                onPressed: () {
                                  controller.filterByCurrentDate('year');
                                },
                                child: Text('This Year')),
                            Expanded(flex: 2, child: SizedBox()),
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
                SliverFillRemaining(
                  // hasScrollBody: false,
                  child:
                      GetX<TradingDashboardController>(builder: (controller) {
                    return controller.allTrades.isNotEmpty
                        ? tableOfScreens(
                            constraints: constraints,
                            context: context,
                            controller: controller,
                          )
                        : SizedBox();
                  }),
                )
              ],
            ),
          );
        }));
  }
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required TradingDashboardController controller,
}) {
  final trades = controller.filteredTrades.isEmpty
      ? controller.allTrades
      : controller.filteredTrades;

  final dataSource = TradeDataSource(
    trades: trades,
    context: context,
    constraints: constraints,
    controller: controller,
  );

  return DataTableTheme(
    data: DataTableThemeData(
      headingTextStyle: fontStyleForTableHeader,
      dataTextStyle: regTextStyle,
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300;
        }
        return null;
      }),
    ),
    child: PaginatedDataTable(
      headingRowHeight: 45,
      showEmptyRows: false,
      showFirstLastButtons: true,
      rowsPerPage: controller.pagesPerPage.value,
      // availableRowsPerPage: const [5, 10],
      // onRowsPerPageChanged: (rows) {
      //   controller.changeRowsPerPage(rows!);
      // },
      showCheckboxColumn: false,
      horizontalMargin: horizontalMarginForTable,
      dataRowMaxHeight: 40,
      dataRowMinHeight: 30,
      columnSpacing: 5,

      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
      columns: [
        DataColumn(
          label: AutoSizedText(
            text: 'Brand',
            constraints: constraints,
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            text: 'Model',
            constraints: constraints,
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Buy Date',
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Sell Date',
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Paid',
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Received',
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Net',
          ),
          // onSort: controller.onSort,
        ),
      ],
      source: dataSource,
    ),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> tradeData, context, constraints,
    tradeId, TradingDashboardController controller) {
  return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300;
        }
        return Colors.white;
      }),
      cells: [
        DataCell(
          FutureBuilder<String>(
            future: controller.getCarBrandName(
              tradeData['car_brand'],
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
        DataCell(
          FutureBuilder<String>(
            future: controller.getCarModelName(
              tradeData['car_brand'],
              tradeData['car_model'],
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
        DataCell(
          FutureBuilder<String>(
            future: controller.getBuyDate(tradeId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
        DataCell(
          FutureBuilder<String>(
            future: controller.getSellDate(
              tradeId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: FutureBuilder<String>(
              future: controller.gettradePaid(tradeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return textForDataRowInTable(
                    color: Colors.red,
                    isBold: true,
                    text: '${snapshot.data}',
                  );
                }
              },
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: FutureBuilder<String>(
              future: controller.gettradeReceived(tradeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return textForDataRowInTable(
                    color: Colors.green,
                    isBold: true,
                    text: '${snapshot.data}',
                  );
                }
              },
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: FutureBuilder<String>(
              future: controller.gettradeNETs(tradeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return textForDataRowInTable(
                    color: Colors.blueGrey,
                    isBold: true,
                    text: '${snapshot.data}',
                  );
                }
              },
            ),
          ),
        ),
      ]);
}

class TradeDataSource extends DataTableSource {
  final List<DocumentSnapshot> trades;
  final BuildContext context;
  final BoxConstraints constraints;
  final TradingDashboardController controller;

  TradeDataSource({
    required this.trades,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= trades.length) return null;

    final trade = trades[index];
    final tradeData = trade.data() as Map<String, dynamic>;
    final tradeId = trade.id;

    return dataRowForTheTable(
        tradeData, context, constraints, tradeId, controller);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => trades.length;

  @override
  int get selectedRowCount => 0;
}
