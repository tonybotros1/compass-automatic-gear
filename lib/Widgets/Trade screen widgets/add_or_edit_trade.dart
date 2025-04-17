import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
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
                      ElevatedButton(
                          style: new2ButtonStyle,
                          onPressed: () {
                            controller.changeStatus(
                                controller.currentTradId.value, 'New');
                            controller.status.value = 'New';
                          },
                          child: Text(
                            'Change Status To New',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ))
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
                child: GetX<CarTradingController>(
                  builder: (controller) {
                    return Padding(
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
                            Expanded(
                                child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: tableOfScreens(
                                  constraints: constraints,
                                  context: context,
                                  controller: controller,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
              Text(
                '${controller.totalPays.value}',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Received:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${controller.totalReceives.value}',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
              Text(
                'Total NETs:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${controller.totalNETs.value}',
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold))
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
            controller.search.value.text.isEmpty
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
    DataCell(textForDataRowInTable(text: itemData['pay'])),
    DataCell(textForDataRowInTable(text: itemData['receive'])),
    DataCell(Text(itemData['comment'])),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // editSection(context, controller, itemData, constraints),
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
    Map<String, dynamic> tradeData, constraints) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        // controller.currentTradId.value = tradeId;
        // await controller.loadValues(tradeData);
        // tradesDialog(
        //     controller: controller,
        //     canEdit: true,
        //     onPressed: controller.addingNewValue.value
        //         ? null
        //         : () {
        //             controller.editTrade(tradeId);
        //           });
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
      controller.itemDate.text = textToDate(DateTime.now());
      itemDialog(
          controller: controller,
          canEdit: true,
          onPressed: () {
            if (controller.item.value.text.isEmpty ||
                controller.pay.value.text.isEmpty ||
                controller.receive.value.text.isEmpty ||
                controller.comments.value.text.isEmpty) {
              showSnackBar('Alert', 'Please fill all fields');
            } else {
              controller.addNewItem();
            }
          });
    },
    style: newButtonStyle,
    child: const Text('New Trade'),
  );
}
