import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/capitals_outstanding_model.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import 'item_dialog.dart';

Widget addNewCapitalOrOutstandingOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required BoxConstraints constraints,
  required RxList<CapitalsAndOutstandingModel> map,
  required RxList<CapitalsAndOutstandingModel> filteredMap,
  required String collection,
  required Rx<TextEditingController> search,
}) {
  return Column(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                searchBar(
                  onChanged: (_) {
                    controller.filterCapitalsOrOutstandingOrGeneralExpenses(
                      search,
                      map,
                      filteredMap,
                      false,
                    );
                  },
                  onPressedForClearSearch: () {
                    search.value.clear();
                    controller.filterCapitalsOrOutstandingOrGeneralExpenses(
                      search,
                      map,
                      filteredMap,
                      false,
                    );
                  },
                  search: search,
                  constraints: constraints,
                  context: context,
                  title: 'Search for Items',
                  button: newItemButton(context, controller, collection, false),
                ),
                GetX<CarTradingDashboardController>(
                  builder: (controller) {
                    return Expanded(
                      child: expandableSummaryTable(
                        filteredMap.isEmpty && search.value.text.isEmpty
                            ? map
                            : filteredMap,
                        controller,
                        context,
                        collection,
                        constraints,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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

Map<String, List<CapitalsAndOutstandingModel>> groupByName(
  List<CapitalsAndOutstandingModel> list,
) {
  final map = <String, List<CapitalsAndOutstandingModel>>{};
  for (final item in list) {
    map.putIfAbsent(item.name, () => []).add(item);
  }
  return map;
}

Widget expandableSummaryTable(
  List<CapitalsAndOutstandingModel> list,
  CarTradingDashboardController controller,
  BuildContext context,
  String collection,
  BoxConstraints constraints,
) {
  final grouped = <String, List<CapitalsAndOutstandingModel>>{};
  for (final item in list) {
    grouped.putIfAbsent(item.name, () => []).add(item);
  }

  final names = grouped.keys.toList()..sort();

  return Column(
    // spacing: 5,
    children: [
      tableHeader(),
      Expanded(
        child: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            final name = names[index];
            final items = grouped[name]!
              ..sort((a, b) => b.date.compareTo(a.date));

            final paid = items.fold(0.0, (s, i) => s + i.pay);
            final received = items.fold(0.0, (s, i) => s + i.receive);
            final net = received - paid;

            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.grey.shade500),
                  ),
                  //  index == names.length - 1
                  //     ? null
                  //     : Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: ExpansionTile(
                  maintainState: true,
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: Colors.grey.shade200,
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  collapsedShape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                  ),
                  showTrailingIcon: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(name, style: cellsTableTextStyle),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      const Expanded(flex: 1, child: SizedBox()),
                      const Expanded(flex: 3, child: SizedBox()),
                      Expanded(child: _cell(paid, color: Colors.red)),
                      Expanded(child: _cell(received, color: Colors.green)),
                      Expanded(
                        child: _cell(net, color: Colors.blueGrey, bold: true),
                      ),
                    ],
                  ),
                  children: [
                    ...items.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  deleteSection(
                                    controller,
                                    context,
                                    item.id,
                                    collection,
                                  ),
                                  editSection(
                                    context,
                                    controller,
                                    item,
                                    constraints,
                                    collection,
                                    item.id,
                                    false,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                textToDate(item.date),
                                style: cellsTableTextStyle,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                item.accountName,
                                style: cellsTableTextStyle,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.comment,
                                style: cellsTableTextStyle,
                              ),
                            ),
                            Expanded(child: _cell(item.pay, color: Colors.red)),
                            Expanded(
                              child: _cell(item.receive, color: Colors.green),
                            ),
                            Expanded(
                              child: _cell(item.net, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      );
                    }),
                    // Row(children: [Text('Summary')]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget _cell(double value, {bool bold = false, Color color = Colors.grey}) {
  return Text(
    value.toStringAsFixed(2),
    textAlign: TextAlign.right,
    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
  );
}

Widget tableHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      color: coolColor,
      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
    ),
    child: Row(
      children: [
        Expanded(flex: 1, child: Text('Name', style: headerTableTextStyle)),
        Expanded(flex: 1, child: Text('Date', style: headerTableTextStyle)),
        Expanded(
          flex: 1,
          child: Text('Account Name', style: headerTableTextStyle),
        ),
        Expanded(flex: 3, child: Text('Comment', style: headerTableTextStyle)),
        Expanded(
          child: Text(
            'Paid',
            textAlign: TextAlign.right,
            style: headerTableTextStyle,
          ),
        ),
        Expanded(
          child: Text(
            'Received',
            textAlign: TextAlign.right,
            style: headerTableTextStyle,
          ),
        ),
        Expanded(
          child: Text(
            'Net',
            textAlign: TextAlign.right,
            style: headerTableTextStyle,
          ),
        ),
      ],
    ),
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
      controller.accountName.text = itemData.accountName;
      controller.accountNameId.value = itemData.accountNameId;
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
      controller.accountName.clear();
      controller.accountNameId.value = '';
      controller.pay.text = '';
      controller.receive.text = '';
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
