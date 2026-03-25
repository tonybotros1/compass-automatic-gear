import 'package:datahubai/Controllers/Main%20screen%20controllers/batch_payment_process_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Widget accountInformation(BuildContext context, BoxConstraints constraints) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    height: 280,
    child: GetX<BatchPaymentProcessController>(
      builder: (controller) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<BatchPaymentProcessController>(
                builder: (controller) {
                  return MenuWithValues(
                    labelText: 'Payment Type',
                    headerLqabel: 'Payment Types',
                    dialogWidth: constraints.maxWidth / 3,
                    width: 200,
                    controller: controller.paymentType,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onOpen: () {
                      return controller.getReceiptsAndPaymentsTypes();
                    },
                    onDelete: () {
                      controller.paymentType.clear();
                      controller.paymentTypeId.value = '';
                      controller.isChequeSelected.value = false;
                      controller.chequeDate.clear();
                      controller.chequeNumber.clear();
                      controller.bankName.clear();
                    },
                    onSelected: (value) async {
                      controller.paymentType.text = value['name'];
                      controller.paymentTypeId.value = value['_id'];
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
                    width: 200,
                    controller: controller.chequeNumber,
                    isEnabled: controller.isChequeSelected.isTrue,
                    labelText: 'Cheque Number',
                  ),

                  myTextFormFieldWithBorder(
                    width: 200,
                    suffixIcon: ExcludeFocus(
                      child: IconButton(
                        onPressed: () {
                          selectDateContext(context, controller.chequeDate);
                        },
                        icon: const Icon(Icons.date_range),
                      ),
                    ),
                    onFieldSubmitted: (_) async {
                      normalizeDate(
                        controller.chequeDate.text,
                        controller.chequeDate,
                      );
                    },
                    controller: controller.chequeDate,
                    isEnabled: controller.isChequeSelected.isTrue,
                    labelText: 'Cheque Date',
                    isDate: true,
                    onChanged: (_) {},
                  ),
                ],
              ),
              GetBuilder<BatchPaymentProcessController>(
                builder: (controller) {
                  return MenuWithValues(
                    labelText: 'Account',
                    headerLqabel: 'Accounts',
                    dialogWidth: constraints.maxWidth / 3,
                    width: 260,
                    controller: controller.account,
                    displayKeys: const ['account_number'],
                    displaySelectedKeys: const ['account_number'],
                    onOpen: () {
                      return controller.getAllAccounts();
                    },
                    onDelete: () {
                      controller.account.clear();
                      controller.accountId.value = '';
                      controller.currency.clear();
                      controller.rate.clear();
                    },
                    onSelected: (value) async {
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
                    moneyFormat: true,
                    // isDouble: true,
                    controller: controller.rate,
                    labelText: 'Rate',
                    onChanged: (_) {},
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
