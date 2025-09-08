import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/cash_management_widgets/receipt_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';
import 'cash_management_payment.dart';

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
                  GetX<CashManagementController>(
                      init: CashManagementController(),
                      builder: (controller) {
                        bool isCustomersLoading =
                            controller.allCustomers.isEmpty;
                        bool isReceiptTypesLoading =
                            controller.allReceiptTypes.isEmpty;
                        bool isAccountLoading = controller.allAccounts.isEmpty;
                        return Row(
                          spacing: 10,
                          children: [
                            Expanded(
                                child: myTextFormFieldWithBorder(
                              labelText: 'Receipt NO.',
                              controller: controller.receiptCounterFilter.value,
                            )),
                            Expanded(
                              child: CustomDropdown(
                                showedSelectedName: 'name',
                                textcontroller:
                                    controller.receiptTypeFilter.value.text,
                                hintText: 'Receipt Type',
                                items: isReceiptTypesLoading
                                    ? {}
                                    : controller.allReceiptTypes,
                                onChanged: (key, value) async {
                                  controller.receiptTypeFilterId.value = key;
                                  controller.receiptTypeFilter.value.text =
                                      value['name'];
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
                                items: isCustomersLoading
                                    ? {}
                                    : controller.allCustomers,
                                onChanged: (key, value) async {
                                  controller.customerNameFilterId.value = key;
                                  controller.customerNameFilter.value.text =
                                      value['entity_name'];
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomDropdown(
                                showedSelectedName: 'account_number',
                                textcontroller:
                                    controller.accountFilter.value.text,
                                hintText: 'Account',
                                items: isAccountLoading
                                    ? {}
                                    : controller.allAccounts,
                                onChanged: (key, value) async {
                                  controller.accountFilterId.value = key;
                                  controller.accountFilter.value.text =
                                      value['account_number'];
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomDropdown(
                                showedSelectedName: 'name',
                                textcontroller:
                                    controller.bankNameFilter.value.text,
                                hintText: 'Bank Name',
                                items:
                                    isAccountLoading ? {} : controller.allBanks,
                                onChanged: (key, value) async {
                                  controller.bankNameFilterId.value = key;
                                  controller.bankNameFilter.value.text =
                                      value['name'];
                                },
                              ),
                            ),
                            Expanded(
                                child: myTextFormFieldWithBorder(
                              labelText: 'Cheque NO.',
                              controller: controller.chequeNumberFilter.value,
                            )),
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
                              ),
                            ),
                          ],
                        );
                      }),
                  GetBuilder<CashManagementController>(builder: (controller) {
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
                                      controller.fromDate.value);
                                },
                              )),
                              Expanded(
                                  child: myTextFormFieldWithBorder(
                                controller: controller.toDate.value,
                                labelText: 'To Date',
                                onFieldSubmitted: (_) async {
                                  normalizeDate(
                                      controller.toDate.value.text,
                                      controller.toDate.value);
                                },
                              )),
                              ElevatedButton(
                                  style: allButtonStyle,
                                  onPressed: () {
                                    controller.clearAllFilters();
                                    controller.isAllSelected.value = true;
                                    controller.isTodaySelected.value = false;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value = false;

                                    controller.searchEngineForReceipts();
                                  },
                                  child: const Text('All')),
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
                                          controller.searchEngineForReceipts();
                                        }
                                      : null,
                                  child: const Text('Today')),
                              ElevatedButton(
                                  style: thisMonthButtonStyle,
                                  onPressed: controller
                                          .isThisMonthSelected.isFalse
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
                                          controller.searchEngineForReceipts();
                                        }
                                      : null,
                                  child: const Text('This Month')),
                              ElevatedButton(
                                  style: thisYearButtonStyle,
                                  onPressed: controller
                                          .isThisYearSelected.isFalse
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
                                          controller.searchEngineForReceipts();
                                        }
                                      : null,
                                  child: const Text('This Year')),
                              ElevatedButton(
                                  style: saveButtonStyle,
                                  onPressed: controller
                                          .isThisYearSelected.isFalse
                                      ? () async {
                                          controller.removeFilters();
                                          controller.searchEngineForReceipts();
                                        }
                                      : null,
                                  child: Text(
                                    'Find',
                                    style: fontStyleForElevatedButtons,
                                  )),
                              ElevatedButton(
                                  style: clearVariablesButtonStyle,
                                  onPressed:
                                      controller.isThisYearSelected.isFalse
                                          ? () {
                                              controller.clearAllFilters();
                                              controller.update();
                                            }
                                          : null,
                                  child: Text(
                                    'Clear Filters',
                                    style: fontStyleForElevatedButtons,
                                  )),
                            ],
                          ),
                        ),
                        const Expanded(flex: 2, child: SizedBox()),
                        newReceiptButton(context, constraints, controller)
                      ],
                    );
                  }),
                  GetX<CashManagementController>(builder: (controller) {
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
                                      formatDouble: false)),
                              customBox(
                                  title: 'RECEIVED',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.green,
                                    isBold: true,
                                    text:
                                        '${controller.totalReceiptsReceived.value}',
                                  )),
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox())
                      ],
                    );
                  }),
                  Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetX<CashManagementController>(
                      builder: (controller) {
                        if (controller.isScreenLodingForReceipts.value &&
                            controller.allReceipts.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: loadingProcess),
                          );
                        }
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreensForCashManagement(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                              data: controller.allReceipts,
                              scrollController: controller.scrollController,
                              isPayment: false),
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
  required CashManagementController controller,
  required RxList<DocumentSnapshot> data,
  required ScrollController scrollController,
  required bool isPayment,
}) {
  final dataSource = CardDataSource(
      cards: data,
      context: context,
      constraints: constraints,
      controller: controller,
      isPayment: isPayment);
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
        rowsPerPage: 5,
        horizontalMargin: horizontalMarginForTable,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          const DataColumn(label: SizedBox()
              // onSort: controller.onSort,
              ),
          DataColumn(
            label: AutoSizedText(
              text: isPayment ? 'Payment Number' : 'Receipt Number',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Status',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: isPayment ? 'Payment Date' : 'Receipt Date',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: isPayment ? 'Vendor Name' : 'Customer Name',
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: isPayment ? 'Payment Type' : 'Receipt Type',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Account',
            ),
          ),
          if (!isPayment)
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Bank Name',
              ),
            ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Cheque Number',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Cheque Date',
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(
              constraints: constraints,
              text: isPayment ? 'Paid' : 'Received',
            ),
            // onSort: controller.onSort,
          ),
        ],
        source: dataSource,
      ),
    ),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> cashManagementData,
    context,
    constraints,
    cashManagementId,
    CashManagementController controller,
    int index,
    bool isPayment) {
  return DataRow(cells: [
    DataCell(isPayment
        ? editSectionForPayments(context, controller, cashManagementData,
            constraints, cashManagementId)
        : editSection(context, controller, cashManagementData, constraints,
            cashManagementId)),
    DataCell(textForDataRowInTable(
        text: isPayment
            ? cashManagementData['payment_number'] ?? ''
            : cashManagementData['receipt_number'] ?? '',
        formatDouble: false)),
    DataCell(cashManagementData['status'] != ''
        ? statusBox(cashManagementData['status'],
            hieght: 35, padding: const EdgeInsets.all(0))
        : const SizedBox()),
    DataCell(isPayment
        ? textForDataRowInTable(
            text: cashManagementData['payment_date'] != null &&
                    cashManagementData['payment_date'] != ''
                ? textToDate(cashManagementData['payment_date']) //
                : 'N/A',
          )
        : textForDataRowInTable(
            text: cashManagementData['receipt_date'] != null &&
                    cashManagementData['receipt_date'] != ''
                ? textToDate(cashManagementData['receipt_date']) //
                : 'N/A',
          )),
    DataCell(
      textForDataRowInTable(
          formatDouble: false,
          text: isPayment
              ? getdataName(cashManagementData['vendor'], controller.allVendors,
                  title: 'entity_name')
              : getdataName(
                  cashManagementData['customer'], controller.allCustomers,
                  title: 'entity_name')),
    ),
    DataCell(
      textForDataRowInTable(
          formatDouble: false,
          text: getdataName(
            isPayment
                ? cashManagementData['payment_type']
                : cashManagementData['receipt_type'],
            controller.allReceiptTypes,
          )),
    ),
    DataCell(
      textForDataRowInTable(
          formatDouble: false,
          text: getdataName(
              cashManagementData['account'], controller.allAccounts,
              title: 'account_number')),
    ),
    if (!isPayment)
      DataCell(
        textForDataRowInTable(
            formatDouble: false,
            text: getdataName(
              cashManagementData['bank_name'],
              controller.allBanks,
            )),
      ),
    DataCell(
      textForDataRowInTable(
          formatDouble: false, text: cashManagementData['cheque_number']),
    ),
    DataCell(textForDataRowInTable(
      formatDouble: false,
      text: cashManagementData['cheque_date'] != null &&
              cashManagementData['cheque_date'] != ''
          ? textToDate(cashManagementData['cheque_date']) //
          : 'N/A',
    )),
    DataCell(
      Align(
        alignment: Alignment.centerRight,
        child: FutureBuilder<double>(
          future: isPayment
              ? controller.getPaymentPaidAmount(cashManagementId)
              : controller.getReceiptReceivedAmount(cashManagementId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return textForDataRowInTable(
                color: isPayment ? Colors.red : Colors.green,
                isBold: true,
                text: '${snapshot.data}',
              );
            }
          },
        ),
      ),
    ),
  ]);
}

