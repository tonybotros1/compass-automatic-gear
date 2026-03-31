import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Models/employees/employees_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/employees_widgets/employee_dialog.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
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
            child: Column(
              children: [
                GetBuilder<EmployeesController>(
                  init: EmployeesController(),
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                myTextFormFieldWithBorder(
                                  width: 90,
                                  labelText: 'Employee name',
                                  controller: controller.employeeNameFilter,
                                ),

                                MenuWithValues(
                                  labelText: 'Gender',
                                  headerLqabel: 'Genders',
                                  dialogWidth: constraints.maxWidth / 3,
                                  width: 170,
                                  controller: controller.genderFilter,
                                  displayKeys: const ['name'],
                                  displaySelectedKeys: const ['name'],
                                  onOpen: () {
                                    return controller.getGenders();
                                  },
                                  onDelete: () {
                                    controller.employeeNameFilterId.value = "";
                                    controller.employeeNameFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.employeeNameFilterId.value =
                                        value['_id'];
                                    controller.employeeNameFilter.text =
                                        value['name'];
                                  },
                                ),
                              ],
                            ),

                            // Row(
                            //   spacing: 10,
                            //   crossAxisAlignment: CrossAxisAlignment.end,
                            //   children: [
                            //     myTextFormFieldWithBorder(
                            //       width: 120,
                            //       controller: controller.fromDate.value,
                            //       labelText: 'From Date',
                            //       onFieldSubmitted: (_) async {
                            //         normalizeDate(
                            //           controller.fromDate.value.text,
                            //           controller.fromDate.value,
                            //         );
                            //       },
                            //       onTapOutside: (_) {
                            //         normalizeDate(
                            //           controller.fromDate.value.text,
                            //           controller.fromDate.value,
                            //         );
                            //       },
                            //     ),
                            //     myTextFormFieldWithBorder(
                            //       width: 120,
                            //       controller: controller.toDate.value,
                            //       labelText: 'To Date',
                            //       onFieldSubmitted: (_) async {
                            //         normalizeDate(
                            //           controller.toDate.value.text,
                            //           controller.toDate.value,
                            //         );
                            //       },
                            //       onTapOutside: (_) {
                            //         normalizeDate(
                            //           controller.toDate.value.text,
                            //           controller.toDate.value,
                            //         );
                            //       },
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GetBuilder<EmployeesController>(
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                newEmployeeButton(
                                  context,
                                  constraints,
                                  controller,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                CustomSlidingSegmentedControl<int>(
                                  height: 30,
                                  initialValue:
                                      controller.initStatusPickersValue.value,
                                  children: const {
                                    1: Text('ALL'),
                                    2: Text('ACTIVE'),
                                    3: Text('INACTIVE'),
                                  },
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.lightBackgroundGray,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  thumbDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(1),
                                        blurRadius: 4.0,
                                        spreadRadius: 1.0,
                                        offset: const Offset(0.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInToLinear,
                                  onValueChanged: (v) {
                                    // controller.onChooseForStatusPicker(v);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  style: findButtonStyle,
                                  onPressed: controller.isScreenLoding.isFalse
                                      ? () async {
                                          // controller.filterSearch();
                                        }
                                      : null,
                                  child: controller.isScreenLoding.isFalse
                                      ? Text(
                                          'Find',
                                          style: fontStyleForElevatedButtons,
                                        )
                                      : loadingProcess,
                                ),
                                ElevatedButton(
                                  style: clearVariablesButtonStyle,
                                  onPressed: () {
                                    // controller.clearAllFilters();
                                    // controller.update();
                                  },
                                  child: Text(
                                    'Clear',
                                    style: fontStyleForElevatedButtons,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetX<EmployeesController>(
                      builder: (controller) {
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
                ),
              ],
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
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    autoRowsToHeight: true,
    renderEmptyRowsInTheEnd: true,
    columns: [
      const DataColumn2(label: Text(''), size: ColumnSize.S),
      DataColumn2(
        label: AutoSizedText(text: 'Name', constraints: constraints),
        size: ColumnSize.M,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Number'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Job Title'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Hire Date'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'End Date'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Status'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: controller.filteredEmployees.isEmpty
          ? controller.allEmployees
          : controller.filteredEmployees,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  EmployeesModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  EmployeesController controller,
  int index,
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

class CardDataSourceForEmployees extends DataTableSource {
  final List<EmployeesModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final EmployeesController controller;

  CardDataSourceForEmployees({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final card = cards[index];
    final cardId = card.id ?? '';

    return dataRowForTheTable(
      card,
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
