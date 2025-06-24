import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Responsive/responsive.dart';
import 'package:datahubai/Widgets/Trade%20screen%20widgets/trade_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Trading Controllers/car_trading_controller.dart';
import '../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../Widgets/Trade screen widgets/capital_dialog.dart';
import '../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../consts.dart';
// import 'package:data_table_2/data_table_2.dart';

class CarTrading extends StatelessWidget {
  const CarTrading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        GetX<CarTradingController>(
                          init: CarTradingController(),
                          builder: (controller) {
                            return ScreenSize.isWeb(context)
                                ? searchBar(
                                    search: controller.search,
                                    constraints: constraints,
                                    context: context,
                                    // controller: controller,
                                    title: 'Search for Trades',
                                    button: Row(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        capitalButton(context, controller),
                                        outstandingButton(context, controller),
                                        generalExpensesButton(
                                            context, controller),
                                        // Spacer(),
                                        newtradeesButton(context, controller),
                                      ],
                                    ),
                                  )
                                : SizedBox();
                          },
                        ),
                        Expanded(
                          child: GetX<CarTradingController>(
                            builder: (controller) {
                              // final _ = controller.selectedTradeId.value;
                              if (controller.isScreenLoding.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (controller.allTrades.isEmpty) {
                                return const Center(
                                  child: Text('No Element'),
                                );
                              }
                              return SingleChildScrollView(
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  child: tableOfScreens(
                                    constraints: constraints,
                                    context: context,
                                    controller: controller,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 4),
                  child: GetX<CarTradingController>(builder: (controller) {
                    return ScreenSize.isWeb(context)
                        ? Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total Paid:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              textForDataRowInTable(
                                  text:
                                      '${controller.totalPaysForAllTrades.value}',
                                  color: Colors.red,
                                  isBold: true),
                              Text(
                                'Total Received:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              textForDataRowInTable(
                                  text:
                                      '${controller.totalReceivesForAllTrades.value}',
                                  color: Colors.green,
                                  isBold: true),
                              Text(
                                'Net:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              textForDataRowInTable(
                                  text:
                                      '${controller.totalNETsForAllTrades.value}',
                                  color: Colors.blueGrey,
                                  isBold: true)
                            ],
                          )
                        : SizedBox();
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingController controller,
}) {
  final trades =
      controller.filteredTrades.isEmpty && controller.search.value.text.isEmpty
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
      rowsPerPage: controller.pagesPerPage.value,
      availableRowsPerPage: const [5, 10, 17, 25],
      onRowsPerPageChanged: (rows) {
        controller.changeRowsPerPage(rows!);
      },
      showCheckboxColumn: false,
      horizontalMargin: horizontalMarginForTable,
      dataRowMaxHeight: 40,
      dataRowMinHeight: 30,
      columnSpacing: 10,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
      columns: [
        DataColumn(label: SizedBox()),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizedText(text: 'Car', constraints: constraints),
              AutoSizedText(text: 'Brand', constraints: constraints)
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(text: 'Model', constraints: constraints)
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Year'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Status'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Specification'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizedText(constraints: constraints, text: 'Color'),
              AutoSizedText(constraints: constraints, text: 'Outside'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Inside'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Engine Size'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Mileage'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Date'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.end,
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Paid'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.end,
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Received'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.end,
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(),
              AutoSizedText(constraints: constraints, text: 'Net'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          // headingRowAlignment: MainAxisAlignment.start,
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizedText(constraints: constraints, text: 'Bought'),
              AutoSizedText(constraints: constraints, text: 'From'),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          // headingRowAlignment: MainAxisAlignment.start,
          label: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AutoSizedText(constraints: constraints, text: 'Sold'),
              AutoSizedText(constraints: constraints, text: 'To'),
            ],
          ),
          // onSort: controller.onSort,
        ),
      ],
      source: dataSource,
    ),
  );
}

