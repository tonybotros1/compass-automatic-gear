import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/list_of_values/value_model.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';
import 'values_dialog.dart';

Widget valuesSection({
  required BoxConstraints constraints,
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
              onChanged: (_) {
                controller.filterValues();
              },
              onPressedForClearSearch: () {
                controller.searchForValues.value.clear();
                controller.filterValues();
              },
              search: controller.searchForValues,
              constraints: constraints,
              context: context,
              title: 'Search for values',
              button: newValueButton(context, constraints, controller),
            );
          },
        ),
        Expanded(
          child: GetX<ListOfValuesController>(
            builder: (controller) {
              if (controller.loadingValues.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.allValues.isEmpty) {
                return const Center(child: Text('No Element'));
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required ListOfValuesController controller,
}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Name'),
        onSort: controller.onSortForValues,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Parent (Value)'),
        onSort: controller.onSortForValues,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSortForValues,
      ),
      const DataColumn(label: Text('')),
    ],
    rows:
        controller.filteredValues.isEmpty &&
            controller.searchForValues.value.text.isEmpty
        ? controller.allValues.map<DataRow>((value) {
            final valueId = value.id;
            return dataRowForTheTable(
              value,
              context,
              constraints,
              valueId,
              controller,
            );
          }).toList()
        : controller.filteredValues.map<DataRow>((value) {
            final valueId = value.id;
            return dataRowForTheTable(
              value,
              context,
              constraints,
              valueId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  ValueModel valueData,
  context,
  constraints,
  String valueId,
  ListOfValuesController controller,
) {
  return DataRow(
    cells: [
      DataCell(Text(valueData.name)),
      DataCell(Text(valueData.masteredBy)),
      DataCell(Text(textToDate(valueData.createdAt))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // activeInActiveSection(valueData, controller, valueId),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: editSection(
                controller,
                valueData,
                context,
                constraints,
                valueId,
              ),
            ),
            deleteSection(context, controller, valueId),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton deleteSection(
  BuildContext context,
  ListOfValuesController controller,
  valueId,
) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: 'The value will be deleted permanently',
        onPressed: () {
          controller.deleteValue(valueId);
        },
      );
    },
    child: const Text('Delete'),
  );
}

ElevatedButton editSection(
  ListOfValuesController controller,
  ValueModel valueData,
  context,
  constraints,
  String valueId,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () {
      controller.valueName.text = valueData.name;
      controller.masteredBy.text = valueData.masteredBy;
      controller.masteredByIdForValues.value = '';
      valuesDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewListValue.value
            ? null
            : () async {
                if (!controller.formKeyForAddingNewList.currentState!
                    .validate()) {
                } else {
                  controller.editValue(valueId);
                }
              },
      );
    },
    child: const Text('Edit'),
  );
}

// ElevatedButton activeInActiveSection(
//   ValueModel valueData,
//   ListOfValuesController controller,
//   String valueId,
// ) {
//   return ElevatedButton(
//     style: valueData.status == false ? inActiveButtonStyle : activeButtonStyle,
//     onPressed: () {
//       bool status;
//       if (valueData.status == false) {
//         status = true;
//       } else {
//         status = false;
//       }
//       controller.editHideOrUnhide(
//         controller.listIDToWorkWithNewValue.value,
//         valueId,
//         status,
//       );
//     },
//     child: valueData.status == true
//         ? const Text('Active')
//         : const Text('Inactive'),
//   );
// }

ElevatedButton newValueButton(
  BuildContext context,
  BoxConstraints constraints,
  ListOfValuesController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.valueName.clear();
      controller.masteredBy.clear();
      valuesDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewListValue.value
            ? null
            : () async {
                if (!controller.formKeyForAddingNewList.currentState!
                    .validate()) {
                } else {
                  await controller.addNewValue(
                    controller.listIDToWorkWithNewValue.value,
                  );
                }
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Value'),
  );
}
