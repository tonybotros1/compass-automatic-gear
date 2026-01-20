import 'package:datahubai/Models/inventory%20items/inventory_items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/inventery_items_controller.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/inventery_items_widgets/items_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class InventeryItems extends StatelessWidget {
  const InventeryItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<InventoryItemsController>(
                        init: InventoryItemsController(),
                        builder: (controller) {
                          return Row(
                            spacing: 10,
                            children: [
                              myTextFormFieldWithBorder(
                                width: 300,
                                labelText: 'Code',
                                controller: controller.inventoryCodeFilter.value,
                              ),
                              myTextFormFieldWithBorder(
                                width: 300,
                                labelText: 'Name',
                                controller: controller.inventoryNameFilter.value,
                              ),
                              myTextFormFieldWithBorder(
                                width: 170,
                                labelText: 'Min. Quantity',
                                controller:
                                    controller.inventoryMinQuantityFilter.value,
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          GetX<InventoryItemsController>(
                            builder: (controller) {
                              return ElevatedButton(
                                style: findButtonStyle,
                                onPressed: controller.isScreenLoding.isFalse
                                    ? () async {
                                        controller
                                            .filterSearchFirInventoryItems();
                                      }
                                    : null,
                                child: controller.isScreenLoding.isFalse
                                    ? Text(
                                        'Find',
                                        style: fontStyleForElevatedButtons,
                                      )
                                    : loadingProcess,
                              );
                            },
                          ),
                          GetBuilder<InventoryItemsController>(
                            builder: (controller) {
                              return newCurrencyButton(
                                context,
                                constraints,
                                controller,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GetX<InventoryItemsController>(
                    builder: (controller) {
                      return Container(
                        width: constraints.maxWidth,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        child: tableOfScreens(
                          constraints: constraints,
                          context: context,
                          controller: controller,
                        ),
                      );
                    },
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
  required InventoryItemsController controller,
}) {
  return PaginatedDataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    rowsPerPage: controller.allItems.length <= 12
        ? 12
        : controller.allItems.length >= 30
        ? 30
        : controller.allItems.length,

    columns: [
      const DataColumn(
        columnWidth: IntrinsicColumnWidth(flex: .5),
        label: Text(''),
      ),
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 1),
        label: AutoSizedText(text: 'Code', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 2),
        label: AutoSizedText(constraints: constraints, text: 'Name'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        columnWidth: const IntrinsicColumnWidth(flex: 1),
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Min. Quantity'),
        // onSort: controller.onSort,
      ),
    ],
    source: CardDataSource(
      cards: controller.allItems.isEmpty ? [] : controller.allItems,
      context: Get.context!,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  InventoryItemsModel itemData,
  BuildContext context,
  BoxConstraints constraints,
  String itemId,
  InventoryItemsController controller,
  int index,
) {
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return index % 2 != 0 ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(
        Row(
          spacing: 5,
          children: [
            deleteSection(controller, itemId, context),
            editSection(context, controller, itemData, constraints, itemId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.code,
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.name,
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.minQuantity.toString(),
          formatDouble: false,
        ),
      ),
    ],
  );
}

IconButton deleteSection(InventoryItemsController controller, itemId, context) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The item will be deleted permanently",
        onPressed: () {
          controller.deleteItem(itemId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  InventoryItemsController controller,
  InventoryItemsModel itemData,
  BoxConstraints constraints,
  String itemId,
) {
  return IconButton(
    onPressed: () {
      controller.code.text = itemData.code;
      controller.name.text = itemData.name;
      controller.minQuantity.text = itemData.minQuantity.toString();
      itemsDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.editItem(itemId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newCurrencyButton(
  BuildContext context,
  BoxConstraints constraints,
  InventoryItemsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.code.clear();
      controller.name.clear();
      controller.minQuantity.clear();
      itemsDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                controller.addNewItem();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Item'),
  );
}

class CardDataSource extends DataTableSource {
  final List<InventoryItemsModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final InventoryItemsController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final item = cards[index];
    final itemId = item.id;

    return dataRowForTheTable(
      item,
      context,
      constraints,
      itemId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
