import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/sales_man_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/add_new_saleman_or_edit.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
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
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
            content: "The list will be deleted permanently",
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
        showDialog(
            context: context,
            builder: (context) {
              controller.name.text = salemanData['name'] ?? '';
              controller.target.text = (salemanData['target'] ?? '').toString();

              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewSaleManOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  name: controller.name,
                  target: controller.target,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: controller.addingNewValue.value
                          ? null
                          : () {
                              controller.editSaleMan(salemanId);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: controller.addingNewValue.value == false
                          ? const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: cancelButtonStyle,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              );
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
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewSaleManOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<SalesManController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewValue.value
                                ? null
                                : () async {
                                    await controller.addNewSaleMan();
                                  },
                            style: saveButtonStyle,
                            child: controller.addingNewValue.value == false
                                ? const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                          ),
                        )),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: cancelButtonStyle,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New Sale Man'),
  );
}
