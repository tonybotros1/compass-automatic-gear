import 'package:datahubai/Models/invoice%20items/invoice_items_model.dart';
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
                        onChanged: (_) {
                          controller.filterInvoiceItems();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterInvoiceItems();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for invoice items',
                        button: newInvoiceItemButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<InvoiceItemsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allInvoiceItems.isEmpty) {
                          return const Center(child: Text('No Element'));
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required InvoiceItemsController controller,
}) {
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
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Name', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Description'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Price'),
        onSort: controller.onSort,
      ),
    ],
    rows:
        controller.filteredInvoiceItems.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allInvoiceItems.map<DataRow>((invoiceItems) {
            final invoiceItemsId = invoiceItems.id ?? '';
            return dataRowForTheTable(
              invoiceItems,
              context,
              constraints,
              invoiceItemsId,
              controller,
            );
          }).toList()
        : controller.filteredInvoiceItems.map<DataRow>((invoiceItems) {
            final invoiceItemsId = invoiceItems.id ?? '';
            return dataRowForTheTable(
              invoiceItems,
              context,
              constraints,
              invoiceItemsId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  InvoiceItemsModel invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  String invoiceItemsId,
  InvoiceItemsController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, invoiceItemsId, context),
            editSection(
              context,
              controller,
              invoiceItemsData,
              constraints,
              invoiceItemsId,
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.name ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.description ?? '',
          maxWidth: 300,
        ),
      ),
      DataCell(textForDataRowInTable(text: invoiceItemsData.price.toString())),
    ],
  );
}

IconButton deleteSection(
  InvoiceItemsController controller,
  String invoiceItemsId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The invoiceItems will be deleted permanently",
        onPressed: () {
          controller.deleteInvoiceItem(invoiceItemsId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  InvoiceItemsController controller,
  InvoiceItemsModel invoiceItemsData,
  BoxConstraints constraints,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      controller.description.text = invoiceItemsData.description ?? '';
      controller.name.text = invoiceItemsData.name ?? '';
      controller.price.text = (invoiceItemsData.price ?? '').toString();
      invoiceItemsDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                if (controller.name.text.isEmpty) {
                  showSnackBar('Alert', 'Please Enter Name');
                } else {
                  await controller.updateInvoiceItem(invoiceItemsId);
                }
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newInvoiceItemButton(
  BuildContext context,
  BoxConstraints constraints,
  InvoiceItemsController controller,
) {
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
