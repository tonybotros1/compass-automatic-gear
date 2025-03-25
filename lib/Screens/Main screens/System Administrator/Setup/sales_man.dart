import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/sales_man_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/sales_man_widgets/sale_man_dialog.dart';
import '../../../../consts.dart';

class SalesMan extends StatelessWidget {
  const SalesMan({super.key});

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
                  GetX<SalesManController>(
                    init: SalesManController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for sales man',
                        button:
                            newSalesManButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<SalesManController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allSalesMan.isEmpty) {
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
    required SalesManController controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    horizontalMargin: horizontalMarginForTable,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(
          text: 'Name',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Target',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSort,
      ),
      const DataColumn(label: Text('')),
    ],
    rows: controller.filteredSalesMan.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allSalesMan.map<DataRow>((saleman) {
            final salemanData = saleman.data() as Map<String, dynamic>;
            final salemanId = saleman.id;
            return dataRowForTheTable(
                salemanData, context, constraints, salemanId, controller);
          }).toList()
        : controller.filteredSalesMan.map<DataRow>((saleman) {
            final salemanData = saleman.data() as Map<String, dynamic>;
            final salemanId = saleman.id;
            return dataRowForTheTable(
                salemanData, context, constraints, salemanId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> salemanData, context,
    constraints, salemanId, SalesManController controller) {
  return DataRow(cells: [
    DataCell(Text(
      salemanData['name'] ?? 'no name',
    )),
    DataCell(
      Text(
        '${salemanData['target']}',
      ),
    ),
    DataCell(
      Text(
        salemanData['added_date'] != null && salemanData['added_date'] != ''
            ? textToDate(salemanData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: editSection(
              context, controller, salemanData, constraints, salemanId),
        ),
        deleteSection(controller, salemanId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    SalesManController controller, variableId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The sale man will be deleted permanently",
            onPressed: () {
              controller.deleteSaleman(variableId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, SalesManController controller,
    Map<String, dynamic> salemanData, constraints, salemanId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.name.text = salemanData['name'] ?? '';
        controller.target.text = (salemanData['target'] ?? '').toString();
        saleManDialog(
            constraints: constraints,
            controller: controller,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editSaleMan(salemanId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newSalesManButton(BuildContext context,
    BoxConstraints constraints, SalesManController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.target.clear();
      saleManDialog(
          constraints: constraints,
          controller: controller,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  await controller.addNewSaleMan();
                });
    },
    style: newButtonStyle,
    child: const Text('New Sale Man'),
  );
}
