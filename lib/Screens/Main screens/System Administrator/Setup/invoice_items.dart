import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/invoice_items_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/invoice_items_widgets/add_new_invoice_item_or_edit.dart';
import '../../../../consts.dart';

class InvoiceItems extends StatelessWidget {
  const InvoiceItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GetX<InvoiceItemsController>(
                    init: InvoiceItemsController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for invoice items',
                        button: newInvoiceItemButton(
                            context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<InvoiceItemsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
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
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfScreens(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required InvoiceItemsController controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(
          text: 'Name',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Description',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Price',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSort,
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
            controller.search.value.text.isEmpty
        ? controller.allInvoiceItems.map<DataRow>((invoiceItems) {
            final invoiceItemsData =
                invoiceItems.data() as Map<String, dynamic>;
            final invoiceItemsId = invoiceItems.id;
            return dataRowForTheTable(invoiceItemsData, context, constraints,
                invoiceItemsId, controller);
          }).toList()
        : controller.filteredInvoiceItems.map<DataRow>((invoiceItems) {
            final invoiceItemsData =
                invoiceItems.data() as Map<String, dynamic>;
            final invoiceItemsId = invoiceItems.id;
            return dataRowForTheTable(invoiceItemsData, context, constraints,
                invoiceItemsId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> invoiceItemsData, context,
    constraints, invoiceItemsId, InvoiceItemsController controller) {
  return DataRow(cells: [
    DataCell(textForDataRowInTable(
        text: '${invoiceItemsData['name']}', maxWidth: 300)),
    DataCell(textForDataRowInTable(
        text: '${invoiceItemsData['description']}', maxWidth: 300)),
    DataCell(textForDataRowInTable(
      text: '${invoiceItemsData['price']}',
    )),
    DataCell(
      Text(
        invoiceItemsData['added_date'] != null &&
                invoiceItemsData['added_date'] != ''
            ? textToDate(invoiceItemsData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        editSection(
            context, controller, invoiceItemsData, constraints, invoiceItemsId),
        deleteSection(controller, invoiceItemsId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    InvoiceItemsController controller, invoiceItemsId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The invoiceItems will be deleted permanently",
            onPressed: () {
              controller.deleteInvoiceItem(invoiceItemsId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, InvoiceItemsController controller,
    Map<String, dynamic> invoiceItemsData, constraints, invoiceItemsId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              controller.description.text =
                  invoiceItemsData['description'] ?? '';
              controller.name.text = invoiceItemsData['name'] ?? '';
              controller.price.text =
                  (invoiceItemsData['price'] ?? '').toString();

              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewinvoiceItemsOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: controller.addingNewValue.value
                          ? null
                          : () {
                              controller.editInvoiceItem(invoiceItemsId);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: controller.addingNewValue.value == false
                          ? const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
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
      child: const Text('Edit'));
}

ElevatedButton newInvoiceItemButton(BuildContext context,
    BoxConstraints constraints, InvoiceItemsController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.description.clear();
      controller.price.clear();
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
                GetX<InvoiceItemsController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewValue.value
                                ? null
                                : () async {
                                    if (!controller
                                        .formKeyForAddingNewvalue.currentState!
                                        .validate()) {
                                    } else {
                                      await controller.addNewInvoiceItem();
                                    }
                                  },
                            style: saveButtonStyle,
                            child: controller.addingNewValue.value == false
                                ? const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(
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
    style: newButtonStyle,
    child: const Text('New Item'),
  );
}
