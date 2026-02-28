import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/to_do_list_controller.dart';
import '../../../../Models/to do list/to_do_list_model.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/to_do_list_widgets/details_section.dart';
import '../../../../Widgets/main screen widgets/to_do_list_widgets/to_do_list_dialog.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({super.key});

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
                GetX<ToDoListController>(
                  init: ToDoListController(),

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
                                  width: 120,
                                  labelText: 'Number',
                                  controller: controller.numberFilter,
                                ),
                                myTextFormFieldWithBorder(
                                  width: 120,
                                  labelText: 'Date',
                                  controller: controller.dateFilter,
                                  onFieldSubmitted: (_) async {
                                    normalizeDate(
                                      controller.dateFilter.text,
                                      controller.dateFilter,
                                    );
                                  },
                                  onTapOutside: (_) {
                                    normalizeDate(
                                      controller.dateFilter.text,
                                      controller.dateFilter,
                                    );
                                  },
                                ),
                                myTextFormFieldWithBorder(
                                  width: 120,
                                  labelText: 'Due Date',
                                  controller: controller.dueDateFilter,
                                  onFieldSubmitted: (_) async {
                                    normalizeDate(
                                      controller.dueDateFilter.text,
                                      controller.dueDateFilter,
                                    );
                                  },
                                  onTapOutside: (_) {
                                    normalizeDate(
                                      controller.dueDateFilter.text,
                                      controller.dueDateFilter,
                                    );
                                  },
                                ),

                                MenuWithValues(
                                  labelText: 'Created By',
                                  headerLqabel: 'Users',
                                  dialogWidth: constraints.maxWidth / 3,
                                  width: 200,
                                  controller: controller.createdByFilter,
                                  displayKeys: const ['user_name'],
                                  displaySelectedKeys: const ['user_name'],
                                  onOpen: () {
                                    return controller.getSysUsersForLOV();
                                  },
                                  onDelete: () {
                                    controller.createdByFilterId.value = "";
                                    controller.createdByFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.createdByFilterId.value =
                                        value['_id'];
                                    controller.createdByFilter.text =
                                        value['name'];
                                  },
                                ),
                                MenuWithValues(
                                  labelText: 'Assigned To',
                                  headerLqabel: 'Employees',
                                  dialogWidth: constraints.maxWidth / 3,
                                  width: 200,
                                  controller: controller.assignedToFilter,
                                  displayKeys: const ['user_name'],
                                  displaySelectedKeys: const ['user_name'],
                                  onOpen: () {
                                    return controller.getSysUsersForLOV();
                                  },
                                  onDelete: () {
                                    controller.assignedToFilterId.value = "";
                                    controller.assignedToFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.assignedToFilterId.value =
                                        value['_id'];
                                    controller.assignedToFilter.text =
                                        value['name'];
                                  },
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                myTextFormFieldWithBorder(
                                  width: 120,
                                  controller: controller.fromDate.value,
                                  labelText: 'From Date',
                                  onFieldSubmitted: (_) async {
                                    normalizeDate(
                                      controller.fromDate.value.text,
                                      controller.fromDate.value,
                                    );
                                  },
                                  onTapOutside: (_) {
                                    normalizeDate(
                                      controller.fromDate.value.text,
                                      controller.fromDate.value,
                                    );
                                  },
                                ),
                                myTextFormFieldWithBorder(
                                  width: 120,
                                  controller: controller.toDate.value,
                                  labelText: 'To Date',
                                  onFieldSubmitted: (_) async {
                                    normalizeDate(
                                      controller.toDate.value.text,
                                      controller.toDate.value,
                                    );
                                  },
                                  onTapOutside: (_) {
                                    normalizeDate(
                                      controller.toDate.value.text,
                                      controller.toDate.value,
                                    );
                                  },
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
                GetX<ToDoListController>(
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
                                newTaskButton(context, constraints, controller),
                                const SizedBox(width: 20),
                                closeTaskButton(
                                  context,
                                  constraints,
                                  controller,
                                ),
                                cancelTaskTaskButton(
                                  context,
                                  constraints,
                                  controller,
                                ),
                                reOpenTaskButton(
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
                                      controller.initDatePickerValue.value,
                                  children: const {
                                    1: Text('ALL'),
                                    2: Text('TODAY'),
                                    3: Text('THIS MONTH'),
                                    4: Text('THIS YEAR'),
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
                                    controller.onChooseForDatePicker(v);
                                  },
                                ),
                                separator(color: Colors.black),
                                CustomSlidingSegmentedControl<int>(
                                  height: 30,
                                  initialValue:
                                      controller.initStatusPickersValue.value,
                                  children: const {
                                    1: Text('ALL'),
                                    2: Text('OPEN'),
                                    3: Text('CLOSED'),
                                    4: Text('CANCELLED'),
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
                                    controller.onChooseForStatusPicker(v);
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
                                          controller.filterSearch();
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
                                    controller.clearAllFilters();
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
                  child: Row(
                    spacing: 2,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                            ),
                          ),
                          width: constraints.maxWidth,
                          child: GetX<ToDoListController>(
                            builder: (controller) {
                              return tableOfScreens(
                                constraints: constraints,
                                context: context,
                                controller: controller,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: GetBuilder<ToDoListController>(
                          builder: (controller) {
                            return detailsSection(controller, constraints);
                          },
                        ),
                      ),
                    ],
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
  required ToDoListController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    autoRowsToHeight: true,
    minWidth: 1000,
    showCheckboxColumn: false,
    lmRatio: 2.5,
    headingRowHeight: 50,
    columns: [
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'Number', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Date'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Due Date'),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Created By'),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Assigned To'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Status'),
      ),
      const DataColumn2(size: ColumnSize.S, label: SizedBox()),
    ],
    source: CardDataSourceForToDoList(
      cards: controller.allToDoLists.isEmpty ? [] : controller.allToDoLists,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  ToDoListModel data,
  BuildContext context,
  BoxConstraints constraints,
  String toDoListId,
  ToDoListController controller,
  int index,
) {
  // final bool isSelected = controller.selectedRowIndex.value == index;
  return DataRow(
    selected: controller.selectedRowIndex.value == index,
    onSelectChanged: (selected) async {
      controller.currentTaskId.value = toDoListId;
      controller.selectRow(index);
      await controller.getTaskDescriptions(toDoListId);
      await controller.markTaskAsRead(toDoListId);
      int i = controller.allToDoLists.indexWhere((t)=> t.id == toDoListId);
      controller.allToDoLists[i].unreadNotes = 0;
      controller.allToDoLists.refresh();
    },
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow.shade200;
      }
      return index.isOdd ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(textForDataRowInTable(text: data.number ?? '')),
      DataCell(textForDataRowInTable(text: textToDate(data.date))),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: BoxBorder.all(color: Colors.green),
            borderRadius: BorderRadius.circular(2),
          ),
          child: textForDataRowInTable(
            text: textToDate(data.dueDate),
            color: isBeforeToday(data.dueDate.toString())
                ? Colors.orange
                : Colors.green,
          ),
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.createdBy ?? '', maxWidth: null),
      ),
      DataCell(
        textForDataRowInTable(text: data.assignedTo ?? '', maxWidth: null),
      ),
      DataCell(statusBox(data.status ?? '', hieght: 35)),
      DataCell(
        data.unreadNotes! > 0
            ? Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  data.unreadNotes! > 99 ? '99+' : '${data.unreadNotes}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            : const SizedBox(),
      ),
    ],
  );
}

