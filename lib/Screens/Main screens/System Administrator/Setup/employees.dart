import 'package:datahubai/Models/employees/employees_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/employees_widgets/employee_dialog.dart';
import '../../../../consts.dart';

class Employees extends StatelessWidget {
  const Employees({super.key});

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
                  GetX<EmployeesController>(
                    init: EmployeesController(),
                    builder: (controller) {
                      return searchBar(
                        onChanged: (_) {
                          controller.filterEmployees();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterEmployees();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for employees',
                        button: newEmployeeButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<EmployeesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allEmployees.isEmpty) {
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required EmployeesController controller,
}) {
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
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Name', constraints: constraints),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Number'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Job Title'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Hire Date'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'End Date'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Status'),
      ),
    ],
    rows:
        controller.filteredEmployees.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allEmployees.map<DataRow>((data) {
            final employeeId = data.id ?? '';
            return dataRowForTheTable(
              data,
              context,
              constraints,
              employeeId,
              controller,
            );
          }).toList()
        : controller.filteredEmployees.map<DataRow>((data) {
            final employeeId = data.id ?? '';
            return dataRowForTheTable(
              data,
              context,
              constraints,
              employeeId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  EmployeesModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  EmployeesController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, employeeId, context),
            editSection(context, controller, data, constraints, employeeId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(textForDataRowInTable(text: data.employeeNumber ?? '')),
      DataCell(textForDataRowInTable(text: data.jobTitle ?? '')),
      DataCell(textForDataRowInTable(text: textToDate(data.hireDate))),
      DataCell(textForDataRowInTable(text: textToDate(data.endDate))),
      DataCell(
        textForDataRowInTable(
          isBold: true,
          text: data.statusType ?? '',
          color: data.statusType == "Active"
              ? Colors.green
              : data.statusType == "Inactive"
              ? Colors.red
              : data.statusType == "Probation"
              ? Colors.teal
              : Colors.brown,
        ),
      ),
    ],
  );
}

IconButton deleteSection(
  EmployeesController controller,
  String employeeId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The technicians will be deleted permanently",
        onPressed: () {
          controller.deleteEmployee(employeeId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  EmployeesController controller,
  EmployeesModel data,
  BoxConstraints constraints,
  String employeeId,
) {
  return IconButton(
    onPressed: () async {
      controller.loadValues(data);
      employeeDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.updateEmployee(employeeId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newEmployeeButton(
  BuildContext context,
  BoxConstraints constraints,
  EmployeesController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();

      employeeDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                await controller.addNewEmployee();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Employee'),
  );
}