Widget editSection(BuildContext context, CashManagementController controller,
    Map<String, dynamic> cashManagementData, constraints, cashManagementId) {
  return GetX<CashManagementController>(builder: (controller) {
    bool isLoading = controller.buttonLoadingStates[cashManagementId] ?? false;

    return IconButton(
        onPressed: controller.buttonLoadingStates[cashManagementId] == null ||
                isLoading == false
            ? () async {
                controller.setButtonLoading(cashManagementId, true);

                await controller.loadValuesForReceipts(cashManagementData);
                controller.setButtonLoading(cashManagementId, false);

                receiptDialog(
                  onPressedForcancel: controller.cancellingReceipts.isTrue
                      ? null
                      : () {
                          controller.cancelReceipt(cashManagementId);
                        },
                  canEdit: true,
                  constraints: constraints,
                  controller: controller,
                  onPressedForPost: controller.postingReceipts.isTrue
                      ? null
                      : () {
                          controller.postReceipt(cashManagementId);
                        },
                  onPressedForSave: controller.addingNewValue.value
                      ? null
                      : () {
                          if (controller.status.value == 'Posted') {
                            showSnackBar(
                                'Alert', 'Only New Receipts Can be Edited');
                            return;
                          }
                          controller.editReceipt(cashManagementId);
                        },
                  onPressedForDelete: () {
                    alertDialog(
                        context: context,
                        content: "This will be deleted permanently",
                        onPressed: () {
                          controller.deleteReceipt(cashManagementId);
                        });
                  },
                );
              }
            : null,
        icon: isLoading ? loadingProcess : editIcon);
  });
}

ElevatedButton newReceiptButton(BuildContext context,
    BoxConstraints constraints, CashManagementController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      receiptDialog(
          onPressedForcancel: null,
          onPressedForDelete: null,
          canEdit: true,
          constraints: constraints,
          controller: controller,
          onPressedForPost: controller.postingReceipts.isTrue
              ? null
              : () {
                  controller.postReceipt(controller.currentReceiptID.value);
                },
          onPressedForSave: controller.addingNewValue.value
              ? null
              : () {
                  controller.addNewReceipts();
                });
    },
    style: newButtonStyle,
    child: const Text('New Receipt'),
  );
}

class CardDataSource extends DataTableSource {
  final List<DocumentSnapshot> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final CashManagementController controller;
  final bool isPayment;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
    required this.isPayment,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final trade = cards[index];
    final cardData = trade.data() as Map<String, dynamic>;
    final cardId = trade.id;

    return dataRowForTheTable(
        cardData, context, constraints, cardId, controller, index, isPayment);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
