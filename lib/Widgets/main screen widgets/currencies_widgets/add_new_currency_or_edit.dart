import 'package:datahubai/Controllers/Main%20screen%20controllers/currency_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../drop_down_menu3.dart';

Widget addNewCurrencyOrEdit({
  required CurrencyController controller,
  required bool canEdit,
}) {
  return Form(
    key: controller.formKeyForAddingNewvalue,
    child: ListView(
      children: [
        const SizedBox(height: 10),
        GetX<CurrencyController>(
          builder: (controller) {
            bool isCountryLoading = controller.allCountries.isEmpty;
            return CustomDropdown(
              textcontroller: controller.code.text,
              validator: true,
              showedSelectedName: 'currency_code',
              onChanged: (key, value) {
                controller.name.text = value['currency_name'];
                controller.countryId.value = key;
              },
              hintText: 'Code',
              items: isCountryLoading ? {} : controller.allCountries,
              itemBuilder: (context, key, value) {
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text('${value["currency_code"]} (${value['name']})'),
                );
              },
              onDelete: () {
                controller.name.clear();
                controller.countryId.value = "";
              },
            );
          },
        ),
        const SizedBox(height: 10),
        myTextFormFieldWithBorder(
          isEnabled: false,
          obscureText: false,
          controller: controller.name,
          labelText: 'Name',
          hintText: 'Enter Name',
          validate: false,
        ),
        const SizedBox(height: 10),
        myTextFormFieldWithBorder(
          isDouble: true,
          obscureText: false,
          controller: controller.rate,
          labelText: 'Rate',
          hintText: 'Enter Rate',
          validate: true,
        ),
      ],
    ),
  );
}
