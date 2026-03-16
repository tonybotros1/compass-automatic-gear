import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/account_transfers_controller.dart';
import '../../../../Models/car trading/transfer_model.dart';
import '../../../../Models/dynamic_boxes_line_model.dart';
import '../../../../Widgets/dynamic_boxes_line.dart';
import '../../../../Widgets/main screen widgets/account_transfers_widgets/account_transfers_dialog.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../consts.dart';

class AccountTransfers extends StatelessWidget {
  const AccountTransfers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: SizedBox(
              width: constraints.maxWidth,

              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GetBuilder<AccountTransfersController>(
                      init: AccountTransfersController(),

                      builder: (controller) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 28,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    myTextFormFieldWithBorder(
                                      width: 120,
                                      labelText: 'Transfer No.',
                                      controller:
                                          controller.transferCounterFilter,
                                    ),
                                    MenuWithValues(
                                      labelText: 'From Account',
                                      headerLqabel: 'Accounts',
                                      dialogWidth: constraints.maxWidth / 3,
                                      width: 300,
                                      controller: controller.fromAccountFilter,
                                      displayKeys: const ['account_number'],
                                      displaySelectedKeys: const [
                                        'account_number',
                                      ],
                                      onOpen: () {
                                        return controller.getAllAccounts();
                                      },
                                      onDelete: () {
                                        controller.fromAccountIdFilter.value =
                                            '';
                                        controller.fromAccountFilter.clear();
                                      },
                                      onSelected: (value) {
                                        controller.fromAccountIdFilter.value =
                                            value['_id'];
                                        controller.fromAccountFilter.text =
                                            value['account_number'];
                                      },
                                    ),
                                    MenuWithValues(
                                      labelText: 'To Account',
                                      headerLqabel: 'Accounts',
                                      dialogWidth: constraints.maxWidth / 3,
                                      width: 300,
                                      controller: controller.toAccountFilter,
                                      displayKeys: const ['account_number'],
                                      displaySelectedKeys: const [
                                        'account_number',
                                      ],
                                      onOpen: () {
                                        return controller.getAllAccounts();
                                      },
                                      onDelete: () {
                                        controller.toAccountIdFilter.value = '';
                                        controller.toAccountFilter.clear();
                                      },
                                      onSelected: (value) {
                                        controller.toAccountIdFilter.value =
                                            value['_id'];
                                        controller.toAccountFilter.text =
                                            value['account_number'];
                                      },
                                    ),
                                    myTextFormFieldWithBorder(
                                      labelText: 'Comments',
                                      controller: controller.commentsFilter,
                                      width: 300,
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    myTextFormFieldWithBorder(
                                      width: 120,
                                      controller: controller.fromDate.value,
                                      labelText: 'From Date',
                                      onFieldSubmitted: (_) async {
                                        normalizeDate(
                                          controller.fromDate.value.text,
                                          controller.fromDate.value,
                                        );
                                      },
                                      onTapOutside: (_) {
                                        normalizeDate(
                                          controller.fromDate.value.text,
                                          controller.fromDate.value,
                                        );
                                      },
                                    ),
                                    myTextFormFieldWithBorder(
                                      width: 120,
                                      controller: controller.toDate.value,
                                      labelText: 'To Date',
                                      onFieldSubmitted: (_) async {
                                        normalizeDate(
                                          controller.toDate.value.text,
                                          controller.toDate.value,
                                        );
                                      },
                                      onTapOutside: (_) {
                                        normalizeDate(
                                          controller.toDate.value.text,
                                          controller.toDate.value,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    GetX<AccountTransfersController>(
                      builder: (controller) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 28,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                newTransferButton(
                                  context,
                                  constraints,
                                  controller,
                                ),
                                CustomSlidingSegmentedControl<int>(
                                  height: 30,
                                  initialValue:
                                      controller.initStatusPickersValue.value,
                                  children: const {
                                    1: Text('ALL'),
                                    2: Text('NEW'),
                                    3: Text('POSTED'),
                                  },
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.lightBackgroundGray,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  thumbDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(1),
                                        blurRadius: 4.0,
                                        spreadRadius: 1.0,
                                        offset: const Offset(0.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInToLinear,
                                  onValueChanged: (v) {
                                    controller.onChooseForStatusPicker(v);
                                  },
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    ElevatedButton(
                                      style: findButtonStyle,
                                      onPressed:
                                          controller.isScreenLoding.isFalse
                                          ? () async {
                                              controller.filterSearch();
                                            }
                                          : null,
                                      child: controller.isScreenLoding.isFalse
                                          ? Text(
                                              'Find',
                                              style:
                                                  fontStyleForElevatedButtons,
                                            )
                                          : loadingProcess,
                                    ),
                                    ElevatedButton(
                                      style: clearVariablesButtonStyle,
                                      onPressed: () {
                                        controller.clearAllFilters();
                                        // controller.update();
                                      },
                                      child: Text(
                                        'Clear',
                                        style: fontStyleForElevatedButtons,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GetX<AccountTransfersController>(
                        builder: (controller) {
                          return SizedBox(
                            height: 100,
                            child: dynamicBoxesLine(
                              dynamicConfigs: [
                                DynamicBoxesLineModel(
                                  isFormated: false,
                                  width: 300,
                                  label: 'NUMBER OF TRANSFERS',
                                  value: '${controller.countOfTransfers.value}',
                                  valueColor: mainColor,
                                  icon: counterIcon,
                                  iconColor: mainColorWithAlpha,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    GetX<AccountTransfersController>(
                      builder: (controller) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                            ),
                          ),
                          child: SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight * 0.75,
                            child: tableOfScreens(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required AccountTransfersController controller,
}) {
  return PaginatedDataTable2(
    border: TableBorder.symmetric(
      inside: BorderSide(color: Colors.grey.shade200, width: 0.5),
    ),
    lmRatio: 5,
    autoRowsToHeight: true,
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    showFirstLastButtons: true,
    columns: [
      const DataColumn(label: Text('')),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'Transfer Number', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'Status', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'Date', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'From Account', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(text: 'ُTo Account', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(text: 'Comment', constraints: constraints),
      ),
      DataColumn2(
        size: ColumnSize.M,
        numeric: true,
        label: AutoSizedText(text: 'Amount', constraints: constraints),
      ),
    ],
    source: CardDataSource(
      cards: controller.alltransfers.isEmpty ? [] : controller.alltransfers,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  TransferModel entityData,
  BuildContext context,
  BoxConstraints constraints,
  String transferId,
  AccountTransfersController controller,
  int index,
) {
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return index % 2 == 0 ? Colors.white : Colors.grey.shade100;
    }),
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, context, transferId),
            editSection(context, controller, entityData, transferId),
          ],
        ),
      ),

      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: false,
          text: entityData.transferCounter ?? '',
        ),
      ),
      DataCell(
        entityData.status != ''
            ? statusBox(entityData.status ?? '')
            : const SizedBox(),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: false,
          text: textToDate(entityData.date),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: false,
          text: entityData.fromAccountName ?? '',
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: false,
          text: entityData.toAccountName ?? '',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: false,
          text: entityData.comment ?? '',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: true,
          text: entityData.amount?.toString() ?? '0',
          color: Colors.blueGrey,
        ),
      ),
    ],
  );
}

IconButton deleteSection(
  AccountTransfersController controller,
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
  AccountTransfersController controller,
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
      controller.status.value = itemData.status ?? '';
      controller.transferDate.value.text = textToDate(itemData.date);
      controller.transferCounter.text = itemData.transferCounter ?? '';
      accounTransferItemDialog(
        controller: controller,
        onPressed: () {
          controller.updateTransfer(transferId);
        },
        onPressedForPosted: () {
          if (controller.status.value == "Posted") {
            alertMessage(
              context: context,
              content: 'Transfer is already Posted',
            );
            return;
          }
          alertDialog(
            context: context,
            content: 'Do you want to post this transfer?',
            onPressed: () {
              controller.status.value = 'Posted';
              controller.updateTransfer(transferId);
            },
          );
        },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newTransferButton(
  BuildContext context,
  BoxConstraints constraints,
  AccountTransfersController controller,
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
      controller.status.value = '';
      controller.transferCounter.clear();
      accounTransferItemDialog(
        controller: controller,
        onPressed: () {
          controller.addNewTransfer();
        },
        onPressedForPosted: null,
      );
    },
    style: newButtonStyle,
    child: const Text('New Transfer'),
  );
}

class CardDataSource extends DataTableSource {
  final List<TransferModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final AccountTransfersController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final entityDate = cards[index];
    final cardId = entityDate.id ?? '';

    return dataRowForTheTable(
      entityDate,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
