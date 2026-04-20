import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/employees/employee_leaves_model.dart';
import '../../../../consts.dart';
import '../../../Auth screens widgets/register widgets/search_bar.dart';
import 'leaves_inserting_dialog.dart';

Widget leavesScreen({
  required EmployeesController controller,
  required BoxConstraints constraints,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        children: [
          GetBuilder<EmployeesController>(
            builder: (controller) {
              return searchBar(
                onChanged: (value) {
                  controller.filterEmployeeLeaves(value);
                },
                onPressedForClearSearch: () {
                  controller.leavesSearch.value.clear();
                  controller.filterEmployeeLeaves('');
                },
                search: controller.leavesSearch,
                constraints: constraints,
                context: context,
                title: 'Search for leaves',
                button: newLeaveButton(context, constraints, controller),
              );
            },
          ),
          Expanded(
            child: GetX<EmployeesController>(
              builder: (controller) {
                final query = controller.leavesSearchQuery.value;
                final cards =
                    (query.isEmpty
                            ? controller.leavesList
                            : controller.filteredLeavesList)
                        .toList();

                return PaginatedDataTable2(
                  key: ValueKey('$query-${cards.length}'),
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey.shade200, width: 0.5),
                  ),
                  smRatio: 0.67,
                  lmRatio: 3,
                  autoRowsToHeight: true,
                  showCheckboxColumn: false,
                  headingRowHeight: 60,
                  columnSpacing: 5,
                  showFirstLastButtons: true,
                  horizontalMargin: 5,
                  dataRowHeight: 40,
                  columns: const [
                    DataColumn2(size: ColumnSize.S, label: SizedBox()),
                    DataColumn2(size: ColumnSize.M, label: Text('Leave Type')),
                    DataColumn2(size: ColumnSize.M, label: Text('Status')),
                    DataColumn2(size: ColumnSize.M, label: Text('Start Date')),
                    DataColumn2(size: ColumnSize.M, label: Text('End Date')),
                    DataColumn2(
                      size: ColumnSize.S,
                      label: Text('Number of Days'),
                    ),
                    DataColumn2(size: ColumnSize.L, label: Text('Note')),
                  ],
                  source: CardDataSource(
                    cards: cards,
                    controller: controller,
                    context: context,
                    constraints: constraints,
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

DataRow dataRowForTheTable(
  EmployeeLeavesModel data,
  BuildContext context,
  String id,
  EmployeesController controller,
  int index,
  BoxConstraints constraints,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow2(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return !isEvenRow ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(controller, id),
            editSection(controller, context, constraints, id, data),
          ],
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: data.leaveTypeName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(statusBox(data.status ?? '')),

      DataCell(
        textForDataRowInTable(
          text: textToDate(data.startDate),
          maxWidth: null,
          formatDouble: false,
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.endDate),
          maxWidth: null,
          formatDouble: false,
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.numberOdDays.toString(),
          maxWidth: null,
          formatDouble: false,
          color: Colors.orange,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.note ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

IconButton deleteSection(EmployeesController controller, String id) {
  return IconButton(
    onPressed: () async {
      String leaveStatus = await controller.getCurrentEmployeeLeaveStatus(id);
      if (leaveStatus != 'New') {
        alertMessage(
          context: Get.context!,
          content: 'Only new jobs can be deleted',
        );
        return;
      }
      alertDialog(
        context: Get.context!,
        content: "The leave will be deleted permanently",
        onPressed: () async {
          Get.back();
          controller.deleteEmployeeLeave(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  EmployeesController controller,
  BuildContext context,
  BoxConstraints constraints,
  String leaveId,
  EmployeeLeavesModel data,
) {
  return IconButton(
    onPressed: () {
      controller.employeeLeaveType.text = data.leaveTypeName ?? '';
      controller.employeeLeaveTypeId.value = data.leaveType ?? '';
      controller.employeeLeaveStatus.value = data.status ?? '';
      controller.employeeLeaveStartTime.text = textToDate(data.startDate);
      controller.employeeLeaveEndTime.text = textToDate(data.endDate);
      controller.employeeLeaveNumberOfDays.text = data.numberOdDays.toString();
      controller.employeeLeaveNote.text = data.note ?? '';
      controller.employeeLeavePayInAdvance.value = data.payInAdvance ?? false;

      leavesInsertingDialog(
        onPressedForPost: () async {
          String leaveStatus = await controller.getCurrentEmployeeLeaveStatus(
            data.id ?? '',
          );
          if (leaveStatus == 'Posted') {
            alertMessage(
              context: Get.context!,
              content: 'Status is already posted',
            );
            return;
          } else if (leaveStatus == 'Cancelled') {
            alertMessage(context: Get.context!, content: 'Status is cancelled');
            return;
          } else {
            controller.employeeLeaveStatus.value = "Posted";
            controller.updateEmployeeLeave(leaveId);
          }
        },
        onPressedForCancel: () async {
          String leaveStatus = await controller.getCurrentEmployeeLeaveStatus(
            leaveId,
          );
          if (leaveStatus == 'Posted') {
            alertMessage(context: Get.context!, content: 'Status is posted');
            return;
          } else if (leaveStatus == 'Cancelled') {
            alertMessage(
              context: Get.context!,
              content: 'Status is already cancelled',
            );
            return;
          } else {
            controller.employeeLeaveStatus.value = "Cancelled";
            controller.updateEmployeeLeave(leaveId);
          }
        },
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewLeaveValue.isTrue
            ? null
            : () async {
                await controller.updateEmployeeLeave(leaveId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newLeaveButton(
  BuildContext context,
  BoxConstraints constraints,
  EmployeesController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.employeeLeaveType.clear();
      controller.employeeLeaveTypeId.value = '';
      controller.employeeLeaveStatus.value = '';
      controller.employeeLeaveStartTime.clear();
      controller.employeeLeaveEndTime.clear();
      controller.employeeLeaveNumberOfDays.clear();
      controller.employeeLeaveNote.clear();
      controller.employeeLeavePayInAdvance.value = false;

      leavesInsertingDialog(
        onPressedForCancel: null,
        onPressedForPost: null,
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewContactAndRelativesValue.isTrue
            ? null
            : () async {
                await controller.addNewEmployeeLeave();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Record'),
  );
}

class CardDataSource extends DataTableSource {
  final List<EmployeeLeavesModel> cards;
  final BuildContext context;
  final EmployeesController controller;
  final BoxConstraints constraints;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.controller,
    required this.constraints,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final data = cards[index];
    final cardId = data.id ?? '';

    return dataRowForTheTable(
      data,
      context,
      cardId,
      controller,
      index,
      constraints,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
