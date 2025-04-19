import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Trading Controllers/car_trading_controller.dart';
import '../../consts.dart';
import '../Auth screens widgets/register widgets/search_bar.dart';
import '../main screen widgets/auto_size_box.dart';
import 'car_information_section.dart';
import 'item_dialog.dart';

Widget addNewTradeOrEdit({
  required BuildContext context,
  required CarTradingController controller,
  required bool canEdit,
  required BoxConstraints constraints,
}) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  labelContainer(
                      lable: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Car Information',
                        style: fontStyle1,
                      ),
                      GetX<CarTradingController>(builder: (controller) {
                        return controller.currentTradId.value == ''
                            ? SizedBox()
                            : ElevatedButton(
                                style: new2ButtonStyle,
                                onPressed: () {
                                  controller.changeStatus(
                                      controller.currentTradId.value, 'New');
                                  controller.status.value = 'New';
                                },
                                child: Text(
                                  'Change Status To New',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ));
                      })
                    ],
                  )),
                  carInformation(context: context, constraints: constraints),
                  const SizedBox(
                    height: 10,
                  ),
                  labelContainer(
                      lable: Text(
                    'Items',
                    style: fontStyle1,
                  )),
                ],
              ),
            ),
            SliverFillRemaining(
              // Tell the sliver that its child DOES provide its own scrolling.
              hasScrollBody: true,
              child: Container(
                  decoration: containerDecor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          searchBar(
                            search: controller.searchForItems,
                            constraints: constraints,
                            context: context,
                            controller: controller,
                            title: 'Search for Items',
                            button: newItemButton(context, controller),
                          ),
                          Expanded(child:
                              GetX<CarTradingController>(builder: (controller) {
                            if (controller.addedItems.isEmpty) {
                              return const Center(
                                child: Text('No Element'),
                              );
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
                          })),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8, right: 4),
        child: GetX<CarTradingController>(builder: (controller) {
          return Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total Paid:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textForDataRowInTable(
                  text: '${controller.totalPays.value}',
                  color: Colors.red,
                  isBold: true),
              Text(
                'Total Received:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textForDataRowInTable(
                  text: '${controller.totalReceives.value}',
                  color: Colors.green,
                  isBold: true),
              Text(
                'Net:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textForDataRowInTable(
                  text: '${controller.totalNETs.value}',
                  color: Colors.blueGrey,
                  isBold: true)
            ],
          );
        }),
      )
    ],
  );
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required CarTradingController controller}) {
  return DataTable(
    horizontalMargin: horizontalMarginForTable,
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
          text: 'Date',
          constraints: constraints,
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Item',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Paid',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Received',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Comments',
        ),
        // onSort: controller.onSort,
      ),
      const DataColumn(
        label: Text(''),
      ),
    ],
    rows: controller.filteredAddedItems.isEmpty &&
            controller.searchForItems.value.text.isEmpty
        ? controller.addedItems.map<DataRow>((item) {
            final itemData = item;
            return dataRowForTheTable(
                itemData, context, constraints, controller);
          }).toList()
        : controller.filteredAddedItems.map<DataRow>((item) {
            final itemData = item as Map<String, dynamic>;
            return dataRowForTheTable(
                itemData, context, constraints, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> itemData, context, constraints,
    CarTradingController controller) {
  return DataRow(cells: [
    DataCell(Text(itemData['date'])),
    DataCell(
        Text(controller.getdataName(itemData['item'], controller.allItems))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: itemData['pay']))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: itemData['receive']))),
    DataCell(Text(itemData['comment'])),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        editSection(context, controller, itemData, constraints),
        deleteSection(controller, context, itemData),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    CarTradingController controller, context, Map itemData) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        controller.addedItems
            .removeWhere((item) => item['id'] == itemData['id']);
        controller.calculateTotals();
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, CarTradingController controller,
    Map<String, dynamic> itemData, constraints) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        controller.item.text =
            controller.getdataName(itemData['item'], controller.allItems);
        controller.itemId.value = itemData['item'];
        controller.pay.text = itemData['pay'];
        controller.receive.text = itemData['receive'];
        controller.comments.value.text = itemData['comment'];
        controller.itemDate.value.text = itemData['date'];
        itemDialog(
            controller: controller,
            canEdit: true,
            onPressed: () {
              if (controller.item.value.text.isEmpty ||
                  controller.pay.value.text.isEmpty ||
                  controller.receive.value.text.isEmpty) {
                showSnackBar('Alert', 'Please fill all fields');
              } else {
                int index = controller.addedItems
                    .indexWhere((item) => item['id'] == itemData['id']);
                if (index != -1) {
                  controller.addedItems[index] = {
                    'id': itemData['id'],
                    'comment': controller.comments.value.text,
                    'date': controller.itemDate.value.text,
                    'item': controller.itemId.value,
                    'pay': controller.pay.value.text,
                    'receive': controller.receive.value.text,
                  };
                }
                Get.back();
              }
            });
      },
      child: const Text('Edit'));
}

ElevatedButton newItemButton(
    BuildContext context, CarTradingController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.item.clear();
      controller.itemId.value = '';
      controller.pay.text = '0';
      controller.receive.text = '0';
      controller.comments.value.text = '';
      controller.itemDate.value.text = textToDate(DateTime.now());
      itemDialog(
          controller: controller,
          canEdit: true,
          onPressed: () {
            if (controller.item.value.text.isEmpty ||
                controller.pay.value.text.isEmpty ||
                controller.receive.value.text.isEmpty) {
              showSnackBar('Alert', 'Please fill all fields');
            } else {
              controller.addNewItem();
            }
          });
    },
    style: newButtonStyle,
    child: const Text('New Line'),
  );
}
