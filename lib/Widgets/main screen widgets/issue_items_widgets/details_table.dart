import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/issue_items_controller.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import 'add_new_issue_or_edit.dart';

Widget detailsTableSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allItems,
  required RxBool loadingItems,
  required String id,
  required String firstColumnName,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<IssueItemsController>(
      builder: (controller) {
        if (loadingItems.value && allItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            id: id,
            allItems: allItems,
            firstColumnName: firstColumnName,
          ),
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required constraints,
  required context,
  required IssueItemsController controller,
  required String id,
  required RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allItems,
  required String firstColumnName,
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
            columnWidth: const IntrinsicColumnWidth(flex: 0.5),

            label: AutoSizedText(constraints: constraints, text: ''),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 2.0),
            label: AutoSizedText(
              constraints: constraints,
              text: firstColumnName,
            ),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1.0),

            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Quantity'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1.0),

            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Price'),
          ),

          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1.0),

            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Total'),
          ),
        ],
        rows: [
          ...allItems.map<DataRow>((invoiceItems) {
            final invoiceItemsData = invoiceItems.data();
            final invoiceItemsId = invoiceItems.id;
            return dataRowForTheTable(
              invoiceItemsData,
              context,
              constraints,
              invoiceItemsId,
              controller,
              id,
            );
          }),
          DataRow(
            selected: true,
            cells: [
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(
                Align(alignment: Alignment.centerRight, child: Text('Totals')),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: textForDataRowInTable(text: '', color: Colors.blue),
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
  Map<String, dynamic> invoiceItemsData,
  context,
  constraints,
  String invoiceItemsId,
  IssueItemsController controller,
  String itemId,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(itemId, context, controller, invoiceItemsId),
            editSection(
              itemId,
              controller,
              invoiceItemsData,
              context,
              constraints,
              invoiceItemsId,
            ),
          ],
        ),
      ),
      DataCell(textForDataRowInTable(text: '', maxWidth: null)),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(text: '${invoiceItemsData['quantity']}'),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(text: '${invoiceItemsData['price']}'),
        ),
      ),

      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(text: '${invoiceItemsData['total']}'),
        ),
      ),
    ],
  );
}

Widget deleteSection(
  String itemId,
  context,
  IssueItemsController controller,
  invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      // if (controller.jobStatus1.value == 'New') {
      //   alertDialog(
      //       context: context,
      //       content: 'This will be deleted permanently',
      //       onPressed: () {
      //         controller.deleteInvoiceItem(
      //             controller.curreentJobCardId.value != ''
      //                 ? controller.curreentJobCardId.value
      //                 : itemId,
      //             invoiceItemsId);
      //       });
      // } else {
      //   showSnackBar('Alert', 'Only New Jobs Allowed');
      // }
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}

Widget editSection(
  String itemId,
  IssueItemsController controller,
  Map<String, dynamic> invoiceItemsData,
  context,
  constraints,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      // if (controller.jobStatus1.value == 'New') {
      //   controller.invoiceItemNameId.value = invoiceItemsData['name'];
      //   controller.invoiceItemName.text = controller.getdataName(
      //       invoiceItemsData['name'],
      //       controller.allInvoiceItemsFromCollection);
      //   controller.lineNumber.text =
      //       (invoiceItemsData['line_number'] ?? '').toString();
      //   controller.description.text = invoiceItemsData['description'];
      //   controller.quantity.text = invoiceItemsData['quantity'];
      //   controller.price.text = invoiceItemsData['price'];
      //   controller.amount.text = invoiceItemsData['amount'];
      //   controller.discount.text = invoiceItemsData['discount'];
      //   controller.total.text = invoiceItemsData['total'];
      //   controller.vat.text = invoiceItemsData['vat'];
      //   controller.net.text = invoiceItemsData['net'];
      //   invoiceItemsForJobDialog(
      //       itemId: itemId,
      //       controller: controller,
      //       constraints: constraints,
      //       onPressed: controller.addingNewinvoiceItemsValue.value
      //           ? null
      //           : () {
      //               controller.editInvoiceItem(  controller.curreentJobCardId.value != ''
      //                 ? controller.curreentJobCardId.value
      //                 : itemId, invoiceItemsId);
      //             });
      // } else {
      //   showSnackBar('Alert', 'Only New Jobs Allowed');
      // }
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}

ElevatedButton newItemsButton(
  BuildContext context,
  BoxConstraints constraints,
  IssueItemsController controller,
  String id,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.canAddItemsAndConverter.isTrue) {
        if (controller.status.value == 'New') {
          controller.getAllInventeryItems();
          dialog(
            constraints: constraints,
            context: context,
            dialogName: 'Inventery Items',
            hintText: 'Search of items',
            controllerForSearchField: controller.searchForItems,
            onChangedForSearchField: (_) {},
            onPressedForClearSearch: () {
              controller.searchForItems.clear();
            },
            table: itemsTable(constraints, controller, context),
          );
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

Expanded itemsTable(
  BoxConstraints constraints,
  IssueItemsController controller,
  BuildContext context,
) {
  return Expanded(
    child: GetX<IssueItemsController>(
      builder: (controller) {
        return controller.loadingItemsTable.value
            ? Center(child: loadingProcess)
            : controller.loadingItemsTable.isFalse &&
                  controller.allInventeryItems.isEmpty
            ? const Center(child: Text('No Data'))
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth / 1.5 - 20,
                    ),
                    child: DataTable(
                      showCheckboxColumn: false,
                      horizontalMargin: horizontalMarginForTable,
                      dataRowMaxHeight: 40,
                      dataRowMinHeight: 30,
                      columnSpacing: 5,
                      showBottomBorder: true,
                      dataTextStyle: regTextStyle,
                      headingTextStyle: fontStyleForTableHeader,
                      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
                      columns: [
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Code',
                          ),
                        ),
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Name',
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Min.',
                          ),
                        ),
                      ],
                      rows:
                          (controller.filteredInventeryItems.isEmpty &&
                              controller.searchForItems.value.text.isEmpty)
                          ? List<DataRow>.generate(
                              controller.allInventeryItems.length,
                              (index) {
                                final item =
                                    controller.allInventeryItems[index];
                                final itemData =
                                    item.data() as Map<String, dynamic>;
                                final itemId = item.id;

                                return dataRowForTheItemTable(
                                  itemData,
                                  context,
                                  constraints,
                                  itemId,
                                  controller,
                                  index,
                                );
                              },
                            )
                          : List<DataRow>.generate(
                              controller.filteredInventeryItems.length,
                              (index) {
                                final item =
                                    controller.filteredInventeryItems[index];
                                final itemData =
                                    item.data() as Map<String, dynamic>;
                                final itemId = item.id;

                                return dataRowForTheItemTable(
                                  itemData,
                                  context,
                                  constraints,
                                  itemId,
                                  controller,
                                  index,
                                );
                              },
                            ),
                    ),
                  ),
                ),
              );
      },
    ),
  );
}

DataRow dataRowForTheItemTable(
  Map<String, dynamic> itemData,
  context,
  constraints,
  itemId,
  IssueItemsController controller,
  int index,
) {
  return DataRow(
    onSelectChanged: (_) {
      // Get.back();
      controller.getItemDetails(itemId);
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      // Alternate row colors
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(Text(itemData['code'] ?? '')),
      DataCell(Text(itemData['name'] ?? '')),
      DataCell(Text(itemData['min_quantity'].toString())),
    ],
  );
}
