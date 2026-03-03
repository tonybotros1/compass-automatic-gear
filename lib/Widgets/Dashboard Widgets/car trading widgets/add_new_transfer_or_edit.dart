import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/transfer_model.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../../main screen widgets/auto_size_box.dart';
import 'transfer_item_dialog.dart';

Widget addNewTransferOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required BoxConstraints constraints,
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
                          controller.filterTransfers();
                        },
                        onPressedForClearSearch: () {
                          controller.searchForTransfers.value.clear();
                          controller.filterTransfers();
                        },
                        search: controller.searchForTransfers,
                        constraints: constraints,
                        context: context,
                        title: 'Search for Items',
                        button: newItemButton(context, controller),
                      ),
                      Expanded(
                        child: GetX<CarTradingDashboardController>(
                          builder: (controller) {
                            if (controller.isTransfersLoading.isTrue &&
                                controller.alltransfers.isEmpty) {
                              return Center(child: loadingProcess);
                            } else if (controller.alltransfers.isEmpty) {
                              return const Center(child: Text('No Transfers'));
                            }
                            return SizedBox(
                              width: constraints.maxWidth,
                              child: tableOfScreens(
                                constraints: constraints,
                                context: context,
                                controller: controller,
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
                  'Total Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textForDataRowInTable(
                  text: '${controller.totalTransfersAmount.value}',
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
  return DataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    showBottomBorder: true,
    lmRatio: 2.5,
    columns: [
      const DataColumn2(label: SizedBox(), size: ColumnSize.S),

      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'Date', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'From Account'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'To Account', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Comments'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Amount'),
      ),
    ],
    rows:
        controller.filteredTransfers.isEmpty &&
            controller.searchForTransfers.value.text.isEmpty
        ? controller.alltransfers.map<DataRow>((entry) {
            final capitalId = entry.id ?? '';
            return dataRowForTheTable(
              entry,
              context,
              constraints,
              controller,
              capitalId,
            );
          }).toList()
        : controller.filteredTransfers.map<DataRow>((entry) {
            final capitalId = entry.id ?? '';
            return dataRowForTheTable(
              entry,
              context,
              constraints,
              controller,
              capitalId,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  TransferModel itemData,
  BuildContext context,
  BoxConstraints constraints,
  CarTradingDashboardController controller,
  String transferId,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            deleteSection(controller, context, transferId),
            editSection(context, controller, itemData, transferId),
          ],
        ),
      ),
      DataCell(Text(textToDate(itemData.date))),
      DataCell(Text(itemData.fromAccountName ?? '')),
      DataCell(Text(itemData.toAccountName ?? '')),
      DataCell(Text(itemData.comment ?? '')),
      DataCell(
        textForDataRowInTable(
          text: itemData.amount.toString(),
          isBold: true,
          color: Colors.red,
        ),
      ),
    ],
  );
}

IconButton deleteSection(
  CarTradingDashboardController controller,
  BuildContext context,
  String transferId,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "Theis will be deleted permanently",
        onPressed: () async {
          await controller.deleteTransfer(transferId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  CarTradingDashboardController controller,
  TransferModel itemData,
  String transferId,
) {
  return IconButton(
    onPressed: () async {
      controller.transferComments.value.text = itemData.comment ?? '';
      controller.transferAmount.text = itemData.amount?.toString() ?? '0';
      controller.fromAccount.text = itemData.fromAccountName ?? '';
      controller.toAccount.text = itemData.toAccountName ?? '';
      controller.fromAccountId.value = itemData.fromAccount ?? '';
      controller.toAccountId.value = itemData.toAccount ?? '';
      controller.transferDate.value.text = textToDate(itemData.date);
      transferItemDialog(
        controller: controller,
        onPressed: () {
          controller.updateTransfer(transferId);
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
      controller.transferComments.value.clear();
      controller.transferAmount.clear();
      controller.fromAccount.clear();
      controller.toAccount.clear();
      controller.fromAccountId.value = '';
      controller.toAccountId.value = '';
      controller.transferDate.value.text = textToDate(DateTime.now());
      transferItemDialog(
        controller: controller,
        onPressed: () {
          controller.addNewTransfer();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Transfer'),
  );
}
