import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/cash_management_payments_controller.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/cash_management_widgets/payment_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class CashManagementPayment extends StatelessWidget {
  const CashManagementPayment({super.key});

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
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetX<CashManagementPaymentsController>(
                    init: CashManagementPaymentsController(),
                    builder: (controller) {
                      return Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: myTextFormFieldWithBorder(
                              labelText: 'Payment NO.',
                              controller: controller.receiptCounterFilter.value,
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown(
                              showedSelectedName: 'name',
                              textcontroller:
                                  controller.receiptTypeFilter.value.text,
                              hintText: 'Payment Type',
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
                              hintText: 'Vendor Name',
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
                                return controller.getAllVendors();
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
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  GetBuilder<CashManagementPaymentsController>(
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
                                  style: allButtonStyle,
                                  onPressed: () {
                                    controller.clearAllFilters();
                                    controller.isAllSelected.value = true;
                                    controller.isTodaySelected.value = false;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value = false;

                                    controller.searchEngineForPayments();
                                  },
                                  child: const Text('All'),
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
                                          controller.searchEngineForPayments();
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
                                          controller.searchEngineForPayments();
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
                                          controller.searchEngineForPayments();
                                        }
                                      : null,
                                  child: const Text('This Year'),
                                ),
                                ElevatedButton(
                                  style: saveButtonStyle,
                                  onPressed:
                                      controller.isThisYearSelected.isFalse
                                      ? () async {
                                          controller.removeFilters();
                                          controller.searchEngineForPayments();
                                        }
                                      : null,
                                  child: Text(
                                    'Find',
                                    style: fontStyleForElevatedButtons,
                                  ),
                                ),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(flex: 2, child: SizedBox()),
                          newPaymentButton(context, constraints, controller),
                        ],
                      );
                    },
                  ),
                  GetX<CashManagementPaymentsController>(
                    builder: (controller) {
                      return Row(
                        children: [
                          Expanded(
                            child: Row(
                              spacing: 10,
                              children: [
                                customBox(
                                  title: 'NUMBER OF PAYMENTS',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: mainColor,
                                    isBold: true,
                                    text:
                                        '${controller.numberOfPayments.value}',
                                    formatDouble: false,
                                  ),
                                ),
                                customBox(
                                  title: 'PAID',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.red,
                                    isBold: true,
                                    text:
                                        '${controller.totalPaymentPaid.value}',
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetX<CashManagementPaymentsController>(
                      builder: (controller) {
                        if (controller.isScreenLodingForPayments.value &&
                            controller.allPayements.isEmpty) {
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
                            data: controller.allPayements,
                            scrollController: controller.scrollController2,
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

ElevatedButton newPaymentButton(
  BuildContext context,
  BoxConstraints constraints,
  CashManagementPaymentsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      paymentDialog(
        onPressedForDelete: null,
        canEdit: true,
        constraints: constraints,
        controller: controller,
        onPressedForCancel: null,
        onPressedForPost: controller.postingPayment.isTrue
            ? null
            : () {
                controller.postPayment(controller.currentPaymentID.value);
              },
        onPressedForSave: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewPayment();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Payment'),
  );
}

Widget editSectionForPayments(
  BuildContext context,
  CashManagementPaymentsController controller,
  Map<String, dynamic> cashManagementData,
  constraints,
  cashManagementId,
) {
  return GetX<CashManagementPaymentsController>(
    builder: (controller) {
      bool isLoading =
          controller.buttonLoadingStates[cashManagementId] ?? false;

      return IconButton(
        onPressed:
            controller.buttonLoadingStates[cashManagementId] == null ||
                isLoading == false
            ? () async {
                controller.setButtonLoading(cashManagementId, true);

                await controller.loadValuesForPayments(cashManagementData);
                controller.setButtonLoading(cashManagementId, false);

                paymentDialog(
                  onPressedForCancel: controller.cancellingPayment.isTrue
                      ? null
                      : () {
                          controller.cancelPayment(cashManagementId);
                        },
                  canEdit: true,
                  constraints: constraints,
                  controller: controller,
                  onPressedForPost: controller.postingPayment.isTrue
                      ? null
                      : () {
                          controller.postPayment(cashManagementId);
                        },
                  onPressedForSave: controller.addingNewValue.value
                      ? null
                      : () {
                          if (controller.status.value == 'Posted') {
                            showSnackBar(
                              'Alert',
                              'Only cew payments can be edited',
                            );
                            return;
                          }
                          controller.editPayment(cashManagementId);
                        },
                  onPressedForDelete: () {
                    alertDialog(
                      context: context,
                      content: "This will be deleted permanently",
                      onPressed: () {
                        controller.deletePayment(cashManagementId);
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

Widget tableOfScreensForCashManagement({
  required BoxConstraints constraints,
  required BuildContext context,
  required CashManagementPaymentsController controller,
  required RxList<DocumentSnapshot> data,
  required ScrollController scrollController,
}) {
  final dataSource = CardDataSource(
    cards: data,
    context: context,
    constraints: constraints,
    controller: controller,
  );
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
          const DataColumn(
            label: SizedBox(),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              text: 'Payment Number',
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
              text: 'Payment Date',
            ),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Vendor Name'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Payment Type',
            ),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Account'),
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Bank Name'),
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
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(constraints: constraints, text: 'Paid'),
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
  CashManagementPaymentsController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        editSectionForPayments(
          context,
          controller,
          cashManagementData,
          constraints,
          cashManagementId,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: cashManagementData['payment_number'] ?? '',

          formatDouble: false,
        ),
      ),
      DataCell(
        cashManagementData['status'] != ''
            ? statusBox(
                cashManagementData['status'],
                hieght: 35,
                padding: const EdgeInsets.all(0),
              )
            : const SizedBox(),
      ),
      DataCell(
        textForDataRowInTable(
          text:
              cashManagementData['payment_date'] != null &&
                  cashManagementData['payment_date'] != ''
              ? textToDate(cashManagementData['payment_date']) //
              : 'N/A',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: getdataName(
            cashManagementData['vendor'],
            controller.allVendors,
            title: 'entity_name',
          ),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: '',
          // getdataName(
          //   cashManagementData['payment_type'],
          //   controller.allReceiptTypes,
          // ),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: '',
          //  getdataName(
          //   cashManagementData['account'],
          //   controller.allAccounts,
          //   title: 'account_number',
          // ),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: getdataName(
            cashManagementData['bank_name'],
            controller.allBanks,
          ),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData['cheque_number'],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text:
              cashManagementData['cheque_date'] != null &&
                  cashManagementData['cheque_date'] != ''
              ? textToDate(cashManagementData['cheque_date']) //
              : 'N/A',
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: FutureBuilder<double>(
            future: controller.getPaymentPaidAmount(cashManagementId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  color: Colors.red,
                  isBold: true,
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<DocumentSnapshot> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final CashManagementPaymentsController controller;

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
    final cardData = trade.data() as Map<String, dynamic>;
    final cardId = trade.id;

    return dataRowForTheTable(
      cardData,
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
