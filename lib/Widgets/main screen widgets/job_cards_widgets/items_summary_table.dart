import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Models/job cards/job_items_summary_table.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Widget itemsSummartTableSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required jobId,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<JobCardController>(
      builder: (controller) {
        if (controller.loadingJobItemsSummaryTable.value &&
            controller.itemsSummaryTableList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            jobId: jobId,
          ),
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
  double totalNet = controller.calculateTotalsForJobItemsSummaryTable();

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: constraints.maxWidth - 17,
      child: DataTable(
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        columnSpacing: 5,
        horizontalMargin: horizontalMarginForTable,
        showBottomBorder: true,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        columns: [
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Invoice No.'),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Issue Date'),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Item Code'),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Item Name'),
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Quantity'),
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Price'),
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Total'),
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'VAT'),
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Net'),
          ),
        ],
        rows: [
          ...controller.itemsSummaryTableList.map<DataRow>((invoiceItems) {
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
              const DataCell(Text('')),
              const DataCell(Text('')),

              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('Totals')),
              DataCell(
                textForDataRowInTable(text: '$totalNet', color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  JobItemsSummaryTable invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  JobCardController controller,
  String jobId,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.invoiceNumber.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(invoiceItemsData.issueDate),
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.itemCode ?? '',
          formatDouble: false,
          color: invoiceItemsData.itemCode?.toLowerCase() == 'direct purchase'
              ? Colors.green
              : Colors.pink,
        ),
      ),
      DataCell(Text(invoiceItemsData.itemName ?? '')),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.quantity.toString(),
          color: Colors.orange,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.price.toString(),
          color: Colors.blue,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.total.toString(),
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.vat.toString(),
          color: Colors.blueGrey,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.net.toString(),
          color: Colors.red,
        ),
      ),
    ],
  );
}
