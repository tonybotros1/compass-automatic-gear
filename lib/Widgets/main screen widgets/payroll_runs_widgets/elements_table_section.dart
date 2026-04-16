import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../../Models/payroll runs/payroll_runs_details_model.dart';
import '../auto_size_box.dart';

Widget elementsTableSection({required BoxConstraints constraints}) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
    child: GetX<PayrollRunsController>(
      builder: (controller) {
        return tableOfScreens(
          constraints: constraints,
          controller: controller,
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
        label: AutoSizedText(constraints: constraints, text: 'Element Name'),
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
    ],
    rows: controller.payrollRunsEmployeeElementsList.map<DataRow>((
      invoiceItems,
    ) {
      return dataRowForTheTable(invoiceItems, constraints, controller);
    }).toList(),
  );
}

DataRow dataRowForTheTable(
  PayrollRunsEmployeeElementsModel data,
  BoxConstraints constraints,
  PayrollRunsController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.elementName ?? '',
          formatDouble: false,
          maxWidth: null
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.payment.toString(),
          maxWidth: null,
          formatDouble: true,
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.deduction.toString(),
          maxWidth: null,
          formatDouble: true,
          color: Colors.red,
        ),
      ),
    ],
  );
}
