import 'package:compass_automatic_gear/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts.dart';
import '../Auth screens widgets/register widgets/search_bar.dart';
import 'add_or_edit_new_list.dart';
import 'auto_size_box.dart';

Widget valuesSection({
  required BoxConstraints constraints,
  required ListOfValuesController controller,
  required BuildContext context,
}) {
  return Container(
    width: constraints.maxWidth,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        GetX<ListOfValuesController>(
          init: ListOfValuesController(),
          builder: (controller) {
            return searchBar(
              constraints: constraints,
              context: context,
              controller: controller,
              title: 'Search for values',
              button: newListButton(context, constraints, controller),
            );
          },
        ),
        Expanded(
          child: GetX<ListOfValuesController>(
            builder: (controller) {
              if (controller.loadingValues.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.allValues.isEmpty) {
                return const Center(
                  child: Text('No Element'),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
  );
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required ListOfValuesController controller}) {
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
          text: 'Code',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Name',
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
    rows: controller.filteredValues.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allValues.map<DataRow>((value) {
            final valueData = value.data() as Map<String, dynamic>;
            final valueId = value.id;
            return dataRowForTheTable(
                valueData, context, constraints, valueId, controller);
          }).toList()
        : controller.filteredValues.map<DataRow>((value) {
            final valueData = value.data() as Map<String, dynamic>;
            final valueId = value.id;
            return dataRowForTheTable(
                valueData, context, constraints, valueId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> listData, context, constraints, listId, controller) {
  return DataRow(cells: [
    DataCell(Text(
      listData['code'] ?? 'no code',
    )),
    DataCell(
      Text(
        listData['name'] ?? 'no value',
      ),
    ),
    DataCell(
      Text(
        listData['added_date'] != null
            ? controller.textToDate(listData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: editButtonStyle,
            onPressed: () {},
            child: const Text('Edit')),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: ElevatedButton(
              style: deleteButtonStyle,
              onPressed: () {},
              child: const Text('Delete')),
        ),
      ],
    )),
  ]);
}

ElevatedButton newListButton(
    BuildContext context, BoxConstraints constraints, controller) {
  return ElevatedButton(
    onPressed: () {
      controller.listName.clear();
      controller.code.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewListOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<ListOfValuesController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewListProcess.value
                                ? null
                                : () async {
                                    if (!controller
                                        .formKeyForAddingNewList.currentState!
                                        .validate()) {
                                    } else {
                                      await controller.addNewList();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child:
                                controller.addingNewListProcess.value == false
                                    ? const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const SizedBox(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: controller.addingNewListProcess.value == false
                      ? const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New List'),
  );
}
