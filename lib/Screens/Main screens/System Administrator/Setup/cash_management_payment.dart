import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/cash_management_widgets/payment_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';
import 'cash_management_receipts.dart';

class CashManagementPayment extends StatelessWidget {
  const CashManagementPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          return Padding(
              padding: screenPadding,
              child: SingleChildScrollView(
                  child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    GetX<CashManagementController>(
                        init: CashManagementController(),
                        builder: (controller) {
                          bool isCustomersLoading =
                              controller.allCustomers.isEmpty;
                          bool isReceiptTypesLoading =
                              controller.allReceiptTypes.isEmpty;
                          bool isAccountLoading =
                              controller.allAccounts.isEmpty;
                          return Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                  child: myTextFormFieldWithBorder(
                                labelText: 'Payment NO.',
                                controller:
                                    controller.receiptCounterFilter.value,
                              )),
                              Expanded(
                                child: CustomDropdown(
                                  showedSelectedName: 'name',
                                  textcontroller:
                                      controller.receiptTypeFilter.value.text,
                                  hintText: 'Payment Type',
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
                                  hintText: 'Vendor Name',
                                  items: isCustomersLoading
                                      ? {}
                                      : controller.allVendors,
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
                                    await normalizeDate(
                                        controller.fromDate.value.text,
                                        controller.fromDate.value);
                                  },
                                )),
                                Expanded(
                                    child: myTextFormFieldWithBorder(
                                  controller: controller.toDate.value,
                                  labelText: 'To Date',
                                  onFieldSubmitted: (_) async {
                                    await normalizeDate(
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
                                      controller.isThisYearSelected.value =
                                          false;

                                      controller.searchEngineForPayments();
                                    },
                                    child: Text('All')),
                                ElevatedButton(
                                    style: todayButtonStyle,
                                    onPressed: controller
                                            .isTodaySelected.isFalse
                                        ? () {
                                            controller.isAllSelected.value =
                                                false;
                                            controller.isTodaySelected.value =
                                                true;
                                            controller.isThisMonthSelected
                                                .value = false;
                                            controller.isThisYearSelected
                                                .value = false;
                                            controller.isYearSelected.value =
                                                false;
                                            controller.isMonthSelected.value =
                                                false;
                                            controller.isDaySelected.value =
                                                true;
                                            controller
                                                .searchEngineForPayments();
                                          }
                                        : null,
                                    child: Text('Today')),
                                ElevatedButton(
                                    style: thisMonthButtonStyle,
                                    onPressed: controller
                                            .isThisMonthSelected.isFalse
                                        ? () {
                                            controller.isAllSelected.value =
                                                false;
                                            controller.isTodaySelected.value =
                                                false;
                                            controller.isThisMonthSelected
                                                .value = true;
                                            controller.isThisYearSelected
                                                .value = false;
                                            controller.isYearSelected.value =
                                                false;
                                            controller.isMonthSelected.value =
                                                true;
                                            controller.isDaySelected.value =
                                                false;
                                            controller
                                                .searchEngineForPayments();
                                          }
                                        : null,
                                    child: Text('This Month')),
                                ElevatedButton(
                                    style: thisYearButtonStyle,
                                    onPressed: controller
                                            .isThisYearSelected.isFalse
                                        ? () {
                                            controller.isTodaySelected.value =
                                                false;
                                            controller.isThisMonthSelected
                                                .value = false;
                                            controller.isThisYearSelected
                                                .value = true;
                                            controller.isYearSelected.value =
                                                true;
                                            controller.isMonthSelected.value =
                                                false;
                                            controller.isDaySelected.value =
                                                false;
                                            controller
                                                .searchEngineForPayments();
                                          }
                                        : null,
                                    child: Text('This Year')),
                                ElevatedButton(
                                    style: saveButtonStyle,
                                    onPressed: controller
                                            .isThisYearSelected.isFalse
                                        ? () async {
                                            await controller.removeFilters();
                                            controller
                                                .searchEngineForPayments();
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
                          Expanded(flex: 2, child: SizedBox()),
                          newPaymentButton(context, constraints, controller)
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
                                    title: 'NUMBER OF PAYMENTS',
                                    value: textForDataRowInTable(
                                        fontSize: 16,
                                        color: mainColor,
                                        isBold: true,
                                        text:
                                            '${controller.numberOfPayments.value}',
                                        formatDouble: false)),
                                customBox(
                                    title: 'PAID',
                                    value: textForDataRowInTable(
                                      fontSize: 16,
                                      color: Colors.red,
                                      isBold: true,
                                      text:
                                          '${controller.totalPaymentPaid.value}',
                                    )),
                              ],
                            ),
                          ),
                          Expanded(child: SizedBox())
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
                                isPayment: true),
                          );
                        },
                      ),
                    ),
                  ])));
        }));
  }
}

ElevatedButton newPaymentButton(BuildContext context,
    BoxConstraints constraints, CashManagementController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      paymentDialog(
          onPressedForDelete: null,
          context: context,
          canEdit: true,
          constraints: constraints,
          controller: controller,
          onPressedForCancel: null,
          onPressedForPost: controller.postingReceipts.isTrue
              ? null
              : () {
                  controller.postPayment(controller.currentPaymentID.value);
                },
          onPressedForSave: controller.addingNewValue.value
              ? null
              : () {
                  controller.addNewPayment();
                });
    },
    style: newButtonStyle,
    child: const Text('New Payment'),
  );
}

Widget editSectionForPayments(context, CashManagementController controller,
    Map<String, dynamic> cashManagementData, constraints, cashManagementId) {
  return GetX<CashManagementController>(builder: (controller) {
    bool isLoading = controller.buttonLoadingStates[cashManagementId] ?? false;

    return IconButton(
        onPressed: controller.buttonLoadingStates[cashManagementId] == null ||
                isLoading == false
            ? () async {
                controller.setButtonLoading(cashManagementId, true);

                await controller.loadValuesForPayments(cashManagementData);
                controller.setButtonLoading(cashManagementId, false);

                paymentDialog(
                  onPressedForCancel: controller.cancellingReceipts.isTrue
                      ? null
                      : () {
                          controller.cancelPayment(cashManagementId);
                        },
                  context: context,
                  canEdit: true,
                  constraints: constraints,
                  controller: controller,
                  onPressedForPost: controller.postingReceipts.isTrue
                      ? null
                      : () {
                          controller.postPayment(cashManagementId);
                        },
                  onPressedForSave: controller.addingNewValue.value
                      ? null
                      : () {
                          if (controller.status.value == 'Posted') {
                            showSnackBar(
                                'Alert', 'Only New Receipts Can be Edited');
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
                        });
                  },
                );
              }
            : null,
        icon: isLoading ? loadingProcess : editIcon);
  });
}
