import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/sales_man_controller.dart';
import '../../../../Models/salesman/salesman_model.dart';
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
                        onChanged: (_) {
                          controller.filterSalesMan();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterSalesMan();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for salesman',
                        button: newSalesManButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<SalesManController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allSalesMan.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreens(
                            constraints: constraints,
                            context: context,
                            controller: controller,
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required SalesManController controller,
}) {
  return PaginatedDataTable2(
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    autoRowsToHeight: true,
    columns: [
      DataColumn(
        label: AutoSizedText(text: 'Name', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Target'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSort,
      ),
      const DataColumn(label: Text('')),
    ],
    source: CardDataSourceForSalesman(
      cards:
          controller.filteredSalesMan.isEmpty &&
              controller.search.value.text.isEmpty
          ? controller.allSalesMan
          : controller.filteredSalesMan,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  SalesmanModel salemanData,
  BuildContext context,
  BoxConstraints constraints,
  String salemanId,
  SalesManController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(Text(salemanData.name.toString())),
      DataCell(
        textForDataRowInTable(
          text: salemanData.target.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(Text(textToDate(salemanData.createdAt))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: editSection(
                context,
                controller,
                salemanData,
                constraints,
                salemanId,
              ),
            ),
            deleteSection(controller, salemanId, context),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton deleteSection(
  SalesManController controller,
  variableId,
  context,
) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: "The sale man will be deleted permanently",
        onPressed: () {
          controller.deleteSaleman(variableId);
        },
      );
    },
    child: const Text("Delete"),
  );
}

ElevatedButton editSection(
  BuildContext context,
  SalesManController controller,
  SalesmanModel salemanData,
  BoxConstraints constraints,
  String salemanId,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () {
      controller.name.text = salemanData.name.toString();
      controller.target.text = salemanData.target.toString();
      saleManDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.editSaleMan(salemanId);
              },
      );
    },
    child: const Text('Edit'),
  );
}

ElevatedButton newSalesManButton(
  BuildContext context,
  BoxConstraints constraints,
  SalesManController controller,
) {
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
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Salesman'),
  );
}

class CardDataSourceForSalesman extends DataTableSource {
  final List<SalesmanModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final SalesManController controller;

  CardDataSourceForSalesman({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final jobCard = cards[index];
    final cardId = jobCard.id;

    return dataRowForTheTable(
      jobCard,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