ElevatedButton newTaskButton(
  BuildContext context,
  BoxConstraints constraints,
  ToDoListController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.number.clear();
      controller.date.text = textToDate(DateTime.now());
      controller.dueDate.text = textToDate(DateTime.now());
      controller.createdBy.text =
          controller.companyDetails['current_user_name'] ?? '';
      controller.createdById.value =
          controller.companyDetails['current_user_id'];
      controller.assignedTo.clear();
      controller.assignedToId.value = '';
      controller.status.clear();
      controller.description.clear();
      toDoListDialog(
        constraints: constraints,
        controller: controller,
        context: context,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                await controller.addNewTask();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Task'),
  );
}

ElevatedButton closeTaskButton(
  BuildContext context,
  BoxConstraints constraints,
  ToDoListController controller,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentTaskId.value.isEmpty) {
        alertMessage(context: context, content: 'Select task first');
        return;
      }
      alertDialog(
        context: context,
        content: 'Are you sure you want to close this task?',
        onPressed: () {
          controller.updateTaskStatus(controller.currentTaskId.value, 'Closed');
          Get.back();
        },
      );
    },
    style: closeTaskButtonStyle,
    child: const Text('Close Task'),
  );
}

ElevatedButton cancelTaskTaskButton(
  BuildContext context,
  BoxConstraints constraints,
  ToDoListController controller,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentTaskId.value.isEmpty) {
        alertMessage(context: Get.context!, content: 'Select task first');
        return;
      }
      alertDialog(
        context: context,
        content: 'Are you sure you want to Cancel this task?',
        onPressed: () {
          controller.updateTaskStatus(
            controller.currentTaskId.value,
            'Cancelled',
          );
          Get.back();
        },
      );
    },
    style: deleteButtonStyle,
    child: const Text('Cancel Task'),
  );
}

ElevatedButton reOpenTaskButton(
  BuildContext context,
  BoxConstraints constraints,
  ToDoListController controller,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentTaskId.value.isEmpty) {
        alertMessage(context: Get.context!, content: 'Select task first');
        return;
      }
      alertDialog(
        context: context,
        content: 'Are you sure you want to reopen this task?',
        onPressed: () {
          controller.updateTaskStatus(controller.currentTaskId.value, 'Open');
          Get.back();
        },
      );
    },
    style: innvoiceItemsButtonStyle,
    child: const Text('Reopen Task'),
  );
}

class CardDataSourceForToDoList extends DataTableSource {
  final List<ToDoListModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final ToDoListController controller;

  CardDataSourceForToDoList({
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
