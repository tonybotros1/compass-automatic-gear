import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/ar_receipts_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/cash_management_receipts_controller.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/cash_management_widgets/receipt_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class CashManagementReceipt extends StatelessWidget {
  const CashManagementReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  GetX<CashManagementReceiptsController>(
                    init: CashManagementReceiptsController(),
                    builder: (controller) {
                      return Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: myTextFormFieldWithBorder(
                              labelText: 'Receipt NO.',
                              controller: controller.receiptCounterFilter.value,
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown(
                              showedSelectedName: 'name',
                              textcontroller:
                                  controller.receiptTypeFilter.value.text,
                              hintText: 'Receipt Type',

                              onChanged: (key, value) async {
                                controller.receiptTypeFilterId.value = key;
                                controller.receiptTypeFilter.value.text =
                                    value['name'];
                              },
                              onDelete: () {
                                controller.receiptTypeFilterId.value = '';
                                controller.receiptTypeFilter.value.clear();
                              },
                              onOpen: () {
                                return controller.getReceiptsAndPaymentsTypes();
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomDropdown(
                              showedSelectedName: 'entity_name',
                              textcontroller:
                                  controller.customerNameFilter.value.text,
                              hintText: 'Customer Name',
                              onChanged: (key, value) async {
                                controller.customerNameFilterId.value = key;
                                controller.customerNameFilter.value.text =
                                    value['entity_name'];
                              },
                              onDelete: () {
                                controller.customerNameFilterId.value = '';
                                controller.customerNameFilter.value.clear();
                              },
                              onOpen: () {
                                return controller.getAllCustomers();
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown(
                              showedSelectedName: 'account_number',
                              textcontroller:
                                  controller.accountFilter.value.text,
                              hintText: 'Account',

                              onChanged: (key, value) async {
                                controller.accountFilterId.value = key;
                                controller.accountFilter.value.text =
                                    value['account_number'];
                              },
                              onDelete: () {
                                controller.accountFilterId.value = '';
                                controller.accountFilter.value.clear();
                              },
                              onOpen: () {
                                return controller.getAllAccounts();
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown(
                              showedSelectedName: 'name',
                              textcontroller:
                                  controller.bankNameFilter.value.text,
                              hintText: 'Bank Name',

                              onChanged: (key, value) async {
                                controller.bankNameFilterId.value = key;
                                controller.bankNameFilter.value.text =
                                    value['name'];
                              },
                              onDelete: () {
                                controller.bankNameFilterId.value = '';
                                controller.bankNameFilter.value.clear();
                              },
                              onOpen: () {
                                return controller.getBanks();
                              },
                            ),
                          ),
                          Expanded(
                            child: myTextFormFieldWithBorder(
                              labelText: 'Cheque NO.',
                              controller: controller.chequeNumberFilter.value,
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown(
                              textcontroller:
                                  controller.statusFilter.value.text,
                              showedSelectedName: 'name',
                              hintText: 'Status',
                              items: allStatus,
                              onChanged: (key, value) async {
                                controller.statusFilter.value.text =
                                    value['name'];
                              },
                              onDelete: () {
                                controller.statusFilter.value.clear();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  GetX<CashManagementReceiptsController>(
                    builder: (controller) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    controller: controller.fromDate.value,
                                    labelText: 'From Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.fromDate.value.text,
                                        controller.fromDate.value,
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    controller: controller.toDate.value,
                                    labelText: 'To Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.toDate.value.text,
                                        controller.toDate.value,
                                      );
                                    },
                                  ),
                                ),

                                ElevatedButton(
                                  style: todayButtonStyle,
                                  onPressed: controller.isTodaySelected.isFalse
                                      ? () {
                                          controller.isAllSelected.value =
                                              false;
                                          controller.isTodaySelected.value =
                                              true;
                                          controller.isThisMonthSelected.value =
                                              false;
                                          controller.isThisYearSelected.value =
                                              false;
                                          controller.isYearSelected.value =
                                              false;
                                          controller.isMonthSelected.value =
                                              false;
                                          controller.isDaySelected.value = true;
                                          controller.filterSearch();
                                        }
                                      : null,
                                  child: const Text('Today'),
                                ),
                                ElevatedButton(
                                  style: thisMonthButtonStyle,
                                  onPressed:
                                      controller.isThisMonthSelected.isFalse
                                      ? () {
                                          controller.isAllSelected.value =
                                              false;
                                          controller.isTodaySelected.value =
                                              false;
                                          controller.isThisMonthSelected.value =
                                              true;
                                          controller.isThisYearSelected.value =
                                              false;
                                          controller.isYearSelected.value =
                                              false;
                                          controller.isMonthSelected.value =
                                              true;
                                          controller.isDaySelected.value =
                                              false;
                                          controller.filterSearch();
                                        }
                                      : null,
                                  child: const Text('This Month'),
                                ),
                                ElevatedButton(
                                  style: thisYearButtonStyle,
                                  onPressed:
                                      controller.isThisYearSelected.isFalse
                                      ? () {
                                          controller.isTodaySelected.value =
                                              false;
                                          controller.isThisMonthSelected.value =
                                              false;
                                          controller.isThisYearSelected.value =
                                              true;
                                          controller.isYearSelected.value =
                                              true;
                                          controller.isMonthSelected.value =
                                              false;
                                          controller.isDaySelected.value =
                                              false;
                                          controller.filterSearch();
                                        }
                                      : null,
                                  child: const Text('This Year'),
                                ),
                                ElevatedButton(
                                  style: saveButtonStyle,
                                  onPressed:
                                      controller
                                          .isScreenLodingForReceipts
                                          .isFalse
                                      ? () async {
                                          controller.filterSearch();
                                        }
                                      : null,
                                  child:
                                      controller
                                          .isScreenLodingForReceipts
                                          .isFalse
                                      ? Text(
                                          'Find',
                                          style: fontStyleForElevatedButtons,
                                        )
                                      : loadingProcess,
                                ),
                                ElevatedButton(
                                  style: clearVariablesButtonStyle,
                                  onPressed: () {
                                    controller.clearAllFilters();
                                  },
                                  child: Text(
                                    'Clear Filters',
                                    style: fontStyleForElevatedButtons,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(flex: 2, child: SizedBox()),
                          newReceiptButton(context, constraints, controller),
                        ],
                      );
                    },
                  ),
                  GetX<CashManagementReceiptsController>(
                    builder: (controller) {
                      return Row(
                        children: [
                          Expanded(
                            child: Row(
                              spacing: 10,
                              children: [
                                customBox(
                                  title: 'NUMBER OF RECEIPTS',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: mainColor,
                                    isBold: true,
                                    text:
                                        '${controller.numberOfReceipts.value}',
                                    formatDouble: false,
                                  ),
                                ),
                                customBox(
                                  title: 'RECEIVED',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.green,
                                    isBold: true,
                                    text:
                                        '${controller.totalReceiptsReceived.value}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      );
                    },
                  ),
                  Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                    ),
                    child: GetX<CashManagementReceiptsController>(
                      builder: (controller) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreensForCashManagement(
                            constraints: constraints,
                            context: context,
                            controller: controller,
                            data: controller.allReceipts,
                            scrollController: controller.scrollController,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreensForCashManagement({
  required BoxConstraints constraints,
  required BuildContext context,
  required CashManagementReceiptsController controller,
  required RxList<ARReceiptsModel> data,
  required ScrollController scrollController,
}) {
  bool isReceiptsLoading = data.isEmpty;

  return DataTableTheme(
    data: DataTableThemeData(
      headingTextStyle: fontStyleForTableHeader,
      dataTextStyle: regTextStyle,
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300;
        }
        return null;
      }),
    ),
    child: Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: PaginatedDataTable(
        controller: scrollController,
        showFirstLastButtons: true,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        columnSpacing: 5,
        rowsPerPage: 10,
        horizontalMargin: horizontalMarginForTable,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          const DataColumn(
            label: SizedBox(),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              text: 'Receipt Number',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Status'),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Receipt Date',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Customer Name',
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Receipt Type',
            ),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Account'),
          ),

          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Cheque Number',
            ),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Cheque Date'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Received'),
            // onSort: controller.onSort,
          ),
        ],
        source: CardDataSource(
          cards: isReceiptsLoading ? [] : data,
          context: context,
          constraints: constraints,
          controller: controller,
        ),
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  ARReceiptsModel cashManagementData,
  context,
  constraints,
  cashManagementId,
  CashManagementReceiptsController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        editSection(
          context,
          controller,
          cashManagementData,
          constraints,
          cashManagementId,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: cashManagementData.receiptNumber ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        cashManagementData.status != ''
            ? statusBox(
                cashManagementData.status ?? '',
                hieght: 35,
                width: 100,
                // padding: const EdgeInsets.all(0),
              )
            : const SizedBox(),
      ),
      DataCell(
        textForDataRowInTable(
          text: cashManagementData.receiptDate != null
              ? textToDate(cashManagementData.receiptDate)
              : 'N/A',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData.customerName ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData.receiptTypeName ?? '',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData.accountNumber ?? '',
          maxWidth: null,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData.chequeNumber ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData.chequeDate != null
              ? textToDate(cashManagementData.chequeDate)
              : 'N/A',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.green,
          isBold: true,
          text: '${cashManagementData.totalReceived}',
        ),
      ),
    ],
  );
}

Widget editSection(
  BuildContext context,
  CashManagementReceiptsController controller,
  ARReceiptsModel cashManagementData,
  constraints,
  cashManagementId,
) {
  return GetX<CashManagementReceiptsController>(
    builder: (controller) {
      bool isLoading =
          controller.buttonLoadingStates[cashManagementId] ?? false;

      return IconButton(
        onPressed:
            controller.buttonLoadingStates[cashManagementId] == null ||
                isLoading == false
            ? () async {
                controller.setButtonLoading(cashManagementId, true);

                await controller.loadValuesForReceipts(cashManagementData);
                controller.setButtonLoading(cashManagementId, false);

                receiptDialog(
                  onPressedForcancel: () async {
                    Map currentReceiptStatus = await controller
                        .getCurrentARReceiptStatus(
                          controller.currentReceiptID.value,
                        );
                    String status1 = currentReceiptStatus['status'];
                    if (status1 == 'Posted') {
                      showSnackBar('Alert', 'Can\'t cancel posted receipts');
                      return;
                    }
                    if (status1 == 'Cancelled') {
                      showSnackBar('Alert', 'Status already cancelled');
                      return;
                    }
                    controller.status.value = 'Cancelled';
                    controller.isReceiptModified.value = true;
                  },
                  canEdit: true,
                  constraints: constraints,
                  controller: controller,
                  onPressedForPost: () async {
                    Map currentReceiptStatus = await controller
                        .getCurrentARReceiptStatus(
                          controller.currentReceiptID.value,
                        );
                    String status1 = currentReceiptStatus['status'];
                    if (status1 == 'Cancelled') {
                      showSnackBar('Alert', 'Can\'t post cancelled receipts');
                      return;
                    }
                    if (status1 == 'Posted') {
                      showSnackBar('Alert', 'Status already posted');
                      return;
                    }
                    controller.status.value = 'Posted';
                    controller.isReceiptModified.value = true;
                  },
                  onPressedForSave: controller.addingNewValue.value
                      ? null
                      : () {
                          controller.addNewReceipts();
                        },
                  onPressedForDelete: () {
                    if (controller.status.value != ' New') {
                      showSnackBar('Alert', 'Only new receipts can be delted');
                      return;
                    }
                    alertDialog(
                      context: context,
                      content: "This will be deleted permanently",
                      onPressed: () {
                        controller.deleteReceipt(cashManagementId);
                      },
                    );
                  },
                );
              }
            : null,
        icon: isLoading ? loadingProcess : editIcon,
      );
    },
  );
}

ElevatedButton newReceiptButton(
  BuildContext context,
  BoxConstraints constraints,
  CashManagementReceiptsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      receiptDialog(
        onPressedForcancel: null,
        onPressedForDelete: null,
        canEdit: true,
        constraints: constraints,
        controller: controller,
        onPressedForPost: () async {
          Map currentReceiptStatus = await controller.getCurrentARReceiptStatus(
            controller.currentReceiptID.value,
          );
          String status1 = currentReceiptStatus['status'];
          if (status1 == 'Cancelled') {
            showSnackBar('Alert', 'Can\'t post cancelled receipts');
            return;
          }
          if (status1 == 'Posted') {
            showSnackBar('Alert', 'Status already posted');
            return;
          }
          controller.status.value = 'Posted';
          controller.isReceiptModified.value = true;
        },
        onPressedForSave: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewReceipts();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Receipt'),
  );
}

class CardDataSource extends DataTableSource {
  final List<ARReceiptsModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final CashManagementReceiptsController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final trade = cards[index];
    final cardId = trade.id;

    return dataRowForTheTable(
      trade,
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
