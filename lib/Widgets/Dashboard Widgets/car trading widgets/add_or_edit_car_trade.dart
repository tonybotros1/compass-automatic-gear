import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/car_trading_items_model.dart';
import '../../../Models/car trading/car_trading_purchase_agreement_model.dart';
import '../../../consts.dart';
import '../../main screen widgets/auto_size_box.dart';
import 'buy_sell_section.dart';
import 'car_information_section.dart';
import 'item_dialog.dart';
import 'note_section.dart';
import 'sales_agreement_item_dialog.dart';

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text('Car Information', style: fontStyle1),
                            ),
                            carInformation(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text('Buy / Sell', style: fontStyle1),
                            ),
                            buySellSection(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text('Note', style: fontStyle1),
                            ),
                            noteSection(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: Container(
                decoration: containerDecor,
                child: DefaultTabController(
                  length: controller.carsTabs.length,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: BoxBorder.fromLTRB(
                            top: const BorderSide(color: Colors.grey),
                            bottom: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: TabBar(
                          onTap: (i) {
                            if (i == 0) {
                              controller.itemsPageName.value = 'items';
                            } else {
                              controller.itemsPageName.value =
                                  'purchase agreement items';
                            }
                          },
                          unselectedLabelColor: Colors.grey,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          indicatorColor: mainColor,
                          labelColor: mainColor,
                          splashBorderRadius: BorderRadius.circular(5),
                          dividerColor: Colors.transparent,

                          tabs: controller.carsTabs,
                        ),
                      ),

                      Expanded(
                        child: TabBarView(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      newItemButton(context, controller),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GetX<CarTradingDashboardController>(
                                    builder: (controller) {
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
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      newItemButtonForPurchaseAgreement(
                                        context,
                                        controller,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GetX<CarTradingDashboardController>(
                                    builder: (controller) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SizedBox(
                                          width: constraints.maxWidth,
                                          child:
                                              tableOfScreensForSalesAgreement(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //  Expanded(
                //   child: GetX<CarTradingDashboardController>(
                //     builder: (controller) {
                //       return SingleChildScrollView(
                //         scrollDirection: Axis.vertical,
                //         child: SizedBox(
                //           width: constraints.maxWidth,
                //           child: tableOfScreens(
                //             constraints: constraints,
                //             context: context,
                //             controller: controller,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8, right: 4),
        child: GetX<CarTradingDashboardController>(
          builder: (controller) {
            return controller.itemsPageName.value.toLowerCase() == 'items'
                ? Row(
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
                  )
                : Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Total Amount:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textForDataRowInTable(
                        text:
                            '${controller.totalPurchaseAgreementAmount.value}',
                        color: Colors.green,
                        isBold: true,
                      ),
                      const Text(
                        'Total Down Payment:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textForDataRowInTable(
                        text:
                            '${controller.totalPurchaseAgreementDownPayment.value}',
                        color: Colors.red,
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
    columns: [
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Date', constraints: constraints),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Item'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Account Name'),
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
      DataCell(Text(itemData.accountName.toString())),
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

IconButton deleteSectionForPurchaseAgreement(
  CarTradingDashboardController controller,
  BuildContext context,
  CarTradingPurchaseAgreementModel itemData,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: 'Are you sure you want to delete purchase agreement item?',
        onPressed: () async {
          await controller.deletePurchaseAgreementItem(itemData.id ?? '');
          controller.calculatePurchaseAgreementTotals();
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton printeSectionForPurchaseAgreement(
  CarTradingDashboardController controller,
  BuildContext context,
  CarTradingPurchaseAgreementModel itemData,
) {
  return IconButton(
    onPressed: () {
      controller.printPurchaseAgreement(itemData);
    },
    icon: printIcons,
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
      controller.accountName.text = itemData.accountName ?? '';
      controller.accountNameId.value = itemData.accountNameId ?? '';
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
              accountName: controller.accountName.text,
              accountNameId: controller.accountNameId.value,
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
              accountName: controller.accountName.text,
              accountNameId: controller.accountNameId.value,
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

IconButton editSectionForPurchaseAgreement(
  BuildContext context,
  CarTradingDashboardController controller,
  CarTradingPurchaseAgreementModel itemData,
  BoxConstraints constraints,
) {
  return IconButton(
    onPressed: () async {
      controller.agreementNumber.text = itemData.agreementNumber ?? '';
      controller.agreementdate.text = textToDate(itemData.agreementDate);
      controller.buyerName.text = itemData.buyerName ?? '';
      controller.buyerID.text = itemData.buyerID ?? '';
      controller.buyerEmail.text = itemData.buyerEmail ?? '';
      controller.buyerPhone.text = itemData.buyerPhone ?? '';
      controller.sellerName.text = itemData.sellerName ?? '';
      controller.sellerID.text = itemData.sellerID ?? '';
      controller.sellerEmail.text = itemData.sellerEmail ?? '';
      controller.sellerPhone.text = itemData.sellerPhone ?? '';
      controller.agreementTotal.text = itemData.amount?.toString() ?? '0';
      controller.agreementdownpayment.text =
          itemData.aownpayment?.toString() ?? '0';
      controller.agreementNote.text = itemData.note ?? '';
      salesAgreementItemDialog(
        controller: controller,
        canEdit: true,
        onPressed: () async {
          await controller.updatePurchaseAgreementItem(itemData.id ?? '');
          controller.calculatePurchaseAgreementTotals();
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
      controller.pay.text = '';
      controller.receive.text = '';
      controller.accountName.clear();
      controller.accountNameId.value = '';
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

Widget tableOfScreensForSalesAgreement({
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
    columns: [
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Agreement No.', constraints: constraints),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Agreement Date'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Seller Name'),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.start,

        label: AutoSizedText(constraints: constraints, text: 'Buyer Name'),
      ),
      DataColumn(
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Total Amount'),
      ),
      DataColumn(
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Downpayment'),
      ),
    ],
    rows:
        controller.filteredPurchaseAgreementAddedItems.isEmpty &&
            controller.searchForItems.value.text.isEmpty
        ? controller.purchaseAgreementAddedItems
              .where((item) => item.deleted == false)
              .map<DataRow>((item) {
                return dataRowForTheTableForPurchaseAgreemnt(
                  item,
                  context,
                  constraints,
                  controller,
                );
              })
              .toList()
        : controller.filteredPurchaseAgreementAddedItems
              .where((item) => item.deleted == false)
              .map<DataRow>((item) {
                return dataRowForTheTableForPurchaseAgreemnt(
                  item,
                  context,
                  constraints,
                  controller,
                );
              })
              .toList(),
  );
}

DataRow dataRowForTheTableForPurchaseAgreemnt(
  CarTradingPurchaseAgreementModel itemData,
  BuildContext context,
  BoxConstraints constraints,
  CarTradingDashboardController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          children: [
            deleteSectionForPurchaseAgreement(controller, context, itemData),
            editSectionForPurchaseAgreement(
              context,
              controller,
              itemData,
              constraints,
            ),
            printeSectionForPurchaseAgreement(controller, context, itemData),
          ],
        ),
      ),
      DataCell(Text(itemData.agreementNumber ?? '')),
      DataCell(Text(textToDate(itemData.agreementDate))),
      DataCell(Text(itemData.sellerName.toString())),
      DataCell(Text(itemData.buyerName.toString())),
      DataCell(
        textForDataRowInTable(
          text: itemData.amount?.toString() ?? '0',
          isBold: true,
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: itemData.aownpayment?.toString() ?? "0",
          isBold: true,
          color: Colors.red,
        ),
      ),
    ],
  );
}

ElevatedButton newItemButtonForPurchaseAgreement(
  BuildContext context,
  CarTradingDashboardController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.agreementNumber.clear();
      controller.agreementdate.text = textToDate(DateTime.now());
      controller.buyerName.text = '';
      controller.buyerID.text = '';
      controller.buyerEmail.text = '';
      controller.buyerPhone.text = '';
      controller.sellerName.text = 'ISSA HASSAN YAKOUB';
      controller.sellerID.text = '784-1988-2628387-5';
      controller.sellerEmail.text = 'sales@compass-at.com';
      controller.sellerPhone.text = '054 567 6644';
      controller.agreementTotal.clear();
      controller.agreementdownpayment.clear();
      controller.agreementNote.clear();
      salesAgreementItemDialog(
        controller: controller,
        canEdit: true,
        onPressed: () async {
          await controller.addNewPurchaseAgreementItem();
          controller.calculatePurchaseAgreementTotals();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Sales Agreement'),
  );
}
