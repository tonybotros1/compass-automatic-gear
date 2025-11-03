import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/inventory items/inventory_items_model.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Future<dynamic> showingAvailableItemsDialog({
  required String screenName,
  required BoxConstraints constraints,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: constraints.maxWidth / 1.5,
        height: 500,
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
                  closeButton,
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
                        SizedBox(
                          width: 400,
                          height: 50,
                          child: SearchBar(
                            trailing: [
                              IconButton(
                                onPressed: () {
                                  controller.searchForInventeryItems.clear();
                                  controller.filterInventeryItems();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            leading: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            hintText: 'Search for items',
                            hintStyle: WidgetStateProperty.all(
                              const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            controller: controller.searchForInventeryItems,
                            onChanged: (_) {
                              controller.filterInventeryItems();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: controller.loadingInventeryItems.isTrue
                              ? Center(child: loadingProcess)
                              : controller.loadingInventeryItems.isFalse &&
                                    controller.allInventeryItems.isEmpty
                              ? const Center(child: Text('No Data'))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth:
                                            constraints.maxWidth / 1.5 - 20,
                                      ),
                                      child: DataTable(
                                        showCheckboxColumn: false,
                                        horizontalMargin:
                                            horizontalMarginForTable,
                                        dataRowMaxHeight: 40,
                                        dataRowMinHeight: 30,
                                        columnSpacing: 5,
                                        showBottomBorder: true,
                                        dataTextStyle: regTextStyle,
                                        headingTextStyle:
                                            fontStyleForTableHeader,
                                        headingRowColor: WidgetStatePropertyAll(
                                          Colors.grey[300],
                                        ),
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
                                            (controller
                                                    .filteredInventeryItems
                                                    .isEmpty &&
                                                controller
                                                    .searchForInventeryItems
                                                    .value
                                                    .text
                                                    .isEmpty)
                                            ? List<DataRow>.generate(
                                                controller
                                                    .allInventeryItems
                                                    .length,
                                                (index) {
                                                  final item = controller
                                                      .allInventeryItems[index];

                                                  final itemId = item.id;

                                                  return dataRowForTheTable(
                                                    item,
                                                    constraints,
                                                    itemId,
                                                    controller,
                                                    index,
                                                  );
                                                },
                                              )
                                            : List<DataRow>.generate(
                                                controller
                                                    .filteredInventeryItems
                                                    .length,
                                                (index) {
                                                  final item = controller
                                                      .filteredInventeryItems[index];

                                                  final itemId = item.id;

                                                  return dataRowForTheTable(
                                                    item,
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
  constraints,
  id,
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
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(Text(itemDate.code)),
      DataCell(Text(itemDate.name)),
      DataCell(Text(itemDate.minQuantity.toString())),
    ],
  );
}
