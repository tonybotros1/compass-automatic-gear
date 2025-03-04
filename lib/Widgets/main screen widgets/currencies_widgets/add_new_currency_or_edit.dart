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
        SizedBox(
          height: 10,
        ),
        GetX<CurrencyController>(builder: (controller) {
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
              return ListTile(
                  title: Text('${value["currency_code"]} (${value['name']})'));
            },
          );
        }),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          isEnabled: false,
          obscureText: false,
          controller: controller.name,
          labelText: 'Name',
          hintText: 'Enter Name',
          validate: false,
        ),
        SizedBox(
          height: 10,
        ),
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
