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
  required JobTasksController controller,
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
        label: AutoSizedText(text: 'Name - EN', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(text: 'Name - AR', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Points'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Category'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        // onSort: controller.onSort,
      ),
    ],
    rows:
        controller.filteredTasks.isEmpty && controller.search.value.text.isEmpty
        ? controller.allTasks.map<DataRow>((task) {
            final taskId = task.id;
            return dataRowForTheTable(
              task,
              context,
              constraints,
              taskId,
              controller,
            );
          }).toList()
        : controller.filteredTasks.map<DataRow>((task) {
            final taskId = task.id;
            return dataRowForTheTable(
              task,
              context,
              constraints,
              taskId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  JobTasksModel taskData,
  context,
  constraints,
  taskId,
  JobTasksController controller,
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
