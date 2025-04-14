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
  return DataTable(
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
        label: AutoSizedText(
          text: 'Code',
          constraints: constraints,
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Name',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
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
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> tradeData, context, constraints,
    tradeId, CarTradingController controller) {
  return DataRow(cells: [
    DataCell(Text(
      tradeData['code'] ?? 'no code',
    )),
    DataCell(
      Text(
        tradeData['name'] ?? 'no name',
      ),
    ),
    DataCell(
      Text(
        tradeData['added_date'] != null && tradeData['added_date'] != ''
            ? textToDate(tradeData['added_date']) //
            : 'N/A',
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
              // controller.deletetrade(tradeId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, CarTradingController controller,
    Map<String, dynamic> tradeData, constraints, tradeId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        // controller.city.text = (await controller.getCityName(
        //     tradeData['country_id'], tradeData['city_id']))!;
        // controller.getCitiesByCountryID(tradeData['country_id']);
        // controller.code.text = tradeData['code'] ?? '';
        // controller.name.text = tradeData['name'] ?? '';
        // controller.line.text = tradeData['line'] ?? '';
        // controller.country.text =
        //     controller.getCountryName(tradeData['country_id'])!;

        // controller.countryId.value = tradeData['country_id'];
        // controller.cityId.value = tradeData['city_id'];
        // tradeesDialog(
        //     constraints: constraints,
        //     controller: controller,
        //     canEdit: true,
        //     onPressed: controller.addingNewValue.value
        //         ? null
        //         : () {
        //             controller.edittrade(tradeId);
        //           });
      },
      child: const Text('Edit'));
}

ElevatedButton newtradeesButton(
    BuildContext context, CarTradingController controller) {
  return ElevatedButton(
    onPressed: () {
      // controller.allCities.clear();
      // controller.code.clear();
      // controller.name.clear();
      // controller.line.clear();
      // controller.country.clear();
      // controller.countryId.value = '';
      // controller.city.clear();
      // controller.cityId.value = '';
      tradesDialog(
          controller: controller,
          canEdit: true,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  // await controller.addNewtrade();
                });
    },
    style: newButtonStyle,
    child: const Text('New Trade'),
  );
}
