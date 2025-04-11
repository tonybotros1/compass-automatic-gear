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
      const SizedBox(
        height: 5,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.accountName.value,
        labelText: 'Account Name',
        validate: true,
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.accountNumber.value,
        labelText: 'Account Number',
        validate: true,
      ),
      const SizedBox(
        height: 10,
      ),
      GetX<BanksAndOthersController>(builder: (controller) {
        var isCurrencyLoading = controller.allCurrencies.isEmpty;
        return CustomDropdown(
          showedResult: (key, value) {
            String countryId = value['country_id'];
            String currency =
                controller.currencyNames[countryId] ?? 'Loading...';
            return Text(currency);
          },
          textcontroller: controller.currency.value.text,
          hintText: isCurrencyLoading ? 'Loading...' : 'Currency',
          items: isCurrencyLoading ? {} : controller.allCurrencies,
          itemBuilder: (context, key, value) {
            String countryId = value['country_id'];
            String currency =
                controller.currencyNames[countryId] ?? 'Loading...';
            return ListTile(title: Text(currency));
          },
          onChanged: (key, value) {
            String countryId = value['country_id'];
            String currency = controller.currencyNames[countryId] ?? '';
            controller.countryId.value = countryId;
            controller.currency.value.text = currency;
            controller.currencyId.value = key;
            // controller.currencyRate.value.text =
            //     (value['rate'] ?? '1').toString();
          },
        );
      }),
      const SizedBox(
        height: 10,
      ),
      GetX<BanksAndOthersController>(builder: (controller) {
        var isAccountTypesLoading = controller.allAccountTypes.isEmpty;

        return CustomDropdown(
          hintText: 'Account Type',
          textcontroller: controller.accountType.value.text,
          showedSelectedName: 'name',
          items: isAccountTypesLoading ? {} : controller.allAccountTypes,
          itemBuilder: (context, key, value) {
            return ListTile(
              title: Text(value['name']),
            );
          },
          onChanged: (key, value) {
            controller.accountType.value.text = value['name'];
            controller.accountTypeId.value = key;
          },
        );
      }),
    ],
  );
}
