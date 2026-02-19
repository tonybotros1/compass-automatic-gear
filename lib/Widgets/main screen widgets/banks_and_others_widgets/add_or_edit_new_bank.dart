import 'package:datahubai/Controllers/Main%20screen%20controllers/banks_and_others_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../menu_dialog.dart';
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
          return MenuWithValues(
            labelText: 'Currency',
            headerLqabel: 'Currencies',
            dialogWidth: 600,
            width: 250,
            controller: controller.currency.value,
            displayKeys: const ['currency_code'],
            displaySelectedKeys: const ['currency_code'],
            data: isCurrencyLoading ? {} : controller.allCurrencies,
            onDelete: () {
              controller.currency.value.clear();
              controller.currencyId.value = '';
            },
            onSelected: (value) {
              controller.currency.value.text = value['currency_code'];
              controller.currencyId.value = value['_id'];
            },
          );
        },
      ),
      const SizedBox(height: 10),
      GetX<BanksAndOthersController>(
        builder: (controller) {
          var isAccountTypesLoading = controller.allAccountTypes.isEmpty;

          return MenuWithValues(
            labelText: 'Account Type',
            headerLqabel: 'Account Types',
            dialogWidth: 600,
            width: 250,
            controller: controller.accountType.value,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            data: isAccountTypesLoading ? {} : controller.allAccountTypes,
            onDelete: () {
              controller.accountType.value.clear();
              controller.accountTypeId.value = '';
            },
            onSelected: (value) {
              controller.accountType.value.text = value['name'];
              controller.accountTypeId.value = value['_id'];
            },
          );
          // CustomDropdown(
          //   hintText: 'Account Type',
          //   textcontroller: controller.accountType.value.text,
          //   showedSelectedName: 'name',
          //   items: isAccountTypesLoading ? {} : controller.allAccountTypes,
          //   onChanged: (key, value) {
          // controller.accountType.value.text = value['name'];
          // controller.accountTypeId.value = key;
          //   },
          //   onDelete: () {
          // controller.accountType.value.clear();
          // controller.accountTypeId.value = '';
          //   },
          // );
        },
      ),
    ],
  );
}
