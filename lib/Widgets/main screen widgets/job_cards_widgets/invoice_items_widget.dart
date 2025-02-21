import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';
import 'add_new_invoice_item_or_edit.dart';

Widget invoiceItemsDialog(
    {required BuildContext context,
    required BoxConstraints constraints,
    required jobId}) {
  return SizedBox(
    height: constraints.maxHeight / 1.5,
    width: constraints.maxWidth,
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
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreens(
                            constraints: constraints,
                            context: context,
                            controller: controller,
                            jobId: jobId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        GetX<JobCardController>(builder: (controller) {
          List data = controller.calculateTotals();
          return Row(
            spacing: 10,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Totals:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue[500])),
                Text('VATs:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[500])),
                Text('NETs:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red[500]))
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(data[0].toStringAsFixed(2), style: fontStyle2),
                Text(data[1].toStringAsFixed(2), style: fontStyle2),
                Text(data[2].toStringAsFixed(2), style: fontStyle2),
              ]),
            ],
          );
        }),
      ],
    ),
  );
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required JobCardController controller,
    required String jobId}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
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
          headingRowAlignment: MainAxisAlignment.center,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Action',
          ),
        ),
      ],
      rows: controller.filteredInvoiceItems.isEmpty &&
              controller.searchForInvoiceItems.value.text.isEmpty
          ? controller.allInvoiceItems.map<DataRow>((invoiceItems) {
              final invoiceItemsData =
                  invoiceItems.data() as Map<String, dynamic>;
              final invoiceItemsId = invoiceItems.id;
              return dataRowForTheTable(invoiceItemsData, context, constraints,
                  invoiceItemsId, controller, jobId);
            }).toList()
          : controller.filteredInvoiceItems.map<DataRow>((invoiceItems) {
              final invoiceItemsData =
                  invoiceItems.data() as Map<String, dynamic>;
              final invoiceItemsId = invoiceItems.id;
              return dataRowForTheTable(invoiceItemsData, context, constraints,
                  invoiceItemsId, controller, jobId);
            }).toList(),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewinvoiceItemsOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                ),
                actions: [
                  GetX<JobCardController>(
                      builder: (controller) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed:
                                  controller.addingNewinvoiceItemsValue.value
                                      ? null
                                      : () {
                                          controller.editInvoiceItem(
                                              jobId, invoiceItemsId);
                                        },
                              style: saveButtonStyle,
                              child:
                                  controller.addingNewinvoiceItemsValue.value ==
                                          false
                                      ? const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                            ),
                          )),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: cancelButtonStyle,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              );
            });
      },
      child: Text('Edit'));
}

ElevatedButton newinvoiceItemsButton(BuildContext context,
    BoxConstraints constraints, JobCardController controller, String jobId) {
  return ElevatedButton(
    onPressed: () {
      controller.clearInvoiceItemsVariables();

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewinvoiceItemsOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                Row(
                  spacing: 20,
                  children: [
                    ElevatedButton(
                        style: clearVariablesButtonStyle,
                        onPressed: () {
                          controller.clearInvoiceItemsVariables();
                        },
                        child: Text('Clear All')),
                    Spacer(),
                    GetX<JobCardController>(
                        builder: (controller) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ElevatedButton(
                                onPressed: controller
                                        .addingNewinvoiceItemsValue.value
                                    ? null
                                    : () async {
                                        if (!controller.formKeyForInvoiceItems
                                            .currentState!
                                            .validate()) {
                                        } else {
                                          controller.addNewInvoiceItem(jobId);
                                        }
                                      },
                                style: saveButtonStyle,
                                child: controller
                                            .addingNewinvoiceItemsValue.value ==
                                        false
                                    ? const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                              ),
                            )),
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: cancelButtonStyle,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New item'),
  );
}
