import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Models/employee_performance_model.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/employees_performance_controller.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/employee_performance_widgets/employee_information.dart';
import '../../../../consts.dart';

class EmployeePerformance extends StatelessWidget {
  const EmployeePerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: screenPadding,
          child: Column(
            spacing: 10,
            children: [
              GetX<EmployeesPerformanceController>(
                  init: EmployeesPerformanceController(),
                  builder: (controller) {
                    bool isYearsLoading = controller.allYears.isEmpty;
                    bool isMonthsLoading = controller.allMonths.isEmpty;
                    bool isDaysLoading = controller.allDays.isEmpty;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: controller.dropDownWidth,
                          child: CustomDropdown(
                            hintText: 'Year',
                            textcontroller: controller.year.value.text,
                            showedSelectedName: 'name',
                            items: isYearsLoading ? {} : controller.allYears,
                            onChanged: (key, value) {
                              controller.year.text = value['name'];
                              controller.month.clear();
                              controller.day.clear();
                              controller.allDays.clear();
                              // controller.isYearSelected.value = true;
                              // controller.isMonthSelected.value = false;
                              // controller.isDaySelected.value = false;
                              controller.filterTimeSheets();
                            },
                          ),
                        ),
                        SizedBox(
                          width: controller.dropDownWidth,
                          child: CustomDropdown(
                            hintText: 'Month',
                            textcontroller: controller.month.text,
                            showedSelectedName: 'name',
                            items: isMonthsLoading ? {} : controller.allMonths,
                            onChanged: (key, value) {
                              controller.allDays
                                  .assignAll(getDaysInMonth(value['name']));
                              controller.month.text = value['name'];
                              controller.day.clear();
                              // controller.isMonthSelected.value = true;
                              // controller.isYearSelected.value = false;
                              // controller.isDaySelected.value = false;
                              controller.filterTimeSheets();
                            },
                          ),
                        ),
                        SizedBox(
                          width: controller.dropDownWidth,
                          child: CustomDropdown(
                            hintText: 'Day',
                            textcontroller: controller.day.text,
                            showedSelectedName: 'name',
                            items: isDaysLoading ? {} : controller.allDays,
                            onChanged: (key, value) {
                              controller.day.text = value['name'];
                              controller.filterTimeSheets();
                              // controller.isMonthSelected.value = false;
                              // controller.isYearSelected.value = false;
                              // controller.isDaySelected.value = true;
                            },
                          ),
                        ),
                        ElevatedButton(
                            style: allButtonStyle,
                            onPressed: () {
                              controller.filterTimeSheets(preset: 'all');
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              controller.year.clear();
                              controller.month.clear();
                              controller.day.clear();
                              controller.allDays.clear();
                            },
                            child: Text('All')),
                        ElevatedButton(
                            style: todayButtonStyle,
                            onPressed: controller.isTodaySelected.isFalse
                                ? () {
                                    controller.filterTimeSheets(
                                        preset: 'today');
                                    controller.isTodaySelected.value = true;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value = false;
                                    // controller.isYearSelected.value = false;
                                    // controller.isMonthSelected.value = false;
                                    // controller.isDaySelected.value = true;
                                  }
                                : null,
                            child: Text('Today')),
                        ElevatedButton(
                            style: thisMonthButtonStyle,
                            onPressed: controller.isThisMonthSelected.isFalse
                                ? () {
                                    controller.filterTimeSheets(
                                        preset: 'thisMonth');
                                    controller.isTodaySelected.value = false;
                                    controller.isThisMonthSelected.value = true;
                                    controller.isThisYearSelected.value = false;
                                    // controller.isYearSelected.value = false;
                                    // controller.isMonthSelected.value = true;
                                    // controller.isDaySelected.value = false;
                                  }
                                : null,
                            child: Text('This Month')),
                        ElevatedButton(
                            style: thisYearButtonStyle,
                            onPressed: controller.isThisYearSelected.isFalse
                                ? () {
                                    controller.filterTimeSheets(
                                        preset: 'thisYear');
                                    controller.isTodaySelected.value = false;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value = true;
                                    // controller.isYearSelected.value = true;
                                    // controller.isMonthSelected.value = false;
                                    // controller.isDaySelected.value = false;
                                  }
                                : null,
                            child: Text('This Year')),
                      ],
                    );
                  }),
              Expanded(
                child: GetX<EmployeesPerformanceController>(
                  builder: (controller) {
                    if (controller.isScreenLoadingForTimesheets.value) {
                      return Center(child: loadingProcess);
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: tableOfScreens(
                          constraints: constraints,
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
      }),
    );
  }
}

