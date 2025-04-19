import 'package:datahubai/Widgets/Trade%20screen%20widgets/trade_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Trading Controllers/car_trading_controller.dart';
import '../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../consts.dart';

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
                            return searchBar(
                              search: controller.search,
                              constraints: constraints,
                              context: context,
                              controller: controller,
                              title: 'Search for Trades',
                              button: newtradeesButton(context, controller),
                            );
                          },
                        ),
                        Expanded(
                          child: GetX<CarTradingController>(
                            builder: (controller) {
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
                                scrollDirection: Axis
                                    .vertical, // Horizontal scrolling for the table
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
                    return Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total Paid:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        textForDataRowInTable(
                            text: '${controller.totalPaysForAllTrades.value}',
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
                            text: '${controller.totalNETsForAllTrades.value}',
                            color: Colors.blueGrey,
                            isBold: true)
                      ],
                    );
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

Widget tableOfScreens(
    {required constraints,
    required context,
    required CarTradingController controller}) {
  return DataTableTheme(
    data: DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300; 
        }
        return null; 
      }),
    ),
    child: DataTable(
      showCheckboxColumn: false,
      horizontalMargin: horizontalMarginForTable,
      dataRowMaxHeight: 40,
      dataRowMinHeight: 30,
      columnSpacing: 5,
      showBottomBorder: true,
      dataTextStyle: regTextStyle,
      headingTextStyle: fontStyleForTableHeader,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
      columns: [
        DataColumn(
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              AutoSizedText(
                text: 'Car',
                constraints: constraints,
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Year',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Status',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Specification',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Color',
              ),
              AutoSizedText(
                constraints: constraints,
                text: 'Outside',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Inside',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Engine Size',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Mileage',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Date',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Paid',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Received',
              ),
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
              AutoSizedText(
                constraints: constraints,
                text: 'Net',
              ),
            ],
          ),
          // onSort: controller.onSort,
        ),
        const DataColumn(
          label: Text(''),
        ),
      ],
      rows: controller.filteredTrades.isEmpty &&
              controller.search.value.text.isEmpty
          ? controller.allTrades.map<DataRow>((trade) {
              final tradeData = trade.data() as Map<String, dynamic>;
              final tradeId = trade.id;
              return dataRowForTheTable(
                  tradeData, context, constraints, tradeId, controller);
            }).toList()
          : controller.filteredTrades.map<DataRow>((trade) {
              final tradeData = trade.data() as Map<String, dynamic>;
              final tradeId = trade.id;
              return dataRowForTheTable(
                  tradeData, context, constraints, tradeId, controller);
            }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> tradeData, context, constraints,
    tradeId, CarTradingController controller) {
  final isSelected = controller.selectedTradeId.value == tradeId;
  return DataRow(
      selected: isSelected,
      onSelectChanged: (selected) {
        if (selected != null && selected) {
          controller.selectedTradeId.value = tradeId;
        } else {
          controller.selectedTradeId.value = '';
        }
      },
      cells: [
        DataCell(
          Builder(builder: (_) {
            final data = tradeData;
            final brand =
                controller.getdataName(data['car_brand'], controller.allBrands);
            final model = controller.getCachedCarModelName(
              data['car_brand'],
              data['car_model'],
            );
            final display = model.isNotEmpty ? '$brand $model' : 'Loading...';

            return textForDataRowInTable(text: display, maxWidth: null);
          }),
        ),
        DataCell(Text(
            controller.getdataName(tradeData['year'], controller.allYears))),
        DataCell(tradeData['status'] != ''
            ? statusBox('${tradeData['status']}', hieght: 35, width: 100)
            : const SizedBox()),
        DataCell(Text(controller.getdataName(
            tradeData['specification'], controller.allCarSpecifications))),
        DataCell(Text(controller.getdataName(
            tradeData['color_out'], controller.allColors))),
        DataCell(Text(controller.getdataName(
            tradeData['color_in'], controller.allColors))),
        DataCell(Text(controller.getdataName(
            tradeData['engine_size'], controller.allEngineSizes))),
        DataCell(
          Text(tradeData['mileage']),
        ),
        DataCell(
          Text(
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
            tradeData['date'] != null && tradeData['date'] != ''
                ? textToDate(tradeData['date'])
                : 'N/A',
          ),
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
        DataCell(Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            editSection(context, controller, tradeData, constraints, tradeId),
            deleteSection(controller, tradeId, context),
          ],
        )),
      ]);
}

ElevatedButton deleteSection(
    CarTradingController controller, tradeId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The trade will be deleted permanently",
            onPressed: () {
              controller.deleteTrade(tradeId);
            });
      },
      child: const Text("Delete"));
}

Widget editSection(context, CarTradingController controller,
    Map<String, dynamic> tradeData, constraints, tradeId) {
  return GetX<CarTradingController>(builder: (controller) {
    bool isLoading = controller.buttonLoadingStates[tradeId] ?? false;

    return ElevatedButton(
        style: editButtonStyle,
        onPressed: controller.buttonLoadingStates[tradeId] == null ||
                controller.buttonLoadingStates[tradeId] == false
            ? () async {
                controller.selectedTradeId.value = tradeId;
                controller.setButtonLoading(tradeId, true);
                controller.currentTradId.value = tradeId;
                await controller.loadValues(tradeData);
                controller.setButtonLoading(tradeId, false);

                tradesDialog(
                    controller: controller,
                    canEdit: true,
                    onPressed: controller.addingNewValue.value
                        ? null
                        : () {
                            controller.editTrade(tradeId);
                          });
              }
            : null,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Edit')

        //  const Text('Edit')

        );
  });
}

ElevatedButton newtradeesButton(
    BuildContext context, CarTradingController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      tradesDialog(
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
