import 'package:datahubai/Controllers/Main%20screen%20controllers/currency_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../drop_down_menu.dart';

Widget addNewCurrencyOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CurrencyController controller,
  bool? canEdit = true,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 200,
    child: ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        GetX<CurrencyController>(builder: (controller) {
          bool isCountryLoading = controller.allCountries.isEmpty;
          return dropDownValues(
            listValues: controller.allCountries.values
                .map((value) => '${value['currency_code']}'.toString())
                .toList(),
            textController: controller.code,
            onSelected: (suggestion) {
              controller.name.text = suggestion['currency_name'];
              controller.code.text = '${suggestion['currency_code']}';
              controller.allCountries.entries.where((entry) {
                return entry.value['currency_code'] ==
                        suggestion['currency_code'].toString() &&
                    entry.value['currency_name'] == suggestion['currency_name'];
              }).forEach((entry) {
                controller.countryId.value = entry.key;
              });
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(
                    '${suggestion['currency_code']} (${suggestion['currency_name']})'),
              );
            },
            labelText: 'Code',
            hintText: 'Select Code',
            menus: isCountryLoading ? {} : controller.allCountries,
            validate: true,
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
          validate: true,
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
