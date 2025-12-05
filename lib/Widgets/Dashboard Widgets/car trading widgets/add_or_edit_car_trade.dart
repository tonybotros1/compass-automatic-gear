import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/car_trading_items_model.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../../main screen widgets/auto_size_box.dart';
import 'car_information_section.dart';
import 'item_dialog.dart';

Widget addNewCarTradeOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required BoxConstraints constraints,
}) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Car Information', style: fontStyle1),
                  ),
                  carInformation(context: context, constraints: constraints,controller: controller),
                  const SizedBox(height: 10),
                  labelContainer(lable: Text('Items', style: fontStyle1)),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: Container(
                decoration: containerDecor,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        searchBar(
                          onChanged: (_) {
                            controller.filterItems();
                          },
                          onPressedForClearSearch: () {
                            controller.searchForItems.value.clear();
                            controller.filterItems();
                          },
                          search: controller.searchForItems,
                          constraints: constraints,
                          context: context,
                          title: 'Search for Items',
                          button: newItemButton(context, controller),
                        ),
                        Expanded(
                          child: GetX<CarTradingDashboardController>(
                            builder: (controller) {
                              if (controller.addedItems.isEmpty) {
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
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8, right: 4),
        child: GetX<CarTradingDashboardController>(
          builder: (controller) {
            return Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Total Paid:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textForDataRowInTable(
                  text: '${controller.totalPays.value}',
                  color: Colors.red,
                  isBold: true,
                ),
                const Text(
                  'Total Received:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textForDataRowInTable(
                  text: '${controller.totalReceives.value}',
                  color: Colors.green,
                  isBold: true,
                ),
                const Text(
                  'Net:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textForDataRowInTable(
                  text: '${controller.totalNETs.value}',
                  color: Colors.blueGrey,
                  isBold: true,
                ),
              ],
            );
          },
        ),
      ),
    ],
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
}) {
  return DataTable(
    horizontalMargin: horizontalMarginForTable,
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 10,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Date', constraints: constraints),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Item'),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.start,

        label: AutoSizedText(constraints: constraints, text: 'Comments'),
      ),
      DataColumn(
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Paid'),
      ),
      DataColumn(
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Received'),
      ),
    ],
    rows:
        controller.filteredAddedItems.isEmpty &&
            controller.searchForItems.value.text.isEmpty
        ? controller.addedItems
              .where((item) => item.deleted == false)
              .map<DataRow>((item) {
                return dataRowForTheTable(
                  item,
                  context,
                  constraints,
                  controller,
                );
              })
              .toList()
        : controller.filteredAddedItems
              .where((item) => item.deleted == false)
              .map<DataRow>((item) {
                return dataRowForTheTable(
                  item,
                  context,
                  constraints,
                  controller,
                );
              })
              .toList(),
  );
}

DataRow dataRowForTheTable(
  CarTradingItemsModel itemData,
  context,
  constraints,
  CarTradingDashboardController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          children: [
            deleteSection(controller, context, itemData),
            editSection(context, controller, itemData, constraints),
          ],
        ),
      ),
      DataCell(Text(textToDate(itemData.date))),
      DataCell(Text(itemData.item.toString())),
      DataCell(Text(itemData.comment.toString())),
      DataCell(
        textForDataRowInTable(
          text: itemData.pay.toString(),
          isBold: true,
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.receive.toString(),
          isBold: true,
          color: Colors.green,
        ),
      ),
    ],
  );
}

IconButton deleteSection(
  CarTradingDashboardController controller,
  BuildContext context,
  CarTradingItemsModel itemData,
) {
  return IconButton(
    onPressed: () {
      final index = controller.addedItems.indexWhere(
        (item) => item.id == itemData.id,
      );
      final indexForFilteredItems = controller.filteredAddedItems.indexWhere(
        (item) => item.id == itemData.id,
      );
      if (index != -1) {
        controller.addedItems[index].deleted = true;
        controller.addedItems[index].modified = true;
        controller.addedItems[index].added = false;
        controller.itemsModified.value = true;
      }
      if (indexForFilteredItems != -1) {
        controller.filteredAddedItems[index].deleted = true;
        controller.filteredAddedItems[index].modified = true;
        controller.addedItems[index].added = false;
        controller.itemsModified.value = true;
      }
      controller.addedItems.refresh();
      controller.filteredAddedItems.refresh();
      controller.calculateTotals();
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  CarTradingDashboardController controller,
  CarTradingItemsModel itemData,
  constraints,
) {
  return IconButton(
    onPressed: () async {
      controller.item.text = itemData.item.toString();
      controller.itemId.value = itemData.itemId.toString();
      controller.pay.text = itemData.pay.toString();
      controller.receive.text = itemData.receive.toString();
      controller.comments.value.text = itemData.comment.toString();
      controller.itemDate.value.text = textToDate(itemData.date);
      itemDialog(
        isGeneralExpenses: false,
        isTrade: true,
        controller: controller,
        canEdit: true,
        onPressed: () {
          int index = controller.addedItems.indexWhere(
            (item) => item.id == itemData.id,
          );
          int indexForFilteredItems = controller.filteredAddedItems.indexWhere(
            (item) => item.id == itemData.id,
          );
          if (index != -1) {
            controller.addedItems[index] = CarTradingItemsModel(
              id: itemData.id,
              comment: controller.comments.value.text,
              date: controller.inputFormat.parse(
                controller.itemDate.value.text,
              ),
              item: controller.item.text,
              itemId: controller.itemId.value,
              pay: double.tryParse(controller.pay.value.text) ?? 0,
              receive: double.tryParse(controller.receive.value.text) ?? 0,
              modified: true,
              deleted: false,
            );
            controller.itemsModified.value = true;
          }
          if (indexForFilteredItems != -1) {
            controller.filteredAddedItems[index] = CarTradingItemsModel(
              id: itemData.id,
              comment: controller.comments.value.text,
              date: controller.inputFormat.parse(
                controller.itemDate.value.text,
              ),
              item: controller.item.text,
              itemId: controller.itemId.value,
              pay: double.tryParse(controller.pay.value.text) ?? 0,
              receive: double.tryParse(controller.receive.value.text) ?? 0,
              modified: true,
              deleted: false,
            );
            controller.itemsModified.value = true;
          }
          controller.calculateTotals();
          Get.back();
        },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newItemButton(
  BuildContext context,
  CarTradingDashboardController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.item.clear();
      controller.itemId.value = '';
      controller.pay.text = '0';
      controller.receive.text = '0';
      controller.comments.value.text = '';
      controller.itemDate.value.text = textToDate(DateTime.now());
      itemDialog(
        isGeneralExpenses: false,
        isTrade: true,
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addNewItem();
          controller.calculateTotals();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Line'),
  );
}
