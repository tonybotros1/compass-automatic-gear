import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/batch_payment_process_controller.dart';
import 'package:datahubai/Models/batch_payment_process/batch_payment_process_items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Widget itemsSection({
  required BuildContext context,
  required BoxConstraints constraints,
}) {
  return Container(
    height: 600,
    decoration: containerDecor,
    child: GetX<BatchPaymentProcessController>(
      builder: (controller) {
        return tableOfScreens(
          constraints: constraints,
          context: context,
          controller: controller,
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required BatchPaymentProcessController controller,
}) {
  return SizedBox(
    width: constraints.maxWidth - 17,
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      dataTextStyle: regTextStyle,
      headingTextStyle: fontStyleForTableHeader,
      lmRatio: 2.5,
      columns: [
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Transaction Type',
          ),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Amount'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Vat'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Invoice Number',
          ),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Invoice Date'),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'Vendor'),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'Note'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Receiving Number',
          ),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Job Number'),
        ),
      ],
      rows: controller.items.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(
          invoiceItems,
          context,
          constraints,
          controller,
        );
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  BatchPaymentProcessItemsModel data,
  BuildContext context,
  BoxConstraints constraints,
  BatchPaymentProcessController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.transactionTypeName ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.amount?.toString() ?? '0',
          formatDouble: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.vat?.toString() ?? '0',
          formatDouble: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.invoiceNumber ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.invoiceDate),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.vendorName ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(text: data.note ?? '', formatDouble: true),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.receivingNumber ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.jobNumber ?? '',
          color: Colors.green,
          isBold: true,
          formatDouble: false,
        ),
      ),
    ],
  );
}
