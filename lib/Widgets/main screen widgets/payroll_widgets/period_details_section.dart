import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../Models/payroll/period_details_model.dart';
import '../auto_size_box.dart';
import 'period_dialog.dart';

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
    lmRatio: 3,
    columns: [
      const DataColumn2(label: SizedBox(), size: ColumnSize.S),
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
      DataColumn2(
        size: ColumnSize.S,
        label: AutoSizedText(constraints: constraints, text: 'Status'),
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
  final periodColor = _periodColorForYear(data, controller);

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(controller, data.id ?? '', context),
            editSection(controller, data, data.id ?? ''),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.period ?? '',
          formatDouble: false,
          maxWidth: null,
          color: periodColor,
          isBold: true,
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
      DataCell(statusBox(data.status ?? '')),
    ],
  );
}

Color _periodColorForYear(
  PeriodDetailsModel data,
  PayrollController controller,
) {
  final year =
      data.startDate?.year ??
      data.endDate?.year ??
      _yearFromPeriodName(data.period);

  if (year == null) return Colors.blueGrey;

  return controller.periodYearColors[year.abs() %
      controller.periodYearColors.length];
}

int? _yearFromPeriodName(String? periodName) {
  final match = RegExp(r'(?:19|20)\d{2}').firstMatch(periodName ?? '');
  final yearText = match?.group(0);

  return yearText == null ? null : int.tryParse(yearText);
}

IconButton editSection(
  PayrollController controller,
  PeriodDetailsModel data,
  String id,
) {
  return IconButton(
    onPressed: () async {
      controller.periodName.text = data.period ?? '';
      controller.periodStartDate.text = textToDate(data.startDate);
      controller.periodEndDate.text = textToDate(data.endDate);
      controller.isActiveSelected.value = data.status == 'Active'
          ? true
          : false;
      periodDialog(
        controller: controller,
        onPressed: () {
          controller.updatePayrollPeriod(id);
        },
        context: Get.context!,
      );
    },
    icon: editIcon,
  );
}

IconButton deleteSection(
  PayrollController controller,
  String id,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The document will be deleted permanently",
        onPressed: () async {
          final deleted = await controller.deletePayrollPeriod(id);
          Get.back();
          if (!deleted) {
            alertMessage(
              context: Get.context!,
              content: 'Could not delete period',
            );
          }
        },
      );
    },
    icon: deleteIcon,
  );
}
