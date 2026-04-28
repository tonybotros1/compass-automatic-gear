import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../../Models/payroll runs/payroll_runs_details_model.dart';
import '../auto_size_box.dart';

Widget informationTableSection({required BoxConstraints constraints}) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
    child: GetX<PayrollRunsController>(
      builder: (controller) {
        return tableOfScreens(constraints: constraints, controller: controller);
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
        label: AutoSizedText(constraints: constraints, text: 'Number'),
      ),
      DataColumn2(
        numeric: true,
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Value'),
      ),
    ],
    rows: controller.payrollRunsEmployeeElementsInformationList.map<DataRow>((
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
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.number.toString(),
          maxWidth: null,
          formatDouble: true,
          color: Colors.blue,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.information.toString(),
          maxWidth: null,
          formatDouble: true,
          color: Colors.green,
        ),
      ),
    ],
  );
}
