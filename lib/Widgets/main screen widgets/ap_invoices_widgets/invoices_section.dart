import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/ar receipts and ap payments/ap_invoices_model.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import 'invoice_section_for_ap_invoices.dart';

Widget invoicesSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required id,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<ApInvoicesController>(
      builder: (controller) {
        if (controller.loadingInvoices.value) {
          return Center(child: loadingProcess);
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            id: id,
          ),
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required ApInvoicesController controller,
  required String id,
}) {
  // List data = controller.calculateTotals();

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
        dataTextStyle: regTextStyle,
        headingTextStyle: fontStyleForTableHeader,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: ''),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Transaction Type',
            ),
          ),
          // DataColumn(
          //   label: AutoSizedText(
          //     constraints: constraints,
          //     text: 'Invoice No.',
          //   ),
          // ),
          // DataColumn(
          //   label: AutoSizedText(
          //     constraints: constraints,
          //     text: 'Invoice Date',
          //   ),
          // ),
          // DataColumn(
          //   label: AutoSizedText(
          //     constraints: constraints,
          //     text: 'Vendor',
          //   ),
          // ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Note'),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Received Number',
            ),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Job Number'),
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Amount'),
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'VAT'),
          ),
        ],
        rows: [
          ...controller.allInvoices.where((item)=> item.isDeleted != true).map<DataRow>((invoiceItems) {
            String invoiceItemsId = invoiceItems.id ?? invoiceItems.uuid ?? '';
            return dataRowForTheTable(
              invoiceItems,
              context,
              constraints,
              invoiceItemsId,
              controller,
              id,
            );
          }),
        ],
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  ApInvoicesItem invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  String invoiceItemsId,
  ApInvoicesController controller,
  String apInvoiceID,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(apInvoiceID, context, controller, invoiceItemsId),
            editSection(
              apInvoiceID,
              controller,
              invoiceItemsData,
              context,
              constraints,
              invoiceItemsId,
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(text: invoiceItemsData.transactionTypeName ?? ''),
      ),

      DataCell(textForDataRowInTable(text: invoiceItemsData.note ?? '')),
      DataCell(
        textForDataRowInTable(
          text: '', // '${invoiceItemsData['report_reference'] ?? ''}',
        ),
      ),
      DataCell(textForDataRowInTable(text: invoiceItemsData.jobNumber ?? '')),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.amount.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.vat.toString(),
          color: Colors.red,
          isBold: true,
        ),
      ),
    ],
  );
}

Widget deleteSection(
  String apInvoiceID,
  context,
  ApInvoicesController controller,
  invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      if (controller.status.value == 'New' || controller.status.isEmpty) {
        alertDialog(
          context: context,
          content: 'This will be deleted permanently',
          onPressed: () {
            controller.deleteInvoiceItem(invoiceItemsId);
          },
        );
      } else {
        showSnackBar('Alert', 'Only New AP Invoice Allowed');
      }
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}

Widget editSection(
  String apInvoiceID,
  ApInvoicesController controller,
  ApInvoicesItem invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      if (controller.status.value == 'New' || controller.status.isEmpty) {
        controller.transactionType.text =
            invoiceItemsData.transactionTypeName ?? '';
        controller.transactionTypeId.value =
            invoiceItemsData.transactionType ?? '';
        controller.invoiceNote.text = invoiceItemsData.note ?? '';
        controller.vat.text = invoiceItemsData.vat.toString();
        controller.amount.text = invoiceItemsData.amount.toString();
        controller.jobNumber.text = invoiceItemsData.jobNumber ?? '';
        invoiceItemsForapInvoicesDialog(
          controller: controller,
          constraints: constraints,
          onPressed: () {
            controller.editInvoiceItem(invoiceItemsId);
          },
          context: context,
        );
      } else {
        showSnackBar('Alert', 'Only New AP Invoice Allowed');
      }
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}

ElevatedButton newinvoiceItemsButton(
  BuildContext context,
  BoxConstraints constraints,
  ApInvoicesController controller,
  String apInvoiceID,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.status.value == 'New' || controller.status.isEmpty) {
        controller.transactionType.clear();
        controller.transactionTypeId.value = '';
        controller.invoiceNote.clear();
        controller.vat.text = '';
        controller.amount.text = '';
        controller.jobNumber.clear();

        invoiceItemsForapInvoicesDialog(
          context: context,
          controller: controller,
          constraints: constraints,
          onPressed: () {
            controller.addNewInvoiceItem();
          },
        );
      } else {
        showSnackBar('Alert', 'Only New AP Invoice Allowed');
      }
    },
    style: new2ButtonStyle,
    child: const Text(
      'New item',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
