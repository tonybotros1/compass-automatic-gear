import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_performance_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/employee performance/employee_performance.dart';
import '../../../consts.dart';

Future<dynamic> infosDialog({
  required BoxConstraints constraints,
  required EmployeesPerformanceController controller,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: constraints.maxWidth,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: mainColor,
              ),
              child: Row(
                spacing: 10,
                children: [
                  Text(
                    controller.getScreenName(),
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  closeButton,
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GetX<EmployeesPerformanceController>(
                  builder: (controller) {
                    if (controller.isScreenLoadingForEmployeeTasks.value) {
                      return Center(child: loadingProcess);
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: tableOfScreens(
                          constraints: constraints,
                          controller: controller,
                          employeeSheets: controller.filteredPerformancesInfos,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required EmployeesPerformanceController controller,
  required List<CompletedSheetsInfos> employeeSheets,
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
    // showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 1.5),
        label: AutoSizedText(text: 'Car', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 2),
        label: AutoSizedText(constraints: constraints, text: 'Task'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 2),
        label: AutoSizedText(constraints: constraints, text: 'Start Date'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 2),
        label: AutoSizedText(constraints: constraints, text: 'End Date'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        numeric: true,
        columnWidth: const IntrinsicColumnWidth(flex: 1),

        label: AutoSizedText(constraints: constraints, text: 'Minutes'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        numeric: true,
        columnWidth: const IntrinsicColumnWidth(flex: 1),

        label: AutoSizedText(constraints: constraints, text: 'Points'),
        // onSort: controller.onSort,
      ),
    ],
    rows: List.generate(employeeSheets.length, (i) {
      final sheet = employeeSheets[i];
      final sheetId = sheet.id ?? '';
      final isEven = i % 2 == 0;

      return dataRowForTheTable(
        sheet,
        constraints,
        sheetId,
        controller,
        isEven,
      );
    }),
  );
}

DataRow dataRowForTheTable(
  CompletedSheetsInfos sheetData,
  BoxConstraints constraints,
  String sheetId,
  EmployeesPerformanceController controller,
  bool isEven,
) {
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      return isEven ? Colors.white : Colors.grey.shade200;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: '${sheetData.brandName} ${sheetData.modelName}',
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          maxWidth: null,
          text: '${sheetData.nameEn} - ${sheetData.nameAr}',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          maxWidth: null,
          text: textToDate(sheetData.startDate,withTime: true),
          color: const Color(0xffBE5B50),
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          maxWidth: null,
          text: textToDate(sheetData.endDate,withTime: true),
          color: const Color(0xff73946B),
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          isBold: true,
          color: Colors.blueGrey,
          text: '${sheetData.minutes} mins, ${sheetData.seconds} sec',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          isBold: true,
          color: Colors.orange,
          text: sheetData.points.toString(),
        ),
      ),
    ],
  );
}
