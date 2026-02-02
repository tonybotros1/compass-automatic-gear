import 'package:datahubai/Models/job%20cards/job_card_invoice_items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import 'invoice_items_for_job_dialog.dart';

Widget invoiceItemsSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required jobId,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<JobCardController>(
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
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        columns: [
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: ''),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Line No.'),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Name'),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Description'),
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
            label: AutoSizedText(constraints: constraints, text: 'Net'),
          ),
        ],
        rows: [
          ...controller.allInvoiceItems
              .where((item) => item.deleted != true)
              .map<DataRow>((invoiceItems) {
                final invoiceItemsId =
                    invoiceItems.id ?? invoiceItems.uid ?? '';
                return dataRowForTheTable(
                  invoiceItems,
                  context,
                  constraints,
                  invoiceItemsId,
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
  JobCardController controller,
  String jobId,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(jobId, context, controller, invoiceItemsId),
            editSection(
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
      DataCell(Text(invoiceItemsData.description ?? '')),
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
          child: textForDataRowInTable(
            text: invoiceItemsData.total.toString(),
            color: Colors.blue,
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: invoiceItemsData.vat.toString(),
            color: Colors.green,
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: invoiceItemsData.net.toString(),
            color: Colors.red,
          ),
        ),
      ),
    ],
  );
}

Widget deleteSection(
  String jobId,
  context,
  JobCardController controller,
  invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      if (controller.jobStatus1.value == 'New' ||
          controller.jobStatus1.isEmpty) {
        alertDialog(
          context: context,
          content: 'Are you sure you want to remove this item?',
          onPressed: () {
            controller.deleteInvoiceItem(invoiceItemsId);
          },
        );
      } else {
        showSnackBar('Alert', 'Only New Jobs Allowed');
      }
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}

Widget editSection(
  JobCardController controller,
  JobCardInvoiceItemsModel invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      if (controller.jobStatus1.value == 'New' ||
          controller.jobStatus1.isEmpty) {
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
        invoiceItemsForJobDialog(
          controller: controller,
          constraints: constraints,
          onPressed: controller.addingNewinvoiceItemsValue.value
              ? null
              : () {
                  controller.editInvoiceItem(invoiceItemsId);
                },
        );
      } else {
        showSnackBar('Alert', 'Only New Jobs Allowed');
      }
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}

ElevatedButton newinvoiceItemsButton(
  BuildContext context,
  BoxConstraints constraints,
  JobCardController controller,
  String jobId,
) {
  return ElevatedButton(
    onPressed: () {
      // if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
      //   if (controller.jobStatus1.value == 'New') {

      //   } else {
      //     showSnackBar('Alert', 'Only New Jobs Allowed');
      //   }
      // } else {
      //   showSnackBar('Alert', 'Please Save Job First');
      // }
      controller.clearInvoiceItemsVariables();

      invoiceItemsForJobDialog(
        controller: controller,
        constraints: constraints,
        onPressed: controller.addingNewinvoiceItemsValue.isTrue
            ? null
            : () async {
                controller.addNewInvoiceItem();
              },
      );
    },
    style: newButtonStyle,
    child: const Text(
      'New item',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
