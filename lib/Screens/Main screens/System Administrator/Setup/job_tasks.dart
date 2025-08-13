import 'package:datahubai/Controllers/Main%20screen%20controllers/job_tasks_controller.dart';
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
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for tasks',
                        button:
                            newtaskesButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<JobTasksController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allTasks.isEmpty) {
                          return const Center(
                            child: Text('No Elements'),
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
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required JobTasksController controller}) {
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
      DataColumn(
        label: AutoSizedText(
          text: 'Name - EN',
          constraints: constraints,
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          text: 'Name - AR',
          constraints: constraints,
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Points',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Category',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        // onSort: controller.onSort,
      ),
      const DataColumn(
        label: Text(''),
      ),
    ],
    rows:
        controller.filteredTasks.isEmpty && controller.search.value.text.isEmpty
            ? controller.allTasks.map<DataRow>((task) {
                final taskData = task.data() as Map<String, dynamic>;
                final taskId = task.id;
                return dataRowForTheTable(
                    taskData, context, constraints, taskId, controller);
              }).toList()
            : controller.filteredTasks.map<DataRow>((task) {
                final taskData = task.data() as Map<String, dynamic>;
                final taskId = task.id;
                return dataRowForTheTable(
                    taskData, context, constraints, taskId, controller);
              }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> taskData, context, constraints,
    taskId, JobTasksController controller) {
  return DataRow(cells: [
    DataCell(Text(
      taskData['name_en'] ?? '',
    )),
    DataCell(Text(
      taskData['name_ar'] ?? '',
    )),
    DataCell(
      Text(
        taskData['points'] ?? '',
      ),
    ),
    DataCell(
      Text(
        taskData['category'] ?? '',
      ),
    ),
    DataCell(
      Text(
        taskData['added_date'] != null && taskData['added_date'] != ''
            ? textToDate(taskData['added_date'])
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        editSection(context, controller, taskData, constraints, taskId),
        deleteSection(controller, taskId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(JobTasksController controller, taskId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            content: "The task will be deleted permanently",
            onPressed: () {
              controller.deleteTask(taskId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, JobTasksController controller,
    Map<String, dynamic> taskData, constraints, taskId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        controller.nameAR.text = taskData['name_ar'];
        controller.nameEN.text = taskData['name_en'];
        controller.points.text = taskData['points'];
        controller.category.text = taskData['category'];
        taskDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editTask(taskId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newtaskesButton(BuildContext context, BoxConstraints constraints,
    JobTasksController controller) {
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
                });
    },
    style: newButtonStyle,
    child: const Text('New Task'),
  );
}
