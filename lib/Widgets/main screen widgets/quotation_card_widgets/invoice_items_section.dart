import 'package:datahubai/Models/job%20cards/job_card_invoice_items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import 'invoice_items_for_quotation_dialog.dart';

Widget invoiceItemsSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required quotationId,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<QuotationCardController>(
      builder: (controller) {
        if (controller.loadingInvoiceItems.value &&
            controller.allInvoiceItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            quotationId: quotationId,
          ),
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required QuotationCardController controller,
  required String quotationId,
}) {
  List data = controller.calculateTotals();

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
          const DataColumn(label: SizedBox()),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Line No.'),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Name'),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'Quantity'),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'Price'),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'Amount'),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'Discount'),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'Total'),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'VAT'),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'NET'),
          ),
        ],
        rows: [
          ...controller.allInvoiceItems
              .where((item) => item.deleted != true)
              .map<DataRow>((invoiceItems) {
                String invoiceItemsId =
                    invoiceItems.id ?? invoiceItems.uid ?? '';
                return dataRowForTheTable(
                  invoiceItems,
                  context,
                  constraints,
                  invoiceItemsId,
                  controller,
                  quotationId,
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
              const DataCell(
                Align(alignment: Alignment.centerRight, child: Text('Totals')),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: textForDataRowInTable(
                    text: '${data[0]}',
                    color: Colors.blue,
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: textForDataRowInTable(
                    text: '${data[1]}',
                    color: Colors.green,
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: textForDataRowInTable(
                    text: '${data[2]}',
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  JobCardInvoiceItemsModel invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  String invoiceItemsId,
  QuotationCardController controller,
  String quotationId,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(quotationId, context, controller, invoiceItemsId),
            editSection(
              quotationId,
              controller,
              invoiceItemsData,
              context,
              constraints,
              invoiceItemsId,
            ),
          ],
        ),
      ),
      DataCell(Text(invoiceItemsData.lineNumber.toString())),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.name ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: invoiceItemsData.quantity.toString(),
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(text: invoiceItemsData.price.toString()),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: invoiceItemsData.amount.toString(),
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: invoiceItemsData.discount.toString(),
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(text: invoiceItemsData.total.toString()),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(text: invoiceItemsData.vat.toString()),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(text: invoiceItemsData.net.toString()),
        ),
      ),
    ],
  );
}

Widget deleteSection(
  String quotationId,
  BuildContext context,
  QuotationCardController controller,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      if (controller.quotationStatus.value == 'New' ||
          controller.quotationStatus.value.isEmpty) {
        alertDialog(
          context: context,
          content: 'This will be deleted permanently',
          onPressed: () {
            controller.deleteInvoiceItem(invoiceItemsId);
          },
        );
      } else {
        showSnackBar('Alert', 'Only New Quotations Allowed');
      }
    },
    icon: const Icon(Icons.delete_forever, color: Colors.red),
  );
}

Widget editSection(
  String quotationId,
  QuotationCardController controller,
  JobCardInvoiceItemsModel invoiceItemsData,
  context,
  constraints,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      if (controller.quotationStatus.value == 'New' ||
          controller.quotationStatus.value.isEmpty) {
        controller.invoiceItemNameId.value = invoiceItemsData.nameId ?? '';
        controller.invoiceItemName.text = invoiceItemsData.name ?? '';
        controller.lineNumber.text = (invoiceItemsData.lineNumber ?? '')
            .toString();
        controller.description.text = invoiceItemsData.description ?? '';
        controller.quantity.text = invoiceItemsData.quantity.toString();
        controller.price.text = invoiceItemsData.price.toString();
        controller.amount.text = invoiceItemsData.amount.toString();
        controller.discount.text = invoiceItemsData.discount.toString();
        controller.total.text = invoiceItemsData.total.toString();
        controller.vat.text = invoiceItemsData.vat.toString();
        controller.net.text = invoiceItemsData.net.toString();
        invoiceItemsForQuotationDialog(
          controller: controller,
          constraints: constraints,
          onPressed: controller.addingNewinvoiceItemsValue.value
              ? null
              : () {
                  controller.editInvoiceItem(invoiceItemsId);
                },
        );
      } else {
        showSnackBar('Alert', 'Only New Quotations Allowed');
      }
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}

ElevatedButton newinvoiceItemsButton(
  BuildContext context,
  BoxConstraints constraints,
  QuotationCardController controller,
  String quotationId,
) {
  return ElevatedButton(
    onPressed: () {
      // if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
      //   if (controller.quotationStatus.value == 'New') {

      //   } else {
      //     showSnackBar('Alert', 'Only New Quotations Allowed');
      //   }
      // } else {
      //   showSnackBar('Alert', 'Please Save Quotation First');
      // }
      controller.clearInvoiceItemsVariables();

      invoiceItemsForQuotationDialog(
        controller: controller,
        constraints: constraints,
        onPressed: controller.addingNewinvoiceItemsValue.value
            ? null
            : () async {
                controller.addNewInvoiceItem();
              },
      );
    },
    style: new2ButtonStyle,
    child: const Text(
      'New item',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
