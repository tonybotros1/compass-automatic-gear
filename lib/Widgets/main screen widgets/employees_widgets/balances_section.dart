import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../Models/employees/employee_assignments_balances_model.dart';
import '../auto_size_box.dart';

Widget balancesSection(BoxConstraints constraints) {
  return Container(
    decoration: containerDecor,
    child: GetX<EmployeesController>(
      builder: (controller) {
        return tableOfScreens(constraints: constraints, controller: controller);
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required EmployeesController controller,
}) {
  return SizedBox(
    // width: constraints.maxWidth - 17,
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      lmRatio: 2,
      columns: [
        DataColumn2(
          label: AutoSizedText(constraints: constraints, text: 'Blance Name'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Blance Dimension',
          ),
          size: ColumnSize.M,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Value'),
          numeric: true,
        ),
      ],
      rows: controller.balancesList.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(invoiceItems, constraints, controller);
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  EmployeeAssignmentsBalancesModel data,
  BoxConstraints constraints,
  EmployeesController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(text: data.name.toString(), formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.dimension.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade100,
          ),
          child: textForDataRowInTable(
            text: data.balance?.toString() ?? '0',
            maxWidth: null,
            formatDouble: true,
            color: data.balance == 0
                ? Colors.grey
                : data.balance! > 0
                ? Colors.green
                : Colors.red,
          ),
        ),
      ),
    ],
  );
}
