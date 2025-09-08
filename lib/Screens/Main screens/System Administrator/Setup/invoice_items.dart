import 'package:datahubai/Widgets/main%20screen%20widgets/invoice_items_widgets/invoice_items_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/invoice_items_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
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
                        // controller: controller,
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
    {required BoxConstraints constraints,
    required BuildContext context,
    required InvoiceItemsController controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    horizontalMargin: horizontalMarginForTable,
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
      const DataColumn(label: Text('')),
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
        text: '${invoiceItemsData['name']}', maxWidth: null)),
    DataCell(textForDataRowInTable(
        text: '${invoiceItemsData['description']}', maxWidth: 300)),
    DataCell(textForDataRowInTable(
      text: '${invoiceItemsData['price']}',
    )),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
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
            content: "The invoiceItems will be deleted permanently",
            onPressed: () {
              controller.deleteInvoiceItem(invoiceItemsId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(BuildContext context, InvoiceItemsController controller,
    Map<String, dynamic> invoiceItemsData, constraints, invoiceItemsId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.description.text = invoiceItemsData['description'] ?? '';
        controller.name.text = invoiceItemsData['name'] ?? '';
        controller.price.text = (invoiceItemsData['price'] ?? '').toString();
        invoiceItemsDialog(
          constraints: constraints,
          controller: controller,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  if (controller.name.text.isEmpty) {
                    showSnackBar('Alert', 'Please Enter Name');
                  } else {
                    await controller.editInvoiceItem(invoiceItemsId);
                  }
                },
        );
      },
      child: const Text('Edit'));
}

ElevatedButton newInvoiceItemButton(BuildContext context,
    BoxConstraints constraints, InvoiceItemsController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.description.clear();
      controller.price.text = '0';
      invoiceItemsDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                if (controller.name.text.isEmpty) {
                  showSnackBar('Alert', 'Please Enter Name');
                } else {
                  await controller.addNewInvoiceItem();
                }
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Item'),
  );
}
