import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../Models/payroll/period_Details_model.dart';
import '../auto_size_box.dart';

Widget periodDetailsSection({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<PayrollController>(
      builder: (controller) {
        return tableOfScreens(
          constraints: constraints,
          controller: controller,
          context: context,
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required PayrollController controller,
  required BuildContext context,
}) {
  return DataTable2(
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    showBottomBorder: true,
    lmRatio: 2,
    columns: [
      DataColumn2(
        label: AutoSizedText(constraints: constraints, text: 'Period'),
        size: ColumnSize.L,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Start Date'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'End Date'),
      ),
    ],
    rows: controller.allPeriodDetails.map<DataRow>((invoiceItems) {
      return dataRowForTheTable(invoiceItems, constraints, controller, context);
    }).toList(),
  );
}

DataRow dataRowForTheTable(
  PeriodDetailsModel data,
  BoxConstraints constraints,
  PayrollController controller,
  BuildContext context,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.period ?? '',
          formatDouble: false,
          maxWidth: null,
          color: Colors.blueGrey,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.startDate),
          maxWidth: null,
          formatDouble: false,
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.endDate),
          maxWidth: null,
          formatDouble: false,
          color: Colors.red,
        ),
      ),
    ],
  );
}
