import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../auto_size_box.dart';
import 'invoice_section_for_ap_invoices.dart';

Widget invoicesSection(
    {required BuildContext context,
    required BoxConstraints constraints,
    required id}) {
  return Container(
    decoration: containerDecor,
    child: GetX<ApInvoicesController>(
      builder: (controller) {
        if (controller.loadingInvoices.value) {
          return Center(
            child: loadingProcess,
          );
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

Widget tableOfScreens(
    {required BoxConstraints constraints,
    required BuildContext context,
    required ApInvoicesController controller,
    required String id}) {
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
              label: AutoSizedText(
                constraints: constraints,
                text: '',
              ),
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
              label: AutoSizedText(
                constraints: constraints,
                text: 'Note',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Received Number',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Job Number',
              ),
            ),
            DataColumn(
              headingRowAlignment: MainAxisAlignment.end,
              label: AutoSizedText(
                constraints: constraints,
                text: 'Amount',
              ),
            ),
            DataColumn(
              headingRowAlignment: MainAxisAlignment.end,
              label: AutoSizedText(
                constraints: constraints,
                text: 'VAT',
              ),
            ),
          ],
          rows: [
            ...controller.allInvoices.map<DataRow>((invoiceItems) {
              final invoiceItemsData = invoiceItems.data();
              final invoiceItemsId = invoiceItems.id;
              return dataRowForTheTable(invoiceItemsData, context, constraints,
                  invoiceItemsId, controller, id);
            }),
          ]),
    ),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> invoiceItemsData,
    context,
    constraints,
    String invoiceItemsId,
    ApInvoicesController controller,
    String apInvoiceID) {
  return DataRow(cells: [
    DataCell(Row(
      children: [
        deleteSection(apInvoiceID, context, controller, invoiceItemsId),
        editSection(apInvoiceID, controller, invoiceItemsData, context,
            constraints, invoiceItemsId)
      ],
    )),
    DataCell(textForDataRowInTable(
        text: getdataName(invoiceItemsData['transaction_type'],
            controller.allTransactionsTypes,
            title: 'type'))),
    // DataCell(textForDataRowInTable(
    //     text: '${invoiceItemsData['invoice_number'] ?? ''}')),
    // DataCell(textForDataRowInTable(
    //     text: textToDate(invoiceItemsData['invoice_date'] ?? ''))),
    // DataCell(textForDataRowInTable(
    //     text: getdataName(invoiceItemsData['vendor'], controller.allVendors,
    //         title: 'entity_name'))),
    DataCell(textForDataRowInTable(text: '${invoiceItemsData['note'] ?? ''}')),
    DataCell(textForDataRowInTable(
        text: '${invoiceItemsData['report_reference'] ?? ''}')),
    DataCell(
        textForDataRowInTable(text: '${invoiceItemsData['job_number'] ?? ''}')),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(
            text: invoiceItemsData['amount'] ?? '',
            color: Colors.green,
            isBold: true))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(
            text: '${invoiceItemsData['vat'] ?? ''}',
            color: Colors.red,
            isBold: true))),
  ]);
}

Widget deleteSection(String apInvoiceID, context,
    ApInvoicesController controller, invoiceItemsId) {
  return IconButton(
      onPressed: () {
        if (controller.status.value == 'New') {
          alertDialog(
              context: context,
              content: 'This will be deleted permanently',
              onPressed: () {
                controller.deleteInvoiceItem(
                    apInvoiceID != ''
                        ? apInvoiceID
                        : controller.currentApInvoiceId.value,
                    invoiceItemsId);
              });
        } else {
          showSnackBar('Alert', 'Only New AP Invoice Allowed');
        }
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ));
}

Widget editSection(
    String apInvoiceID,
    ApInvoicesController controller,
    Map<String, dynamic> invoiceItemsData,
    context,
    constraints,
    String invoiceItemsId) {
  return IconButton(
      onPressed: () {
        if (controller.status.value == 'New') {
          controller.transactionType.text = getdataName(
              invoiceItemsData['transaction_type'],
              controller.allTransactionsTypes,
              title: 'type');
          controller.transactionTypeId.value =
              invoiceItemsData['transaction_type'] ?? '';
          controller.invoiceNote.text = invoiceItemsData['note'] ?? '';
          controller.vat.text = invoiceItemsData['vat'] ?? '';
          controller.amount.text = invoiceItemsData['amount'] ?? '';
          // controller.invoiceNumber.text =
          //     invoiceItemsData['invoice_number'] ?? '';
          // controller.invoiceDate.text =
          //     textToDate(invoiceItemsData['invoice_date']);
          controller.jobNumber.text = invoiceItemsData['job_number'] ?? '';
          // controller.vendorForInvoice.text =
          //     getdataName(invoiceItemsData['vendor'], controller.allVendors,title: 'entity_name');
          // controller.vendorForInvoiceId.value =
          //     invoiceItemsData['vendor'] ?? '';
          invoiceItemsForapInvoicesDialog(
              apInvoiceID: invoiceItemsId,
              controller: controller,
              constraints: constraints,
              onPressed: controller.addingNewinvoiceItemsValue.value
                  ? null
                  : () {
                      controller.editInvoiceItem(
                          apInvoiceID != ''
                              ? apInvoiceID
                              : controller.currentApInvoiceId.value,
                          invoiceItemsId);
                    },
              context: context);
        } else {
          showSnackBar('Alert', 'Only New AP Invoice Allowed');
        }
      },
      icon: const Icon(
        Icons.edit_note_rounded,
        color: Colors.blue,
      ));
}

ElevatedButton newinvoiceItemsButton(
    BuildContext context,
    BoxConstraints constraints,
    ApInvoicesController controller,
    String apInvoiceID) {
  return ElevatedButton(
    onPressed: () {
      if (controller.canAddInvoice.isTrue) {
        if (controller.status.value == 'New') {
          controller.transactionType.clear();
          controller.transactionTypeId.value = '';
          controller.invoiceNote.clear();
          controller.vat.clear();
          controller.amount.clear();
          // controller.invoiceNumber.clear();
          // controller.invoiceDate.clear();
          controller.jobNumber.clear();
          // controller.vendorForInvoice.clear();
          // controller.vendorForInvoiceId.value = '';

          invoiceItemsForapInvoicesDialog(
              context: context,
              apInvoiceID: apInvoiceID,
              controller: controller,
              constraints: constraints,
              onPressed: controller.addingNewinvoiceItemsValue.value
                  ? null
                  : () async {
                      controller.addNewInvoiceItem(apInvoiceID != ''
                          ? apInvoiceID
                          : controller.currentApInvoiceId.value);
                    });
        } else {
          showSnackBar('Alert', 'Only New AP Invoice Allowed');
        }
      } else {
        showSnackBar('Alert', 'Please Save AP Invoice First');
      }
    },
    style: new2ButtonStyle,
    child: const Text(
      'New item',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
