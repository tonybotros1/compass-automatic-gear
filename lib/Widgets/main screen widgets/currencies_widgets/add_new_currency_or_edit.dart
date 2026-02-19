import 'package:datahubai/Controllers/Main%20screen%20controllers/currency_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../menu_dialog.dart';

Widget addNewCurrencyOrEdit({
  required CurrencyController controller,
  required bool canEdit,
}) {
  return Form(
    key: controller.formKeyForAddingNewvalue,
    child: ListView(
      children: [
        const SizedBox(height: 10),
        MenuWithValues(
          labelText: 'Code',
          headerLqabel: 'Code',
          dialogWidth: 600,
          controller: controller.code,
          displayKeys: const ['currency_code', 'name'],
          displaySelectedKeys: const ['currency_code', 'name'],
          onOpen: () {
            return controller.getCountries();
          },
          onDelete: () {
            controller.name.clear();
            controller.countryId.value = "";
          },
          onSelected: (value) {
            controller.name.text = value['currency_name'];
            controller.countryId.value = value['_id'];
          },
        ),
        const SizedBox(height: 10),
        myTextFormFieldWithBorder(
          isEnabled: false,
          obscureText: false,
          controller: controller.name,
          labelText: 'Name',
          validate: false,
        ),
        const SizedBox(height: 10),
        myTextFormFieldWithBorder(
          isDouble: true,
          obscureText: false,
          controller: controller.rate,
          labelText: 'Rate',
          validate: true,
        ),
      ],
    ),
  );
}
