import 'package:datahubai/Controllers/Main%20screen%20controllers/banks_and_others_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../my_text_field.dart';

Widget addNewBankOrEdit({
  required BanksAndOthersController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(height: 5),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.accountName.value,
        labelText: 'Account Name',
        validate: true,
      ),
      const SizedBox(height: 10),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.accountNumber.value,
        labelText: 'Account Number',
        validate: true,
      ),
      const SizedBox(height: 10),
      GetX<BanksAndOthersController>(
        builder: (controller) {
          var isCurrencyLoading = controller.allCurrencies.isEmpty;
          return CustomDropdown(
            showedSelectedName: 'currency_code',
            textcontroller: controller.currency.value.text,
            hintText: isCurrencyLoading ? 'Loading...' : 'Currency',
            items: isCurrencyLoading ? {} : controller.allCurrencies,
            onChanged: (key, value) {
              controller.currency.value.text = value['currency_code'];
              controller.currencyId.value = key;
            },onDelete: (){
               controller.currency.value.clear();
              controller.currencyId.value = '';
            },
          );
        },
      ),
      const SizedBox(height: 10),
      GetX<BanksAndOthersController>(
        builder: (controller) {
          var isAccountTypesLoading = controller.allAccountTypes.isEmpty;

          return CustomDropdown(
            hintText: 'Account Type',
            textcontroller: controller.accountType.value.text,
            showedSelectedName: 'name',
            items: isAccountTypesLoading ? {} : controller.allAccountTypes,
            onChanged: (key, value) {
              controller.accountType.value.text = value['name'];
              controller.accountTypeId.value = key;
            },onDelete: (){
              controller.accountType.value.clear();
              controller.accountTypeId.value = '';
            },
          );
        },
      ),
    ],
  );
}
