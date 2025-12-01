import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/issue_items_controller.dart';
import '../../../Models/issuing/base_model_for_issing_items.dart';
import '../../../consts.dart';
import '../../decimal_text_field.dart';
import '../auto_size_box.dart';
import 'add_new_issue_or_edit.dart';

Widget detailsTableSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required bool isConverter,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<IssueItemsController>(
      builder: (controller) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            isConverter: isConverter,
          ),
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required IssueItemsController controller,
  required bool isConverter,
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
              text: isConverter == false
                  ? 'Inventory Code'
                  : 'Converter Number',
            ),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 2.0),
            label: AutoSizedText(
              constraints: constraints,
              text: isConverter == false ? 'Inventory Name' : 'Converter Name',
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
          if (isConverter == false)
            ...controller.selectedInventeryItems
                .where((item) => item.isDeleted != true)
                .map((item) {
                  final itemId = item.id ?? '';
                  final originalIndex = controller.selectedInventeryItems
                      .indexWhere((r) => r.id == item.id);
                  return dataRowForTheTable(
                    item,
                    context,
                    constraints,
                    itemId,
                    controller,
                    isConverter,
                    originalIndex,
                  );
                })
          else
            ...controller.selectedConvertersDetails
                .where((item) => item.isDeleted != true)
                .map((item) {
                  final itemId = item.id ?? '';
                  final originalIndex = controller.selectedConvertersDetails
                      .indexWhere((r) => r.id == item.id);
                  return dataRowForTheTable(
                    item,
                    context,
                    constraints,
                    itemId,
                    controller,
                    isConverter,
                    originalIndex,
                  );
                }),

          // --- Totals row ---
          DataRow(
            selected: true,
            cells: [
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('Totals')),
              DataCell(
                textForDataRowInTable(
                  text: isConverter == false
                      ? controller.totalsForSelectedInventoryItemsDetails.value
                            .toString()
                      : controller.totalsForSelectedConvertersDetails.value
                            .toString(),
                  color: Colors.blue,
                  isBold: true,
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
  BaseModelForIssuingItems invoiceItemsData,
  BuildContext context,
  BoxConstraints constraints,
  String invoiceItemsId,
  IssueItemsController controller,
  bool isConverter,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(deleteSection(context, controller, invoiceItemsId, isConverter)),
      DataCell(
        textForDataRowInTable(
          text: isConverter == false
              ? invoiceItemsData.code ?? ''
              : invoiceItemsData.number ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: invoiceItemsData.name ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        (isConverter == false
                ? controller.editingIndexForInventoryDetails.value == index
                : controller.editingIndexForConvertersDetails.value == index)
            ? SizedBox(
                width: double.infinity,
                child: TextField(
                  inputFormatters: [DecimalTextInputFormatter()],
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  autofocus: true,
                  controller: TextEditingController(
                    text: invoiceItemsData.finalQuantity.toString(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    final submittedValue = value.trim().isEmpty ? '0.0' : value;
                    isConverter == false
                        ? controller.finishEditingForInventoryItems(
                            submittedValue,
                            index,
                          )
                        : controller.finishEditingForConverters(
                            submittedValue,
                            index,
                          );
                  },
                  onTapOutside: (_) {
                    isConverter == false
                        ? controller.editingIndexForInventoryDetails.value = -1
                        : controller.editingIndexForConvertersDetails.value =
                              -1;
                  },
                ),
              )
            : InkWell(
                onTap: () => controller.startEditing(isConverter, index),
                child: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      textForDataRowInTable(
                        isSelectable: false,
                        color: Colors.green,
                        isBold: true,
                        maxWidth: null,
                        text: invoiceItemsData.finalQuantity.toString(),
                      ),
                      Icon(Icons.edit_outlined, color: Colors.grey.shade700),
                    ],
                  ),
                ),
              ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${invoiceItemsData.lastPrice ?? ''}',
          color: Colors.red,
          isBold: true,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: '${invoiceItemsData.total ?? ''}',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
    ],
  );
}

Widget deleteSection(
  BuildContext context,
  IssueItemsController controller,
  String invoiceItemsId,
  bool isConverter,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: 'This will be deleted permanently',
        onPressed: () {
          isConverter == false
              ? controller.removeSelectedInventoryItems(invoiceItemsId)
              : controller.removeSelectedConvertersDetails(invoiceItemsId);
        },
      );
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}

ElevatedButton newItemsButton(
  BuildContext context,
  BoxConstraints constraints,
  IssueItemsController controller,
  bool isConverter,
) {
  return ElevatedButton(
    onPressed: () {
      if (isConverter == false) {
        controller.searchForInventoryItems.clear();
        controller.getAllInventeryItems();
      } else {
        controller.searchForConvertersDetails.clear();
        controller.getAllConvertersDetails();
      }
      dialog(
        constraints: constraints,
        context: context,
        dialogName: isConverter == false ? 'Inventery Items' : 'Converters',
        hintText: isConverter == false
            ? 'Search of items'
            : "Search for converters",
        controllerForSearchField: isConverter == false
            ? controller.searchForInventoryItems
            : controller.searchForConvertersDetails,
        onChangedForSearchField: (_) {
          isConverter == false
              ? controller.searchEngineForInverntoryItems()
              : controller.searchEngineForConvertersDetails();
        },
        onPressedForClearSearch: () {
          if (isConverter == false) {
            controller.searchForInventoryItems.clear();
            controller.searchEngineForInverntoryItems();
          } else {
            controller.searchForConvertersDetails.clear();
            controller.searchEngineForConvertersDetails();
          }
        },
        table: itemsTable(constraints, controller, context, isConverter),
      );
    },
    style: new2ButtonStyle,
    child: Text(
      isConverter == false ? 'New item' : 'New Converter',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Expanded itemsTable(
  BoxConstraints constraints,
  IssueItemsController controller,
  BuildContext context,
  bool isConverter,
) {
  return Expanded(
    child: GetX<IssueItemsController>(
      builder: (controller) {
        return controller.loadingItemsTable.value
            ? Center(child: loadingProcess)
            : controller.loadingItemsTable.isFalse &&
                  (isConverter == false
                      ? controller.allInventeryItems.isEmpty
                      : controller.allConvertersDetails.isEmpty)
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
                      border: TableBorder.symmetric(
                        outside: const BorderSide(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      showBottomBorder: true,
                      dataTextStyle: regTextStyle,
                      headingTextStyle: fontStyleForTableHeader,
                      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
                      columns: [
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: isConverter == false ? 'Code' : 'Number',
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
                            text: 'Quantity',
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Price',
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Total',
                          ),
                        ),
                      ],
                      rows: isConverter == false
                          // ---------------- INVENTORY MODE ----------------
                          ? (controller
                                        .searchForInventoryItems
                                        .value
                                        .text
                                        .isEmpty
                                    ? controller.allInventeryItems
                                    : controller.filteredInventeryItems)
                                .where(
                                  (r) => !controller.selectedInventeryItems.any(
                                    (sel) =>
                                        (sel.inventoryItemId == r.id) &&
                                        (sel.isDeleted != true),
                                  ),
                                )
                                .map((item) {
                                  final itemId = item.id ?? '';
                                  final index = controller.allInventeryItems
                                      .indexWhere((r) => r.id == itemId);
                                  return dataRowForTheItemTable(
                                    item,
                                    context,
                                    constraints,
                                    itemId,
                                    controller,
                                    index,
                                    isConverter,
                                  );
                                })
                                .toList()
                          // ---------------- CONVERTER MODE ----------------
                          : (controller
                                        .searchForInventoryItems
                                        .value
                                        .text
                                        .isEmpty
                                    ? controller.allConvertersDetails
                                    : controller.filteredConvertersDetails)
                                .where(
                                  (r) =>
                                      !controller.selectedConvertersDetails.any(
                                        (sel) =>
                                            (sel.id == r.id) &&
                                            (sel.isDeleted != true),
                                      ),
                                )
                                .map((item) {
                                  final itemId = item.id ?? '';
                                  final index = controller.allConvertersDetails
                                      .indexWhere((r) => r.id == itemId);
                                  return dataRowForTheItemTable(
                                    item,
                                    context,
                                    constraints,
                                    itemId,
                                    controller,
                                    index,
                                    isConverter,
                                  );
                                })
                                .toList(),
                    ),
                  ),
                ),
              );
      },
    ),
  );
}

DataRow dataRowForTheItemTable(
  BaseModelForIssuingItems itemData,
  BuildContext context,
  BoxConstraints constraints,
  String itemId,
  IssueItemsController controller,
  int index,
  bool isConverter,
) {
  return DataRow(
    onSelectChanged: (_) {
      if (isConverter == false) {
        controller.allInventeryItems[index].isSelected = true;
        controller.addSelectedInventoryItems();
      } else {
        controller.allConvertersDetails[index].isSelected = true;
        controller.addSelectedConvertersDetails();
      }
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          text: isConverter == false
              ? itemData.code ?? ''
              : itemData.number ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(text: itemData.name ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.finalQuantity.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.lastPrice.toString(),
          color: Colors.red,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.total.toString(),
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
    ],
  );
}