// Widget tableOfScreens(
//     {required constraints,
//     required context,
//     required CarTradingController controller}) {
//   return DataTableTheme(
//     data: DataTableThemeData(
//       dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
//         if (states.contains(WidgetState.selected)) {
//           return Colors.grey.shade300;
//         }
//         return null;
//       }),
//     ),
//     child: DataTable(
//       showCheckboxColumn: false,
//       horizontalMargin: horizontalMarginForTable,
//       dataRowMaxHeight: 40,
//       dataRowMinHeight: 30,
//       columnSpacing: 5,
//       showBottomBorder: true,
//       dataTextStyle: regTextStyle,
//       headingTextStyle: fontStyleForTableHeader,
//       sortColumnIndex: controller.sortColumnIndex.value,
//       sortAscending: controller.isAscending.value,
//       headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
//       columns: [
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 text: 'Car',
//                 constraints: constraints,
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Year',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Status',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Specification',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Color',
//               ),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Outside',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Inside',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Engine Size',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Mileage',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Date',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Paid',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Received',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         DataColumn(
//           label: Column(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(),
//               AutoSizedText(
//                 constraints: constraints,
//                 text: 'Net',
//               ),
//             ],
//           ),
//           // onSort: controller.onSort,
//         ),
//         const DataColumn(
//           label: Text(''),
//         ),
//       ],
//       rows: controller.filteredTrades.isEmpty &&
//               controller.search.value.text.isEmpty
//           ? controller.allTrades.asMap().entries.map<DataRow>((entry) {
//               final index = entry.key;
//               final trade = entry.value;
//               final tradeData = trade.data() as Map<String, dynamic>;
//               final tradeId = trade.id;
//               return dataRowForTheTable(
//                   tradeData, context, constraints, tradeId, controller, index);
//             }).toList()
//           : controller.filteredTrades.asMap().entries.map<DataRow>((entry) {
//               final index = entry.key;
//               final trade = entry.value;
//               final tradeData = trade.data() as Map<String, dynamic>;
//               final tradeId = trade.id;
//               return dataRowForTheTable(
//                   tradeData, context, constraints, tradeId, controller, index);
//             }).toList(),
//     ),
//   );
// }

DataRow dataRowForTheTable(Map<String, dynamic> tradeData, context, constraints,
    tradeId, CarTradingController controller, int index) {
  // final isSelected = controller.selectedTradeId.value == tradeId;
  final isEvenRow = index % 2 == 0;
  return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade400;
        }
        return isEvenRow ? Colors.grey.shade200 : Colors.white;
      }),
      // selected: isSelected,
      // onSelectChanged: (selected) {
      //   if (selected != null && selected) {
      //     controller.selectedTradeId.value = tradeId;
      //   } else {
      //     controller.selectedTradeId.value = '';
      //   }
      // },
      cells: [
        DataCell(
            editSection(context, controller, tradeData, constraints, tradeId)),
        DataCell(Text(controller.getdataName(
            tradeData['car_brand'], controller.allBrands))),

        DataCell(
          FutureBuilder<String>(
            future: controller.getCarModelName(
                tradeData['car_brand'], tradeData['car_model']),
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
        // DataCell(
        //   Builder(builder: (_) {
        //     final data = tradeData;

        //     final model = controller.getCachedCarModelName(
        //       data['car_brand'],
        //       data['car_model'],
        //     );
        //     final display = model.isNotEmpty ? model : 'Loading...';

        //     return textForDataRowInTable(text: display, maxWidth: null);
        //   }),
        // ),
        DataCell(Text(
            controller.getdataName(tradeData['year'], controller.allYears))),
        DataCell(tradeData['status'] != ''
            ? statusBox('${tradeData['status']}',
                hieght: 35, width: 60, padding: null)
            : const SizedBox()),
        DataCell(Text(controller.getdataName(
            tradeData['specification'], controller.allCarSpecifications))),
        DataCell(Text(controller.getdataName(
            tradeData['color_out'], controller.allColors))),
        DataCell(Text(controller.getdataName(
            tradeData['color_in'], controller.allColors))),
        DataCell(Text(controller.getdataName(
            tradeData['engine_size'], controller.allEngineSizes))),
        DataCell(Text(tradeData['mileage'])),
        DataCell(
          Text(
              style:
                  TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
              tradeData['date'] != null && tradeData['date'] != ''
                  ? textToDate(tradeData['date'])
                  : 'N/A'),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: FutureBuilder<String>(
              future: controller.gettradePaidCached(tradeId),
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
              future: controller.gettradeReceivedCached(tradeId),
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
              future: controller.gettradeNETsCached(tradeId),
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
        DataCell(tradeData['bought_from'] != null &&
                tradeData['bought_from'] != ''
            ? textForDataRowInTable(
                text: controller.getdataName(
                    tradeData['bought_from'], controller.allBuyersAndSellers))
            : SizedBox()),
        DataCell(tradeData['sold_to'] != null && tradeData['sold_to'] != ''
            ? textForDataRowInTable(
                text: controller.getdataName(
                    tradeData['sold_to'], controller.allBuyersAndSellers))
            : SizedBox()),
      ]);
}

Widget editSection(context, CarTradingController controller,
    Map<String, dynamic> tradeData, constraints, tradeId) {
  return GetX<CarTradingController>(builder: (controller) {
    bool isLoading = controller.buttonLoadingStates[tradeId] ?? false;

    return IconButton(
        onPressed: controller.buttonLoadingStates[tradeId] == null ||
                controller.buttonLoadingStates[tradeId] == false
            ? () async {
                controller.selectedTradeId.value = tradeId;
                controller.setButtonLoading(tradeId, true);
                controller.currentTradId.value = tradeId;
                await controller.loadValues(tradeData);
                controller.setButtonLoading(tradeId, false);

                tradesDialog(
                    tradeID: tradeId,
                    controller: controller,
                    canEdit: true,
                    onPressed: controller.addingNewValue.value
                        ? null
                        : () {
                            controller.editTrade(tradeId);
                          });
              }
            : null,
        icon: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.edit_note_rounded,
                color: Colors.blue,
              ));
  });
}

ElevatedButton newtradeesButton(
    BuildContext context, CarTradingController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      tradesDialog(
          tradeID: '',
          controller: controller,
          canEdit: true,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  controller.addNewTrade();
                });
    },
    style: newButtonStyle,
    child: const Text('New Trade'),
  );
}

