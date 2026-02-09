import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/ap_payments_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/cash_management_payments_controller.dart';
import '../../../../Models/dynamic_boxes_line_model.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/dynamic_boxes_line.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetX<CashManagementPaymentsController>(
                    init: CashManagementPaymentsController(),
                    builder: (controller) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth - 28,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 150,
                                    labelText: 'Payment NO.',
                                    controller:
                                        controller.paymentCounterFilter.value,
                                  ),
                                  CustomDropdown(
                                    width: 200,
                                    showedSelectedName: 'name',
                                    textcontroller:
                                        controller.paymentTypeFilter.value.text,
                                    hintText: 'Payment Type',
                                    onChanged: (key, value) async {
                                      controller.paymentTypeFilterId.value =
                                          key;
                                      controller.paymentTypeFilter.value.text =
                                          value['name'];
                                    },
                                    onDelete: () {
                                      controller.paymentTypeFilterId.value = '';
                                      controller.paymentTypeFilter.value
                                          .clear();
                                    },
                                    onOpen: () {
                                      return controller
                                          .getReceiptsAndPaymentsTypes();
                                    },
                                  ),
                                  CustomDropdown(
                                    width: 300,
                                    showedSelectedName: 'entity_name',
                                    textcontroller:
                                        controller.vendorNameFilter.value.text,
                                    hintText: 'Vendor Name',
                                    onChanged: (key, value) async {
                                      controller.vendorNameFilterId.value = key;
                                      controller.vendorNameFilter.value.text =
                                          value['entity_name'];
                                    },
                                    onDelete: () {
                                      controller.vendorNameFilterId.value = '';
                                      controller.vendorNameFilter.value.clear();
                                    },
                                    onOpen: () {
                                      return controller.getAllVendors();
                                    },
                                  ),
                                  CustomDropdown(
                                    width: 250,
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
                                  myTextFormFieldWithBorder(
                                    width: 150,
                                    labelText: 'Cheque NO.',
                                    controller:
                                        controller.chequeNumberFilter.value,
                                  ),
                                  CustomDropdown(
                                    width: 150,
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
                                ],
                              ),
                              Row(
                                spacing: 10,
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
                  GetX<CashManagementPaymentsController>(
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
                            spacing: 10,
                            children: [
                              newPaymentButton(
                                context,
                                constraints,
                                controller,
                              ),
                              CustomSlidingSegmentedControl<int>(
                                height: 30,
                                initialValue: controller.initDatePickerValue.value,
                                children: const {
                                  1: Text('ALL'),
                                  2: Text('TODAY'),
                                  3: Text('THIS MONTH'),
                                  4: Text('THIS YEAR'),
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
                                  controller.onChooseForDatePicker(v);
                                },
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  ElevatedButton(
                                    style: findButtonStyle,
                                    onPressed:
                                        controller
                                            .isScreenLodingForPayments
                                            .isFalse
                                        ? () async {
                                            controller.filterSearch();
                                          }
                                        : null,
                                    child:
                                        controller
                                            .isScreenLodingForPayments
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
                    child: GetX<CashManagementPaymentsController>(
                      builder: (controller) {
                        return SizedBox(
                          height: 100,
                          child: dynamicBoxesLine(
                            dynamicConfigs: [
                              DynamicBoxesLineModel(
                                isFormated: false,
                                width: 300,
                                label: 'NUMBER OF PAYMENTS',
                                value: '${controller.numberOfPayments.value}',
                                valueColor: Colors.blue,
                                icon: Icons.numbers,
                                iconColor: Colors.blue.shade100,
                              ),
                              DynamicBoxesLineModel(
                                icon: Icons.payments,
                                iconColor: Colors.red.shade100,
                                width: 300,
                                label: 'PAID',
                                value: '${controller.totalPaymentPaid.value}',
                                valueColor: Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetX<CashManagementPaymentsController>(
                      builder: (controller) {
                        return SizedBox(
                          height: constraints.maxHeight * 0.73,
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
        onPressedForNewPage: () {
          controller.clearValues();
        },
        onPressedForDelete: null,
        canEdit: true,
        constraints: constraints,
        controller: controller,
        onPressedForCancel: null,
        onPressedForPost: () async {
          Map currentPaymentStatus = await controller.getCurrentAPPaymentStatus(
            controller.currentPaymentID.value,
          );
          String status1 = currentPaymentStatus['status'];
          if (status1 == 'Cancelled') {
            alertMessage(
              context: Get.context!,
              content: 'Can\'t post cancelled payments',
            );
            return;
          }
          if (status1 == 'Posted') {
            alertMessage(
              context: Get.context!,
              content: 'Status already posted',
            );
            return;
          }
          controller.paymentStatus.value = 'Posted';
          controller.isPaymentModified.value = true;
          controller.addNewPayment();
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
  APPaymentModel cashManagementData,
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
                  onPressedForNewPage: null,
                  onPressedForCancel: () async {
                    Map currentPaymentStatus = await controller
                        .getCurrentAPPaymentStatus(
                          controller.currentPaymentID.value,
                        );
                    String status1 = currentPaymentStatus['status'];
                    if (status1 == 'Posted') {
                      alertMessage(
                        context: Get.context!,
                        content: 'Can\'t cancel posted payments',
                      );
                      return;
                    }
                    if (status1 == 'Cancelled') {
                      alertMessage(
                        context: Get.context!,
                        content: 'Status already cancelled',
                      );
                      return;
                    }
                    controller.paymentStatus.value = 'Cancelled';
                    controller.isPaymentModified.value = true;
                    controller.addNewPayment();
                  },
                  canEdit: true,
                  constraints: constraints,
                  controller: controller,
                  onPressedForPost: () async {
                    Map currentPaymentStatus = await controller
                        .getCurrentAPPaymentStatus(
                          controller.currentPaymentID.value,
                        );
                    String status1 = currentPaymentStatus['status'];
                    if (status1 == 'Cancelled') {
                      alertMessage(
                        context: Get.context!,
                        content: 'Can\'t post cancelled payments',
                      );
                      return;
                    }
                    if (status1 == 'Posted') {
                      alertMessage(
                        context: Get.context!,
                        content: 'Status already posted',
                      );
                      return;
                    }
                    controller.paymentStatus.value = 'Posted';
                    controller.isPaymentModified.value = true;
                    controller.addNewPayment();
                  },
                  onPressedForSave: controller.addingNewValue.value
                      ? null
                      : () {
                          if (controller.status.value == 'Posted') {
                            alertMessage(
                              context: Get.context!,
                              content: 'Only cew payments can be edited',
                            );
                            return;
                          }
                          controller.addNewPayment();
                        },
                  onPressedForDelete: () async {
                    Map currentPaymentStatus = await controller
                        .getCurrentAPPaymentStatus(
                          controller.currentPaymentID.value,
                        );
                    String status1 = currentPaymentStatus['status'];
                    if (status1 != 'New') {
                      alertMessage(
                        context: Get.context!,
                        content: 'Only new payments can be deleted',
                      );
                      return;
                    }

                    alertDialog(
                      context: Get.context!,
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
  required RxList<APPaymentModel> data,
  required ScrollController scrollController,
}) {
  bool arePamentsLoading = data.isEmpty;

  return DataTableTheme(
    data: DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300;
        }
        return null;
      }),
    ),
    child: PaginatedDataTable2(
      showFirstLastButtons: true,
      columnSpacing: 5,
      lmRatio: 2.5,
      horizontalMargin: horizontalMarginForTable,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      autoRowsToHeight: true,
      columns: [
        const DataColumn2(
          size: ColumnSize.S,
          label: SizedBox(),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(
            text: 'Payment Number',
            constraints: constraints,
          ),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Status'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Payment Date'),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'Vendor Name'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Payment Type'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Account'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Cheque Number'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Cheque Date'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'Paid'),
          // onSort: controller.onSort,
        ),
      ],
      source: CardDataSource(
        cards: arePamentsLoading ? [] : data,
        context: context,
        constraints: constraints,
        controller: controller,
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  APPaymentModel cashManagementData,
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
          text: cashManagementData.paymentNumber ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        cashManagementData.status != ''
            ? statusBox(cashManagementData.status ?? '', hieght: 35)
            : const SizedBox(),
      ),
      DataCell(
        textForDataRowInTable(text: textToDate(cashManagementData.paymentDate)),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData.vendorName ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: cashManagementData.paymentTypeName ?? '',
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
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: textToDate(cashManagementData.chequeDate),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.red,
          isBold: true,
          text: cashManagementData.totalGiven.toString(),
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<APPaymentModel> cards;
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

    final payment = cards[index];
    final cardId = payment.id;

    return dataRowForTheTable(
      payment,
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
