import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';
import 'invoice_items_for_job_dialog.dart';

Widget invoiceItemsDialog(
    {required BuildContext context,
    required BoxConstraints constraints,
    required jobId}) {
  return SizedBox(
    child: Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                GetX<JobCardController>(
                  builder: (controller) {
                    return searchBar(
                      search: controller.searchForInvoiceItems,
                      constraints: constraints,
                      context: context,
                      controller: controller,
                      title: 'Search for invoices',
                      button: newinvoiceItemsButton(
                          context, constraints, controller, jobId),
                    );
                  },
                ),
                Expanded(
                  child: GetX<JobCardController>(
                    builder: (controller) {
                      if (controller.loadingInvoiceItems.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (controller.allInvoiceItems.isEmpty) {
                        return const Center(
                          child: Text('No Element'),
                        );
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
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required JobCardController controller,
    required String jobId}) {
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
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Line No.',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Name',
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(
              constraints: constraints,
              text: 'Quantity',
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(
              constraints: constraints,
              text: 'Price',
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
              text: 'Discount',
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(
              constraints: constraints,
              text: 'Total',
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(
              constraints: constraints,
              text: 'VAT',
            ),
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(
              constraints: constraints,
              text: 'NET',
            ),
          ),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center, label: SizedBox()),
        ],
        rows: controller.filteredInvoiceItems.isEmpty &&
                controller.searchForInvoiceItems.value.text.isEmpty
            ? [
                ...controller.allInvoiceItems.map<DataRow>((invoiceItems) {
                  final invoiceItemsData =
                      invoiceItems.data() as Map<String, dynamic>;
                  final invoiceItemsId = invoiceItems.id;
                  return dataRowForTheTable(invoiceItemsData, context,
                      constraints, invoiceItemsId, controller, jobId);
                }),
                DataRow(selected: true, cells: [
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Align(
                      alignment: Alignment.centerRight, child: Text('Totals'))),
                  DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: textForDataRowInTable(
                        text: '${data[0]}', color: Colors.blue),
                  )),
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: textForDataRowInTable(
                          text: '${data[1]}', color: Colors.green))),
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: textForDataRowInTable(
                          text: '${data[2]}', color: Colors.red))),
                  DataCell(Text('')),
                ])
              ]
            : [
                ...controller.filteredInvoiceItems.map<DataRow>((invoiceItems) {
                  final invoiceItemsData =
                      invoiceItems.data() as Map<String, dynamic>;
                  final invoiceItemsId = invoiceItems.id;
                  return dataRowForTheTable(invoiceItemsData, context,
                      constraints, invoiceItemsId, controller, jobId);
                }),
                DataRow(selected: true, cells: [
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Text('')),
                  DataCell(Align(
                      alignment: Alignment.centerRight, child: Text('Totals'))),
                  DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: textForDataRowInTable(
                        text: '${data[0]}', color: Colors.blue),
                  )),
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: textForDataRowInTable(
                          text: '${data[1]}', color: Colors.green))),
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: textForDataRowInTable(
                          text: '${data[2]}', color: Colors.red))),
                  DataCell(Text('')),
                ])
              ],
      ),
    ),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> invoiceItemsData,
    context,
    constraints,
    String invoiceItemsId,
    JobCardController controller,
    String jobId) {
  return DataRow(cells: [
    DataCell(Text('${invoiceItemsData['line_number'] ?? ''}')),
    DataCell(textForDataRowInTable(
        text: controller.getdataName(
            invoiceItemsData['name'], controller.allInvoiceItemsFromCollection),
        maxWidth: null)),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: '${invoiceItemsData['quantity']}'))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: '${invoiceItemsData['price']}'))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: '${invoiceItemsData['amount']}'))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: '${invoiceItemsData['discount']}'))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: '${invoiceItemsData['total']}'))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: '${invoiceItemsData['vat']}'))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: '${invoiceItemsData['net']}'))),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        editSection(jobId, controller, invoiceItemsData, context, constraints,
            invoiceItemsId),
        deleteSection(jobId, context, controller, invoiceItemsId),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    String jobId, context, JobCardController controller, invoiceItemsId) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: 'This will be deleted permanently',
            onPressed: () {
              controller.deleteInvoiceItem(jobId, invoiceItemsId);
            });
      },
      child: const Text('Delete'));
}

ElevatedButton editSection(
    String jobId,
    JobCardController controller,
    Map<String, dynamic> invoiceItemsData,
    context,
    constraints,
    String invoiceItemsId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.invoiceItemNameId.value = invoiceItemsData['name'];
        controller.invoiceItemName.text = controller.getdataName(
            invoiceItemsData['name'], controller.allInvoiceItemsFromCollection);
        controller.lineNumber.text =
            (invoiceItemsData['line_number'] ?? '').toString();
        controller.description.text = invoiceItemsData['description'];
        controller.quantity.text = invoiceItemsData['quantity'];
        controller.price.text = invoiceItemsData['price'];
        controller.amount.text = invoiceItemsData['amount'];
        controller.discount.text = invoiceItemsData['discount'];
        controller.total.text = invoiceItemsData['total'];
        controller.vat.text = invoiceItemsData['vat'];
        controller.net.text = invoiceItemsData['net'];
        invoiceItemsForJobDialog(
            jobId: jobId,
            controller: controller,
            constraints: constraints,
            onPressed: controller.addingNewinvoiceItemsValue.value
                ? null
                : () {
                    controller.editInvoiceItem(jobId, invoiceItemsId);
                  });
      },
      child: Text('Edit'));
}

ElevatedButton newinvoiceItemsButton(BuildContext context,
    BoxConstraints constraints, JobCardController controller, String jobId) {
  return ElevatedButton(
    onPressed: () {
      controller.clearInvoiceItemsVariables();

      invoiceItemsForJobDialog(
          jobId: jobId,
          controller: controller,
          constraints: constraints,
          onPressed: controller.addingNewinvoiceItemsValue.value
              ? null
              : () async {
                  if (!controller.formKeyForInvoiceItems.currentState!
                      .validate()) {
                  } else {
                    controller.addNewInvoiceItem(jobId);
                  }
                });
    },
    style: newButtonStyle,
    child: const Text('New item'),
  );
}
