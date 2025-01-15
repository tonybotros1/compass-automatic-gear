import 'package:compass_automatic_gear/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts.dart';
import '../Auth screens widgets/register widgets/search_bar.dart';
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
              buttonTitle: 'New Value',
              // button: newListButton(context, constraints, controller),
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
      rows: [
        DataRow(cells: [
          DataCell(
            TextField(
              decoration: InputDecoration(hintText: "Enter value 1"),
              onChanged: (newValue1) {
                controller.listName.text =
                    newValue1; // Update the controller or variable
              },
            ),
          ),
          DataCell(
            TextField(
              decoration: InputDecoration(hintText: "Enter value 2"),
              onChanged: (newValue2) {
                controller.code.text =
                    newValue2; // Update the controller or variable
              },
            ),
          ),
          DataCell(
            TextField(
              decoration: InputDecoration(hintText: "Enter value 2"),
              onChanged: (newValue2) {
                controller.code.text =
                    newValue2; // Update the controller or variable
              },
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (controller.listName.text.isNotEmpty &&
                    controller.code.text.isNotEmpty) {
                  // Add new values to the list
                  final newEntry = {
                    'value1': controller.listName.text,
                    'value2': controller.code.text,
                  };
                  // controller.addNewValue(newEntry);
                }
              },
            ),
          ),
        ]),
        ...controller.filteredValues.isEmpty &&
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
      ]);
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
