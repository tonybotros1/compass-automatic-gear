import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Trading Controllers/car_trading_controller.dart';
import '../../consts.dart';
import '../Auth screens widgets/register widgets/search_bar.dart';
import '../main screen widgets/auto_size_box.dart';
import 'item_dialog.dart';

Widget addNewCapitalOrOutstandingOrGeneralExpensesOrEdit({
  required BuildContext context,
  required CarTradingController controller,
  required bool canEdit,
  required BoxConstraints constraints,
  required RxList<DocumentSnapshot<Object?>> map,
  required RxList<DocumentSnapshot<Object?>> filteredMap,
  required String collection,
  required Rx<TextEditingController> search,
  required bool isGeneralExpenses,
}) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
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
                        search: search,
                        constraints: constraints,
                        context: context,
                        // controller: controller,
                        title: 'Search for Items',
                        button: newItemButton(
                            context, controller, collection, isGeneralExpenses),
                      ),
                      Expanded(child:
                          GetX<CarTradingController>(builder: (controller) {
                        if (map.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfScreens(
                                search: search,
                                collection: collection,
                                allMap: map,
                                filteredMap: filteredMap,
                                constraints: constraints,
                                context: context,
                                controller: controller,
                                isGeneralExpenses: isGeneralExpenses),
                          ),
                        );
                      })),
                    ],
                  ),
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
              const Text(
                'Total Paid:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textForDataRowInTable(
                  text: '${controller.totalPays.value}',
                  color: Colors.red,
                  isBold: true),
              const Text(
                'Total Received:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textForDataRowInTable(
                  text: '${controller.totalReceives.value}',
                  color: Colors.green,
                  isBold: true),
              const Text(
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
    {required BoxConstraints constraints,
    required BuildContext context,
    required RxList<DocumentSnapshot<Object?>> allMap,
    required RxList<DocumentSnapshot<Object?>> filteredMap,
    required String collection,
    required Rx<TextEditingController> search,
    required CarTradingController controller,
    required bool isGeneralExpenses}) {
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
          text: isGeneralExpenses == true ? 'Item' : 'Name',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.end,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Paid',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.end,

        label: AutoSizedText(
          constraints: constraints,
          text: 'Received',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,

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
    rows: filteredMap.isEmpty && search.value.text.isEmpty
        ? allMap.asMap().entries.map<DataRow>((entry) {
            final item = entry.value;
            final itemData = item.data() as Map<String, dynamic>;
            final capitalId = item.id;
            return dataRowForTheTable(itemData, context, constraints,
                controller, capitalId, collection, isGeneralExpenses);
          }).toList()
        : filteredMap.asMap().entries.map<DataRow>((entry) {
            final item = entry.value;
            final itemData = item.data() as Map<String, dynamic>;
            final capitalId = item.id;
            return dataRowForTheTable(itemData, context, constraints,
                controller, capitalId, collection, isGeneralExpenses);
          }).toList(),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> itemData,
    context,
    constraints,
    CarTradingController controller,
    String capitalId,
    String collection,
    bool isGeneralExpenses) {
  return DataRow(cells: [
    DataCell(Text(itemData['date'])),
    DataCell(
      Text(
        isGeneralExpenses == false
            ? controller.getdataName(
                (itemData['name'] ?? '').toString(),
                controller.allNames,
              )
            : controller.getdataName(
                (itemData['item'] ?? '').toString(),
                controller.allItems,
              ),
      ),
    ),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(
            text: itemData['pay'], isBold: true, color: Colors.red))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(
            text: itemData['receive'], isBold: true, color: Colors.green))),
    DataCell(Text(itemData['comment'])),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        editSection(context, controller, itemData, constraints, collection,
            capitalId, isGeneralExpenses),
        deleteSection(controller, context, itemData, capitalId, collection),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(CarTradingController controller, context,
    Map itemData, String capitalId, String collection) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            content: "Theis will be deleted permanently",
            onPressed: () {
              controller.deleteCapitalOrOutstandingOrGeneralExpenses(
                  collection, capitalId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(
    BuildContext context,
    CarTradingController controller,
    Map<String, dynamic> itemData,
    constraints,
    String collection,
    String capitalId,
    bool isGeneralExpenses) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        if (isGeneralExpenses == true) {
          controller.item.text =
              controller.getdataName(itemData['item'], controller.allItems);
          controller.itemId.value = itemData['item'];
        } else {
          controller.name.text =
              controller.getdataName(itemData['name'], controller.allNames);
          controller.nameId.value = itemData['name'];
        }
        controller.pay.text = itemData['pay'];
        controller.receive.text = itemData['receive'];
        controller.comments.value.text = itemData['comment'];
        controller.itemDate.value.text = itemData['date'];
        itemDialog(
            isGeneralExpenses: isGeneralExpenses,
            isTrade: false,
            controller: controller,
            canEdit: true,
            onPressed: () {
              controller.updateCapitalsOrOutstandingOrGeneralExpenses(
                  collection, capitalId, isGeneralExpenses);
            });
      },
      child: const Text('Edit'));
}

ElevatedButton newItemButton(
    BuildContext context,
    CarTradingController controller,
    String collection,
    bool isGeneralExpenses) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.nameId.value = '';
      controller.item.clear();
      controller.itemId.value = '';
      controller.pay.text = '0';
      controller.receive.text = '0';
      controller.comments.value.text = '';
      controller.itemDate.value.text = textToDate(DateTime.now());
      itemDialog(
          isGeneralExpenses: isGeneralExpenses,
          isTrade: false,
          controller: controller,
          canEdit: true,
          onPressed: () {
            controller.addNewCapitalsOrOutstandingOrGeneralExpenses(
                collection, isGeneralExpenses);
          });
    },
    style: newButtonStyle,
    child: const Text('New Line'),
  );
}
