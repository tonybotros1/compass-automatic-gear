import 'package:datahubai/Models/employee%20performance/employee_performance.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Column(
              spacing: 10,
              children: [
                GetX<EmployeesPerformanceController>(
                  init: EmployeesPerformanceController(),
                  builder: (controller) {
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
                            onChanged: (key, value) {
                              controller.year.text = value['name'];
                              controller.month.clear();
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              controller.filterSearch();
                            },
                            onDelete: () {
                              controller.year.clear();
                              controller.month.clear();
                            },
                            onOpen: () {
                              return controller.getAllYears();
                            },
                          ),
                        ),
                        SizedBox(
                          width: controller.dropDownWidth,
                          child: CustomDropdown(
                            hintText: 'Month',
                            textcontroller: controller.month.text,
                            showedSelectedName: 'name',
                            onChanged: (key, value) {
                              controller.month.text = value['name'];
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              controller.filterSearch();
                            },
                            onDelete: () {
                              controller.month.clear();
                            },
                            onOpen: () {
                              return controller.getAllMonths();
                            },
                          ),
                        ),

                        // ElevatedButton(
                        //   style: allButtonStyle,
                        //   onPressed: () {
                        //     controller.filterTimeSheets(preset: 'all');
                        //     controller.isTodaySelected.value = false;
                        //     controller.isThisMonthSelected.value = false;
                        //     controller.isThisYearSelected.value = false;
                        //     controller.year.clear();
                        //     controller.month.clear();
                        //   },
                        //   child: const Text('All'),
                        // ),
                        ElevatedButton(
                          style: thisMonthButtonStyle,
                          onPressed: controller.isThisMonthSelected.isFalse
                              ? () {
                                 
                                  controller.isThisMonthSelected.value = true;
                                  controller.isThisYearSelected.value = false;
                                  controller.filterSearch();
                                }
                              : null,
                          child: const Text('This Month'),
                        ),
                        ElevatedButton(
                          style: thisYearButtonStyle,
                          onPressed: controller.isThisYearSelected.isFalse
                              ? () {
                                  
                                  controller.isThisMonthSelected.value = false;
                                  controller.isThisYearSelected.value = true;
                                  controller.filterSearch();
                                }
                              : null,
                          child: const Text('This Year'),
                        ),
                      ],
                    );
                  },
                ),
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
        },
      ),
    );
  }
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required EmployeesPerformanceController controller,
}) {
  return DataTable(
    clipBehavior: Clip.hardEdge,
    border: TableBorder.all(
      style: BorderStyle.none,
      color: Colors.grey,
      borderRadius: BorderRadius.circular(5),
    ),
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      const DataColumn(
        columnWidth: IntrinsicColumnWidth(flex: 0.2),
        label: SizedBox(),
      ),
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 2),
        label: AutoSizedText(text: 'Employee', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn(
        // numeric: true,
        columnWidth: const IntrinsicColumnWidth(flex: 1),

        label: AutoSizedText(constraints: constraints, text: 'Duration'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        numeric: true,
        columnWidth: const IntrinsicColumnWidth(flex: 1),

        label: AutoSizedText(constraints: constraints, text: 'Points'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        numeric: true,
        columnWidth: const IntrinsicColumnWidth(flex: 1),

        label: AutoSizedText(constraints: constraints, text: 'Tasks'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        numeric: true,
        columnWidth: const IntrinsicColumnWidth(flex: 1),
        label: AutoSizedText(constraints: constraints, text: 'Amount'),
        // onSort: controller.onSort,
      ),
    ],
    rows: List.generate(controller.filteredPerformances.length, (i) {
      EmployeePerformanceModel data = controller.filteredPerformances[i];
      bool isEven = i % 2 == 0;

      return dataRowForTheTable(
        data,
        constraints,
        data.id ?? '',
        controller,
        isEven,
      );
    }),
  );
}

DataRow dataRowForTheTable(
  EmployeePerformanceModel data,
  BoxConstraints constraints,
  String taskId,
  EmployeesPerformanceController controller,
  bool isEven,
) {
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (!isEven) {
        return Colors.grey.shade200;
      }
      return Colors.white; // Normal row color
    }),
    cells: [
      DataCell(
        infosSection(controller, constraints, data.completedSheetsInfos ?? []),
      ),
      DataCell(
        (textForDataRowInTable(text: data.name ?? '', formatDouble: false)),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: data.timeString ?? '',
          color: Colors.red,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: data.points.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          isBold: true,
          color: Colors.blueGrey,
          text: data.totalTasks.toString(),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.amt.toString(),
          isBold: true,
          color: Colors.orange,
        ),
      ),
    ],
  );
}

IconButton infosSection(
  EmployeesPerformanceController controller,
  BoxConstraints constraints,
  List<CompletedSheetsInfos> employeeSheets,
) {
  return IconButton(
    onPressed: () {
      controller.filteredPerformancesInfos.assignAll(employeeSheets);
      infosDialog(constraints: constraints, controller: controller);
    },
    icon: const Icon(Icons.list_alt, color: Colors.blueAccent),
  );
}
