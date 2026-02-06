import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Models/job cards/time_sheets_summary_for_job_card.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Widget timeSheetsSummaryTable({
  required BuildContext context,
  required BoxConstraints constraints,
  required jobId,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<JobCardController>(
      builder: (controller) {
        if (controller.loadingTimeSheetsSummary.value &&
            controller.timeSheetsSummaryTable.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return tableOfScreens(
          constraints: constraints,
          context: context,
          controller: controller,
          jobId: jobId,
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  required String jobId,
}) {
  double totalHours = controller.calculateTotalHoursForTimeSheetsSummary();

  return SizedBox(
    width: constraints.maxWidth - 17,
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      columns: [
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'Task'),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'Name'),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'Start Date'),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'End Date'),
        ),
        DataColumn(
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'Hours'),
        ),
      ],
      rows: [
        ...controller.timeSheetsSummaryTable.map<DataRow>((invoiceItems) {
          return dataRowForTheTable(
            invoiceItems,
            context,
            constraints,
            controller,
            jobId,
          );
        }),
        DataRow(
          selected: true,
          cells: [
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('Totals')),
            DataCell(
              textForDataRowInTable(text: '$totalHours', color: Colors.red),
            ),
          ],
        ),
      ],
    ),
  );
}

DataRow dataRowForTheTable(
  TimeSheetsSummaryForJobCard invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  JobCardController controller,
  String jobId,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text:
              '${invoiceItemsData.taskNameEn ?? ''} (${invoiceItemsData.taskNameAr ?? ''})',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.employeeName ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(invoiceItemsData.startDate, withTime: true),
          color: Colors.green,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(invoiceItemsData.endDate, withTime: true),
          color: Colors.blueGrey,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.timeInHours.toString(),
          color: Colors.red,
        ),
      ),
    ],
  );
}
