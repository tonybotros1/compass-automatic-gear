import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget accountInformations(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CashManagementController>(builder: (controller) {
      bool isReceiptTypesLoading = controller.allReceiptTypes.isEmpty;
      bool isAccountsLoading = controller.allAccounts.isEmpty;
      bool isBanksLoading = controller.allBanks.isEmpty;
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropdown(
                  textcontroller: controller.receiptType.text,
                  showedSelectedName: 'name',
                  hintText: 'Receipt Type',
                  items:
                      isReceiptTypesLoading ? {} : controller.allReceiptTypes,
                  itemBuilder: (context, key, value) {
                    return ListTile(
                      title: Text(value['name']),
                    );
                  },
                  onChanged: (key, value) {
                    controller.receiptTypeId.value = key;
                    controller.receiptType.text = value['name'];
                    if (value['name'] == 'Cheque') {
                      controller.isChequeSelected.value = true;
                      controller.chequeDate.text =
                          textToDate(DateTime.now().toString());
                    } else {
                      controller.isChequeSelected.value = false;
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: const SizedBox(),
              ),
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
                ),
              ),
              Expanded(
                  child: CustomDropdown(
                hintText: 'Bank Name',
                enabled: controller.isChequeSelected.isTrue,
                textcontroller: controller.bankName.text,
                showedSelectedName: 'name',
                items: isBanksLoading ? {} : controller.allBanks,
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text(value['name']),
                  );
                },
                onChanged: (key, value) {
                  controller.bankId.value = key;
                  controller.bankName.text = value['name'];
                },
              )),
              Expanded(
                child: myTextFormFieldWithBorder(
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.selectDateContext(
                            context, controller.chequeDate);
                      },
                      icon: const Icon(Icons.date_range)),
                  controller: controller.chequeDate,
                  isEnabled: controller.isChequeSelected.isTrue,
                  labelText: 'Cheque Date',
                  isDate: true,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomDropdown(
                  textcontroller: controller.account.text,
                  hintText: 'Account',
                  showedSelectedName: 'account_number',
                  items: isAccountsLoading ? {} : controller.allAccounts,
                  itemBuilder: (context, key, value) {
                    return ListTile(
                      title: Text(value['account_number']),
                    );
                  },
                  onChanged: (key, value) async {
                    controller.account.text = value['account_number'];
                    controller.accountId.value = key;
                    controller.currency.text =
                        await controller.getCurrencyName(value['country_id']);
                    controller.rate.text =
                        await controller.getCurrencyRate(value['currency']);
                  },
                ),
              ),
              Expanded(flex: 1, child: SizedBox())
            ],
          ),
          Row(
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
                  isDouble: true,
                  controller: controller.rate,
                  labelText: 'Rate',
                ),
              ),
              Expanded(flex: 1, child: SizedBox())
            ],
          ),
        ],
      );
    }),
  );
}
