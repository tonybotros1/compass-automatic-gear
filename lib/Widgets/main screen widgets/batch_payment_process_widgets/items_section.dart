import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/batch_payment_process_controller.dart';
import 'package:datahubai/Models/batch_payment_process/batch_payment_process_items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import 'items_dialog.dart';

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
      lmRatio: 2.5,
      columns: [
        const DataColumn2(label: SizedBox(), size: ColumnSize.S),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Transaction Type',
          ),
        ),

        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Invoice #'),
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
          label: AutoSizedText(constraints: constraints, text: 'Receiving #'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Job #'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Amount'),
          numeric: true,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Vat'),
          numeric: true,
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
        Row(
          children: [
            deleteItemButton(controller, data, context),
            editItemButton(controller, data),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.transactionTypeName ?? '',
          formatDouble: false,
          maxWidth: null,
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
          color: Colors.purple,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.vendorName ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.note ?? '',
          formatDouble: true,
          maxWidth: null,
        ),
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
          isBold: true,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.amount?.toString() ?? '0',
          formatDouble: true,
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.vat?.toString() ?? '0',
          formatDouble: true,
          color: Colors.blue,
        ),
      ),
    ],
  );
}

IconButton editItemButton(
  BatchPaymentProcessController controller,
  BatchPaymentProcessItemsModel data,
) {
  return IconButton(
    onPressed: () async {
      controller.transactionType.text = data.transactionTypeName ?? '';
      controller.transactionTypeId.value = data.transactionType ?? '';
      controller.receivedNumber.text = data.receivingNumber ?? '';
      controller.receivedNumberId.value = data.receivingNumberId ?? '';
      controller.vendor.text = data.vendorName ?? '';
      controller.vendorId.value = data.vendor ?? '';
      controller.amount.text = data.amount?.toString() ?? '0';
      controller.vat.text = data.vat?.toString() ?? '0';
      controller.invoiceNumber.text = data.invoiceNumber ?? '';
      controller.invoiceDate.text = textToDate(data.invoiceDate);
      controller.jobNumber.text = data.jobNumber ?? '';
      controller.jobNumberId.text = data.jobNumberId ?? '';
      controller.invoiceNote.text = data.note ?? '';
      batchItemsDialog(
        controller: controller,
        onTapForSave: () async {
          await controller.updateItem(data.id ?? '');
        },
      );
    },
    icon: editIcon,
  );
}

IconButton deleteItemButton(
  BatchPaymentProcessController controller,
  BatchPaymentProcessItemsModel data,
  BuildContext context,
) {
  return IconButton(
    onPressed: () async {
      Map status = await controller.getBatchStatus(
        controller.currentBatchId.value,
      );
      String status1 = status['status'];
      if ((status1 == 'Posted')) {
        alertMessage(
          context: Get.context!,
          content: 'Can\'t delete items for posted batches',
        );
        return;
      }
      alertDialog(
        context: Get.context!,
        content: 'Are you sure you want to remove this item?',
        onPressed: () {
          controller.deleteItem(data.id ?? '');
        },
      );
    },
    icon: deleteIcon,
  );
}
