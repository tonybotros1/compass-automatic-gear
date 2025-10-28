import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget accountInformations<T extends CashManagementBaseController>(
  BuildContext context,
  bool isPayment,
  T controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<T>(
      builder: (controller) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: CustomDropdown(
                    textcontroller: isPayment
                        ? controller.paymentType.text
                        : controller.receiptType.text,
                    showedSelectedName: 'name',
                    hintText: isPayment ? 'Payment Type' : 'Receipt Type',
                    onChanged: (key, value) {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                        controller.paymentType.text = value['name'];
                        controller.paymentTypeId.value = key;
                      } else {
                        controller.receiptTypeId.value = key;
                        controller.receiptType.text = value['name'];
                        controller.isReceiptModified.value = true;
                      }
                      if (value['name'] == 'Cheque') {
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
                    onOpen: () {
                      return controller.getReceiptsAndPaymentsTypes();
                    },
                  ),
                ),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
            // const SizedBox(height: 10),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    controller: controller.chequeNumber,
                    isEnabled: controller.isChequeSelected.isTrue,
                    labelText: 'Cheque Number',
                    onChanged: (_) {
                      controller.isReceiptModified.value = true;
                    },
                  ),
                ),
                isPayment
                    ? const SizedBox()
                    : Expanded(
                        flex: 2,
                        child: CustomDropdown(
                          hintText: 'Bank Name',
                          enabled: controller.isChequeSelected.isTrue,
                          textcontroller: controller.bankName.text,
                          showedSelectedName: 'name',
                          onChanged: (key, value) {
                            controller.isReceiptModified.value = true;
                            controller.bankId.value = key;
                            controller.bankName.text = value['name'];
                          },
                          onDelete: () {
                            controller.isReceiptModified.value = true;
                            controller.bankId.value = '';
                            controller.bankName.clear();
                          },
                          onOpen: () {
                            return controller.getBanks();
                          },
                        ),
                      ),
                Expanded(
                  child: myTextFormFieldWithBorder(
                    suffixIcon: IconButton(
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
                ),
                isPayment
                    ? const Expanded(flex: 2, child: SizedBox())
                    : const SizedBox(),
              ],
            ),
            // const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    textcontroller: controller.account.text,
                    hintText: 'Account',
                    showedSelectedName: 'account_number',
                    onChanged: (key, value) async {
                      if (isPayment) {
                        controller.isPaymentModified.value = true;
                      } else {
                        controller.isReceiptModified.value = true;
                      }
                      controller.account.text = value['account_number'];
                      controller.accountId.value = key;
                      controller.currency.text = value['currency'];
                      controller.rate.text = '${value['rate']}';
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
                    onOpen: () {
                      return controller.getAllAccounts();
                    },
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox()),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: myTextFormFieldWithBorder(
                          isEnabled: false,
                          controller: controller.currency,
                          labelText: 'Currency',
                        ),
                      ),
                      Expanded(
                        child: myTextFormFieldWithBorder(
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
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          ],
        );
      },
    ),
  );
}
