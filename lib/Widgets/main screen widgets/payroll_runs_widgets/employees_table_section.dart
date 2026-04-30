import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../../Models/payroll runs/payroll_runs_details_model.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';

Widget employeeTableSection({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
    child: GetX<PayrollRunsController>(
      builder: (controller) {
        return Column(
          children: [
            searchBar(
              onChanged: (_) {
                controller.filterPayrollEmployees();
              },
              onPressedForClearSearch: () {
                controller.employeeSearch.value.clear();
                controller.filterPayrollEmployees();
              },
              search: controller.employeeSearch,
              constraints: constraints,
              context: context,
              title: 'Search for employees',
            ),
            Expanded(
              child: tableOfScreens(
                constraints: constraints,
                controller: controller,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required PayrollRunsController controller,
}) {
  return DataTable2(
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    showBottomBorder: true,
    lmRatio: 2,
    columns: [
      DataColumn2(
        label: AutoSizedText(constraints: constraints, text: 'Employee Name'),
        size: ColumnSize.L,
      ),
      DataColumn2(
        numeric: true,
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Payment'),
      ),
      DataColumn2(
        numeric: true,
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Deduction'),
      ),
      DataColumn2(
        numeric: true,
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Net'),
      ),
    ],
    rows:
        controller.filteredPayrollRunsEmployeeList.isEmpty &&
            controller.employeeSearch.value.text.isEmpty
        ? controller.payrollRunsEmployeeList.map<DataRow>((doc) {
            return dataRowForTheTable(doc, constraints, controller);
          }).toList()
        : controller.filteredPayrollRunsEmployeeList.map<DataRow>((doc) {
            return dataRowForTheTable(doc, constraints, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  PayrollRunsEmployeeModel data,
  BoxConstraints constraints,
  PayrollRunsController controller,
) {
  return DataRow2(
    onTap: () {
      controller.filteredPayrollRunsEmployeeElementsList.clear();
      controller.payrollRunsEmployeeElementsList.assignAll(
        data.runEmployeeDetails ?? [],
      );
      controller.payrollRunsEmployeeElementsInformationList.assignAll(
        data.runEmployeeInformation ?? [],
      );
    },
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.employeeName ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalPayments.toString(),
          maxWidth: null,
          formatDouble: true,
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalDeductions.toString(),
          maxWidth: null,
          formatDouble: true,
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.netSalary.toString(),
          maxWidth: null,
          formatDouble: true,
          color: Colors.blue,
        ),
      ),
    ],
  );
}
