import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';
import '../add_new_values_button.dart';

Widget accountInformations<T extends CashManagementBaseController>(
  BuildContext context,
  bool isPayment,
  T controller,
  BoxConstraints constraints,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: GetX<T>(
      builder: (controller) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<T>(
                builder: (controller) {
                  return MenuWithValues(
                    labelText: isPayment ? 'Payment Type' : 'Receipt Type',
                    headerLqabel: isPayment ? 'Payment Types' : 'Receipt Types',
                    dialogWidth: constraints.maxWidth / 3,
                    width: 200,
                    controller: isPayment
                        ? controller.paymentType
                        : controller.receiptType,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onOpen: () {
                      return controller.getReceiptsAndPaymentsTypes();
                    },
                    onDelete: () {
                      controller.isReceiptModified.value = true;
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                        controller.paymentType.clear();
                        controller.paymentTypeId.value = '';
                      } else {
                        controller.receiptTypeId.value = '';
                        controller.receiptType.clear();
                        controller.isReceiptModified.value = true;
                      }
                      controller.isChequeSelected.value = false;
                      controller.chequeDate.clear();
                      controller.chequeNumber.clear();
                      controller.bankName.clear();
                    },
                    onSelected: (value) async {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                        controller.paymentType.text = value['name'];
                        controller.paymentTypeId.value = value['_id'];
                      } else {
                        controller.receiptTypeId.value = value['_id'];
                        controller.receiptType.text = value['name'];
                        controller.isReceiptModified.value = true;
                      }
                      if (value['name'].toLowerCase() == 'cheque') {
                        controller.isChequeSelected.value = true;
                        controller.chequeDate.text = textToDate(
                          DateTime.now().toString(),
                        );
                      } else {
                        controller.isChequeSelected.value = false;
                        controller.chequeDate.clear();
                        controller.chequeNumber.clear();
                        controller.bankName.clear();
                      }
                    },
                  );
                },
              ),
              Row(
                spacing: 10,
                children: [
                  myTextFormFieldWithBorder(
                    focusNode: controller.focusNodeForAccountInfos2,
                    onFieldSubmitted: (_) {
                      controller.focusNodeForAccountInfos3.requestFocus();
                    },
                    width: 200,
                    controller: controller.chequeNumber,
                    isEnabled: controller.isChequeSelected.isTrue,
                    labelText: 'Cheque Number',
                    onChanged: (_) {
                      controller.isReceiptModified.value = true;
                    },
                  ),
                  isPayment
                      ? const SizedBox()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MenuWithValues(
                              labelText: 'Bank Name',
                              headerLqabel: 'Banks Names',
                              dialogWidth: constraints.maxWidth / 3,
                              isEnabled: controller.isChequeSelected.isTrue,
                              width: 300,
                              controller: controller.bankName,
                              displayKeys: const ['name'],
                              displaySelectedKeys: const ['name'],
                              onOpen: () {
                                return controller.getBanks();
                              },
                              onDelete: () {
                                controller.isReceiptModified.value = true;
                                controller.bankId.value = '';
                                controller.bankName.clear();
                              },
                              onSelected: (value) async {
                                controller.isReceiptModified.value = true;
                                controller.bankId.value = value['_id'];
                                controller.bankName.text = value['name'];
                              },
                            ),
                            ExcludeFocus(
                              child: valSectionInTheTable(
                                isEnabled: controller.isChequeSelected.isTrue,
                                controller.listOfValuesController,
                                constraints,
                                'BANKS',
                                'New Bank',
                                'Banks',
                              ),
                            ),
                          ],
                        ),
                  myTextFormFieldWithBorder(
                    focusNode: controller.focusNodeForAccountInfos4,

                    width: 200,
                    suffixIcon: ExcludeFocus(
                      child: IconButton(
                        onPressed: () {
                          if (isPayment) {
                            controller.isPaymentModified.value = true;
                          } else {
                            controller.isReceiptModified.value = true;
                          }
                          controller.selectDateContext(
                            context,
                            controller.chequeDate,
                          );
                        },
                        icon: const Icon(Icons.date_range),
                      ),
                    ),
                    onFieldSubmitted: (_) async {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                      } else {
                        controller.isReceiptModified.value = true;
                      }
                      normalizeDate(
                        controller.chequeDate.text,
                        controller.chequeDate,
                      );
                      controller.focusNodeForAccountInfos5.requestFocus();
                    },
                    controller: controller.chequeDate,
                    isEnabled: controller.isChequeSelected.isTrue,
                    labelText: 'Cheque Date',
                    isDate: true,
                    onChanged: (_) {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                      } else {
                        controller.isReceiptModified.value = true;
                      }
                    },
                  ),
                ],
              ),
              GetBuilder<T>(
                builder: (controller) {
                  return MenuWithValues(
                    labelText: 'Account',
                    headerLqabel: 'Accounts',
                    dialogWidth: constraints.maxWidth / 3,
                    isEnabled: controller.isChequeSelected.isTrue,
                    width: 260,
                    controller: controller.account,
                    displayKeys: const ['account_number'],
                    displaySelectedKeys: const ['account_number'],
                    onOpen: () {
                      return controller.getAllAccounts();
                    },
                    onDelete: () {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                      } else {
                        controller.isReceiptModified.value = true;
                      }
                      controller.account.clear();
                      controller.accountId.value = '';
                      controller.currency.clear();
                      controller.rate.clear();
                    },
                    onSelected: (value) async {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                      } else {
                        controller.isReceiptModified.value = true;
                      }
                      controller.account.text = value['account_number'];
                      controller.accountId.value = value['_id'];
                      controller.currency.text = value['currency'];
                      controller.rate.text = '${value['rate']}';
                    },
                  );
                },
              ),
              Row(
                spacing: 10,
                children: [
                  myTextFormFieldWithBorder(
                    width: 125,
                    isEnabled: false,
                    controller: controller.currency,
                    labelText: 'Currency',
                  ),
                  myTextFormFieldWithBorder(
                    width: 125,
                    focusNode: controller.focusNodeForAccountInfos6,

                    moneyFormat: true,
                    // isDouble: true,
                    controller: controller.rate,
                    labelText: 'Rate',
                    onChanged: (_) {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                      } else {
                        controller.isReceiptModified.value = true;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
