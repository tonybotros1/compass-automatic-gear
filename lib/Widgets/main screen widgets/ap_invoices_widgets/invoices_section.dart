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
    {required constraints,
    required context,
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
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Invoice No.',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Invoice Date',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Vendor',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Note',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Report Reference',
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
              final invoiceItemsData =
                  invoiceItems.data() as Map<String, dynamic>;
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
    String jobId) {
  return DataRow(cells: [
    DataCell(Row(
      children: [
        deleteSection(jobId, context, controller, invoiceItemsId),
        editSection(jobId, controller, invoiceItemsData, context, constraints,
            invoiceItemsId)
      ],
    )),
    DataCell(textForDataRowInTable(
        text: getdataName(invoiceItemsData['transaction_type'],
            controller.allTransactionsTypes,
            title: 'type'))),
    DataCell(textForDataRowInTable(
        text: '${invoiceItemsData['invoice_number'] ?? ''}')),
    DataCell(textForDataRowInTable(
        text: textToDate(invoiceItemsData['invoice_date'] ?? ''))),
    DataCell(textForDataRowInTable(
        text: getdataName(invoiceItemsData['vendor'], controller.allVendors,
            title: 'entity_name'))),
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

Widget deleteSection(
    String jobId, context, ApInvoicesController controller, invoiceItemsId) {
  return IconButton(
      onPressed: () {
        if (controller.status.value == 'New') {
          alertDialog(
              context: context,
              controller: controller,
              content: 'This will be deleted permanently',
              onPressed: () {
                controller.deleteInvoiceItem(jobId, invoiceItemsId);
              });
        } else {
          showSnackBar('Alert', 'Only New Jobs Allowed');
        }
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ));
}

Widget editSection(
    String jobId,
    ApInvoicesController controller,
    Map<String, dynamic> invoiceItemsData,
    context,
    constraints,
    String invoiceItemsId) {
  return IconButton(
      onPressed: () {
        if (controller.status.value == 'New') {
          // controller.invoiceItemNameId.value = invoiceItemsData['name'];
          // controller.invoiceItemName.text = controller.getdataName(
          //     invoiceItemsData['name'],
          //     controller.allInvoiceItemsFromCollection);
          // controller.lineNumber.text =
          //     (invoiceItemsData['line_number'] ?? '').toString();
          // controller.description.text = invoiceItemsData['description'];
          // controller.quantity.text = invoiceItemsData['quantity'];
          // controller.price.text = invoiceItemsData['price'];
          // controller.amount.text = invoiceItemsData['amount'];
          // controller.discount.text = invoiceItemsData['discount'];
          // controller.total.text = invoiceItemsData['total'];
          // controller.vat.text = invoiceItemsData['vat'];
          // controller.net.text = invoiceItemsData['net'];
          // invoiceItemsForJobDialog(
          //     jobId: jobId,
          //     controller: controller,
          //     constraints: constraints,
          //     onPressed: controller.addingNewinvoiceItemsValue.value
          //         ? null
          //         : () {
          //             controller.editInvoiceItem(jobId, invoiceItemsId);
          //           });
        } else {
          showSnackBar('Alert', 'Only New Jobs Allowed');
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
          controller.invoiceNumber.clear();
          controller.invoiceDate.clear();
          controller.jobNumber.clear();
          controller.vendorForInvoice.clear();
          controller.vendorForInvoiceId.value = '';

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
          showSnackBar('Alert', 'Only New Jobs Allowed');
        }
      } else {
        showSnackBar('Alert', 'Please Save Job First');
      }
    },
    style: new2ButtonStyle,
    child: const Text(
      'New item',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
