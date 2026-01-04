import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/inventory items/inventory_items_model.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import '../auto_size_box.dart';

Future<dynamic> showingAvailableItemsDialog({
  required String screenName,
  required BoxConstraints constraints,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: constraints.maxWidth / 1.5,
        height: 810,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: mainColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(screenName, style: fontStyleForScreenNameUsedInButtons),
                  const Spacer(),
                  closeIcon(),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 10,
                ),
                child: GetX<ReceivingController>(
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                myTextFormFieldWithBorder(
                                  width: 300,
                                  labelText: 'Code',
                                  controller:
                                      controller.inventoryCodeFilter.value,
                                ),
                                myTextFormFieldWithBorder(
                                  width: 300,
                                  labelText: 'Name',
                                  controller:
                                      controller.inventoryNameFilter.value,
                                ),
                                myTextFormFieldWithBorder(
                                  width: 170,
                                  labelText: 'Min. Quantity',
                                  controller: controller
                                      .inventoryMinQuantityFilter
                                      .value,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: findButtonStyle,
                              onPressed:
                                  controller.loadingInventeryItems.isFalse
                                  ? () async {
                                      controller
                                          .filterSearchFirInventoryItems();
                                    }
                                  : null,
                              child: controller.loadingInventeryItems.isFalse
                                  ? Text(
                                      'Find',
                                      style: fontStyleForElevatedButtons,
                                    )
                                  : loadingProcess,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: PaginatedDataTable(
                                showCheckboxColumn: false,
                                horizontalMargin: horizontalMarginForTable,
                                dataRowMaxHeight: 40,
                                dataRowMinHeight: 30,
                                columnSpacing: 5,
                                rowsPerPage: 13,
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
                                source: CardDataSource(
                                  cards: controller.allInventeryItems.isEmpty
                                      ? []
                                      : controller.allInventeryItems,
                                  context: Get.context!,
                                  constraints: constraints,
                                  controller: controller,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  InventoryItemsModel itemDate,
  BoxConstraints constraints,
  String id,
  ReceivingController controller,
  int index,
) {
  return DataRow(
    onSelectChanged: (_) {
      Get.back();
      controller.selectedInventeryItemID.value = id;
      controller.itemCode.value.text = itemDate.code;
      controller.itemName.value.text = itemDate.name;
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      return index % 2 != 0 ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(Text(itemDate.code)),
      DataCell(Text(itemDate.name)),
      DataCell(Text(itemDate.minQuantity.toString())),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<InventoryItemsModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final ReceivingController controller;

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

    return dataRowForTheTable(item, constraints, itemId, controller, index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
