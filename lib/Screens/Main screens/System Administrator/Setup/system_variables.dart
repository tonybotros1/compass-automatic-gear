import 'package:datahubai/Models/system%20variables/system_variables_model.dart';
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
                        onChanged: (_) {
                          controller.filterVariables();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterVariables();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for variables',
                        button: newValueButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<SystemVariablesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allVariables.isEmpty) {
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
            ),
          );
        },
      ),
    );
  }
}

ElevatedButton newValueButton(
  BuildContext context,
  BoxConstraints constraints,
  SystemVariablesController controller,
) {
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
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Variable'),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required SystemVariablesController controller,
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
        label: AutoSizedText(text: 'Code', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Value'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSort,
      ),
      const DataColumn(label: Text('')),
    ],
    rows:
        controller.filteredVariables.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allVariables.map<DataRow>((variable) {
            final variableId = variable.id ?? '';
            return dataRowForTheTable(
              variable,
              context,
              constraints,
              variableId,
              controller,
            );
          }).toList()
        : controller.filteredVariables.map<DataRow>((variable) {
            final variableId = variable.id ?? '';
            return dataRowForTheTable(
              variable,
              context,
              constraints,
              variableId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  SystemVariablesModel variableData,
  BuildContext context,
  BoxConstraints constraints,
  String variableId,
  SystemVariablesController controller,
) {
  return DataRow(
    cells: [
      DataCell(Text(variableData.code.toString())),
      DataCell(Text(variableData.value.toString())),
      DataCell(Text(textToDate(variableData.createdAt))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: editSection(
                context,
                controller,
                variableData,
                constraints,
                variableId,
              ),
            ),
            deleteSection(controller, variableId, context),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton deleteSection(
  SystemVariablesController controller,
  String variableId,
  BuildContext context,
) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: "The list will be deleted permanently",
        onPressed: () {
          controller.deleteVariable(variableId);
        },
      );
    },
    child: const Text("Delete"),
  );
}

ElevatedButton editSection(
  BuildContext context,
  SystemVariablesController controller,
  SystemVariablesModel variableData,
  BoxConstraints constraints,
  String variableId,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () {
      controller.code.text = variableData.code ?? '';
      controller.value.text = variableData.value ?? '';
      systemVariablesDialog(
        canEdit: false,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.updateVariable(variableId);
              },
      );
    },
    child: const Text('Edit'),
  );
}
