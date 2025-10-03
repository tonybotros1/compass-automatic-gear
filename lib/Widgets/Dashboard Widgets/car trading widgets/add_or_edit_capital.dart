import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../../main screen widgets/auto_size_box.dart';
import 'item_dialog.dart';

Widget addNewCapitalOrOutstandingOrGeneralExpensesOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required BoxConstraints constraints,
  required RxList map,
  required RxList filteredMap,
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
                        onChanged: (_) {
                          controller
                              .filterCapitalsOrOutstandingOrGeneralExpenses(
                                search,
                                map,
                                filteredMap,
                                isGeneralExpenses,
                              );
                        },
                        onPressedForClearSearch: () {
                          search.value.clear();
                          controller
                              .filterCapitalsOrOutstandingOrGeneralExpenses(
                                search,
                                map,
                                filteredMap,
                                isGeneralExpenses,
                              );
                        },
                        search: search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for Items',
                        button: newItemButton(
                          context,
                          controller,
                          collection,
                          isGeneralExpenses,
                        ),
                      ),
                      Expanded(
                        child: GetX<CarTradingDashboardController>(
                          builder: (controller) {
                            if (controller.isCapitalLoading.isTrue &&
                                map.isEmpty) {
                              return Center(child: loadingProcess);
                            } else if (map.isEmpty) {
                              return const Center(child: Text('No Element'));
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
                                  isGeneralExpenses: isGeneralExpenses,
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
  required RxList allMap,
  required RxList filteredMap,
  required String collection,
  required Rx<TextEditingController> search,
  required CarTradingDashboardController controller,
  required bool isGeneralExpenses,
}) {
  return DataTable(
    horizontalMargin: horizontalMarginForTable,
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
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
        label: AutoSizedText(
          constraints: constraints,
          text: isGeneralExpenses == true ? 'Item' : 'Name',
        ),
      ),
      DataColumn(
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
    rows: filteredMap.isEmpty && search.value.text.isEmpty
        ? allMap.map<DataRow>((entry) {
            final capitalId = entry.id;
            return dataRowForTheTable(
              entry,
              context,
              constraints,
              controller,
              capitalId,
              collection,
              isGeneralExpenses,
            );
          }).toList()
        : filteredMap.map<DataRow>((entry) {
            final capitalId = entry.id;
            return dataRowForTheTable(
              entry,
              context,
              constraints,
              controller,
              capitalId,
              collection,
              isGeneralExpenses,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  dynamic itemData,
  context,
  constraints,
  CarTradingDashboardController controller,
  String capitalId,
  String collection,
  bool isGeneralExpenses,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            deleteSection(controller, context, capitalId, collection),
            editSection(
              context,
              controller,
              itemData,
              constraints,
              collection,
              capitalId,
              isGeneralExpenses,
            ),
          ],
        ),
      ),
      DataCell(Text(textToDate(itemData.date))),
      DataCell(
        Text(isGeneralExpenses == false ? itemData.name : itemData.item),
      ),
      DataCell(Text(itemData.comment)),
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
  context,
  String capitalId,
  String collection,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "Theis will be deleted permanently",
        onPressed: () {
          controller.deleteCapitalOrOutstandingOrGeneralExpenses(
            collection,
            capitalId,
          );
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  CarTradingDashboardController controller,
  dynamic itemData,
  constraints,
  String collection,
  String capitalId,
  bool isGeneralExpenses,
) {
  return IconButton(
    onPressed: () async {
      if (isGeneralExpenses == true) {
        controller.item.text = itemData.item;
        controller.itemId.value = itemData.itemId;
      } else {
        controller.name.text = itemData.name;
        controller.nameId.value = itemData.nameId;
      }
      controller.pay.text = itemData.pay.toString();
      controller.receive.text = itemData.receive.toString();
      controller.comments.value.text = itemData.comment;
      controller.itemDate.value.text = textToDate(itemData.date);
      itemDialog(
        isGeneralExpenses: isGeneralExpenses,
        isTrade: false,
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.updateCapitalOrOutstandingOrGeneralExpenses(
            collection,
            capitalId,
          );
        },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newItemButton(
  BuildContext context,
  CarTradingDashboardController controller,
  String collection,
  bool isGeneralExpenses,
) {
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
          controller.addNewCapitalOrOutstandingOrGeneralExpenses(collection);
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Line'),
  );
}