ElevatedButton capitalButton(
    BuildContext context, CarTradingController controller) {
  return ElevatedButton(
    onPressed: controller.isCapitalLoading.isFalse
        ? () async {
            controller.searchForCapitals.value.clear();

            await controller.getAllCapitals();
            capitalOrOutstandingOrGeneralExpensesDialog(
              isGeneralExpenses: false,
              search: controller.searchForCapitals,
              collection: 'all_capitals',
              filteredMap: controller.filteredCapitals,
              map: controller.allCapitals,
              screenName: 'Capital',
              controller: controller,
              canEdit: true,
            );
          }
        : null,
    style: capitalButtonStyle,
    child: GetX<CarTradingController>(builder: (controller) {
      return controller.isCapitalLoading.isFalse
          ? const Text('Capital')
          : SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
    }),
  );
}

ElevatedButton outstandingButton(
    BuildContext context, CarTradingController controller) {
  return ElevatedButton(
    onPressed: controller.isOutstandinglLoading.isFalse
        ? () async {
            controller.searchForOutstanding.value.clear();

            await controller.getAllOutstanding();
            capitalOrOutstandingOrGeneralExpensesDialog(
              isGeneralExpenses: false,
              search: controller.searchForOutstanding,
              collection: 'all_outstanding',
              filteredMap: controller.filteredOutstanding,
              map: controller.allOutstanding,
              screenName: 'Outstanding',
              controller: controller,
              canEdit: true,
            );
          }
        : null,
    style: coutstandingButtonStyle,
    child: GetX<CarTradingController>(builder: (controller) {
      return controller.isOutstandinglLoading.isFalse
          ? const Text('Outstanding')
          : SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
    }),
  );
}

ElevatedButton generalExpensesButton(
    BuildContext context, CarTradingController controller) {
  return ElevatedButton(
    onPressed: controller.isgeneralExpenseslLoading.isFalse
        ? () async {
            controller.searchForGeneralexpenses.value.clear();
            await controller.getAllGeneralExpenses();
            capitalOrOutstandingOrGeneralExpensesDialog(
              isGeneralExpenses: true,
              search: controller.searchForGeneralexpenses,
              collection: 'all_general_expenses',
              filteredMap: controller.filteredGeneralExpenses,
              map: controller.allGeneralExpenses,
              screenName: 'General Expenses',
              controller: controller,
              canEdit: true,
            );
          }
        : null,
    style: cgeneralExpensesButtonStyle,
    child: GetX<CarTradingController>(builder: (controller) {
      return controller.isgeneralExpenseslLoading.isFalse
          ? const Text('General Expenses')
          : SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
    }),
  );
}

class TradeDataSource extends DataTableSource {
  final List<DocumentSnapshot> trades;
  final BuildContext context;
  final BoxConstraints constraints;
  final CarTradingController controller;

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
        tradeData, context, constraints, tradeId, controller, index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => trades.length;

  @override
  int get selectedRowCount =>
      0; //controller.selectedTradeId.value!.isEmpty ? 0 : 1;
}