Widget tableOfScreens(
    {required constraints,
    required EmployeesPerformanceController controller}) {
  return DataTable(
      clipBehavior: Clip.hardEdge,
      border: TableBorder.all(
          style: BorderStyle.none,
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5)),
      dataRowMaxHeight: 40,
      dataRowMinHeight: 30,
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      // showBottomBorder: true,
      dataTextStyle: regTextStyle,
      headingTextStyle: fontStyleForTableHeader,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
      columns: [
        DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 0.2), label: SizedBox()),
        DataColumn(
          columnWidth: IntrinsicColumnWidth(flex: 2),

          label: AutoSizedText(
            text: 'Employee',
            constraints: constraints,
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          numeric: true,
          columnWidth: IntrinsicColumnWidth(flex: 1),

          label: AutoSizedText(
            constraints: constraints,
            text: 'Minutes',
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          numeric: true,
          columnWidth: IntrinsicColumnWidth(flex: 1),

          label: AutoSizedText(
            constraints: constraints,
            text: 'Points',
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          numeric: true,
          columnWidth: IntrinsicColumnWidth(flex: 1),

          label: AutoSizedText(
            constraints: constraints,
            text: 'Tasks',
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          numeric: true,
          columnWidth: IntrinsicColumnWidth(flex: 1),
          label: AutoSizedText(
            constraints: constraints,
            text: 'AMT',
          ),
          // onSort: controller.onSort,
        ),
      ],
      rows: List.generate(controller.allTechnician.length, (i) {
        final task = controller.allTechnician[i];
        final taskData = task.data() as Map<String, dynamic>;
        final taskId = task.id;
        final isEven = i % 2 == 0;
        final name = taskData['name'] ?? '';
        final mins = controller.getEmployeeMins(taskId);
        final tasks = controller.getEmployeeTasks(taskId);
        final employeeSheets = controller.getEmployeeSheets(taskId);
        final points = controller.employeePointsMap[taskId] ?? 0;
        final model = EmployeePerformanceModel(
          employeeName: name,
          mins: mins,
          points: points,
          tasks: tasks,
        );
        return dataRowForTheTable(taskData, constraints, taskId, controller,
            isEven, model, employeeSheets);
      }));
}

DataRow dataRowForTheTable(
    Map<String, dynamic> taskData,
    constraints,
    taskId,
    EmployeesPerformanceController controller,
    bool isEven,
    EmployeePerformanceModel model,
    List<DocumentSnapshot<Object?>> employeeSheets) {
  return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (!isEven) {
            return Colors.grey.shade200;
          }
          return Colors.white; // Normal row color
        },
      ),
      cells: [
        DataCell(infosSection(controller, constraints, employeeSheets)),
        DataCell((Text(model.employeeName.toString()))),
        DataCell(textForDataRowInTable(
            formatDouble: false,
            text: model.mins.toString(),
            color: Colors.red,
            isBold: true)),
        DataCell(textForDataRowInTable(
            formatDouble: false,
            text: model.points.toString(),
            color: Colors.green,
            isBold: true)),
        DataCell(
          textForDataRowInTable(
              formatDouble: false,
              isBold: true,
              color: Colors.blueGrey,
              text: model.tasks.toString()),
        ),
        DataCell(textForDataRowInTable(
            text: controller.totalsForJobs.value.toString(),
            formatDouble: false,
            isBold: true,
            color: Colors.orange)),
      ]);
}

IconButton infosSection(EmployeesPerformanceController controller, constraints,
    List<DocumentSnapshot<Object?>> employeeSheets) {
  return IconButton(
      onPressed: () {
        controller.getSheetTasksAndPoints(employeeSheets);
        controller.getSheetsCar(employeeSheets);
        infosDialog(
            constraints: constraints,
            controller: controller,
            employeeSheets: employeeSheets);
      },
      icon: const Icon(
        Icons.list_alt,
        color: Colors.blueAccent,
      ));
}
