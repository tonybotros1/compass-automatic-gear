import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/system_variables_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/system_variables_widgets/system_variables_dialog.dart';
import '../../../../consts.dart';

class SystemVariables extends StatelessWidget {
  const SystemVariables({super.key});

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
                  GetX<SystemVariablesController>(
                    init: SystemVariablesController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        // controller: controller,
                        title: 'Search for variables',
                        button:
                            newValueButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<SystemVariablesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allVariables.isEmpty) {
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

ElevatedButton newValueButton(BuildContext context, BoxConstraints constraints,
    SystemVariablesController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.code.clear();
      controller.value.clear();
      systemVariablesDialog(
          canEdit: true,
          constraints: constraints,
          controller: controller,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  await controller.addNewVariable();
                });
    },
    style: newButtonStyle,
    child: const Text('New Variable'),
  );
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required SystemVariablesController controller}) {
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
        label: AutoSizedText(
          text: 'Code',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Value',
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
    rows: controller.filteredVariables.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allVariables.map<DataRow>((variable) {
            final variableData = variable.data() as Map<String, dynamic>;
            final variableId = variable.id;
            return dataRowForTheTable(
                variableData, context, constraints, variableId, controller);
          }).toList()
        : controller.filteredVariables.map<DataRow>((variable) {
            final variableData = variable.data() as Map<String, dynamic>;
            final variableId = variable.id;
            return dataRowForTheTable(
                variableData, context, constraints, variableId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> variableData, context,
    constraints, variableId, SystemVariablesController controller) {
  return DataRow(cells: [
    DataCell(Text(
      variableData['code'] ?? 'no code',
    )),
    DataCell(
      Text(
        variableData['value'] ?? 'no value',
      ),
    ),
    DataCell(
      Text(
        variableData['added_date'] != null && variableData['added_date'] != ''
            ? textToDate(variableData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: editSection(
              context, controller, variableData, constraints, variableId),
        ),
        deleteSection(controller, variableId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    SystemVariablesController controller, variableId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The list will be deleted permanently",
            onPressed: () {
              controller.deleteVariable(variableId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, SystemVariablesController controller,
    Map<String, dynamic> variableData, BoxConstraints constraints, variableId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.code.text = variableData['code'] ?? '';
        controller.value.text = variableData['value'] ?? '';
        systemVariablesDialog(
            canEdit: false,
            constraints: constraints,
            controller: controller,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editVariable(variableId);
                  });
      },
      child: const Text('Edit'));
}
