import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/job_tasks_controller.dart';
import 'package:datahubai/Models/job%20tasks/job_tasks_model.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/job_tasks_widgets/task_dialog.dart';

class JobTasks extends StatelessWidget {
  const JobTasks({super.key});

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
                  GetX<JobTasksController>(
                    init: JobTasksController(),
                    builder: (controller) {
                      return searchBar(
                        onChanged: (_) {
                          controller.filterTasks();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterTasks();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for tasks',
                        button: newtaskesButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<JobTasksController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allTasks.isEmpty) {
                          return const Center(child: Text('No Elements'));
                        }
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
  required JobTasksController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    autoRowsToHeight: true,
    columns: [
      const DataColumn2(size: ColumnSize.S, label: Text('')),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'Name - EN', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'Name - AR', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Points'),
        // onSort: controller.onSort,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Category'),
        // onSort: controller.onSort,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        // onSort: controller.onSort,
      ),
    ],
    source: CardDataSourceForEmployees(
      cards:
          controller.filteredTasks.isEmpty &&
              controller.search.value.text.isEmpty
          ? controller.allTasks
          : controller.filteredTasks,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  JobTasksModel taskData,
  BuildContext context,
  BoxConstraints constraints,
  String taskId,
  JobTasksController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          children: [
            deleteSection(controller, taskId, context),
            editSection(context, controller, taskData, constraints, taskId),
          ],
        ),
      ),
      DataCell(Text(taskData.nameEN ?? '')),
      DataCell(Text(taskData.nameAR ?? '')),
      DataCell(Text(taskData.points.toString())),
      DataCell(Text(taskData.category ?? '')),
      DataCell(Text(textToDate(taskData.createdAt))),
    ],
  );
}

IconButton deleteSection(JobTasksController controller, taskId, context) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The task will be deleted permanently",
        onPressed: () {
          controller.deleteTask(taskId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  JobTasksController controller,
  JobTasksModel taskData,
  BoxConstraints constraints,
  String taskId,
) {
  return IconButton(
    onPressed: () async {
      controller.nameAR.text = taskData.nameAR ?? '';
      controller.nameEN.text = taskData.nameEN ?? '';
      controller.points.text = taskData.points.toString();
      controller.category.text = taskData.category ?? '';
      taskDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.editTask(taskId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newtaskesButton(
  BuildContext context,
  BoxConstraints constraints,
  JobTasksController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.nameAR.clear();
      controller.nameEN.clear();
      controller.points.clear();
      controller.category.clear();

      taskDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
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

class CardDataSourceForEmployees extends DataTableSource {
  final List<JobTasksModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final JobTasksController controller;

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
    final cardId = card.id;

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
