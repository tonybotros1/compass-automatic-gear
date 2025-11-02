import 'package:datahubai/Models/inventory%20items/inventory_items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/inventery_items_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/inventery_items_widgets/items_dialog.dart';
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
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GetX<InventoryItemsController>(
                    init: InventoryItemsController(),
                    builder: (controller) {
                      return searchBar(
                        onChanged: (_) {
                          controller.filterItems();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterItems();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for items',
                        button: newCurrencyButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<InventoryItemsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allItems.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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
  required InventoryItemsController controller,
}) {
  return DataTable(
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
    rows:
        controller.filteredItems.isEmpty && controller.search.value.text.isEmpty
        ? controller.allItems.map<DataRow>((item) {
            final itemId = item.id;
            return dataRowForTheTable(
              item,
              context,
              constraints,
              itemId,
              controller,
            );
          }).toList()
        : controller.filteredItems.map<DataRow>((item) {
            final itemId = item.id;
            return dataRowForTheTable(
              item,
              context,
              constraints,
              itemId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  InventoryItemsModel itemData,
  context,
  constraints,
  itemId,
  InventoryItemsController controller,
) {
  return DataRow(
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
      DataCell(textForDataRowInTable(text: itemData.code, maxWidth: null)),
      DataCell(textForDataRowInTable(text: itemData.name, maxWidth: null)),
      DataCell(textForDataRowInTable(text: itemData.minQuantity.toString(),formatDouble: false)),
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
  constraints,
  itemId,
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
    child: const Text('New Currency'),
  );
}
