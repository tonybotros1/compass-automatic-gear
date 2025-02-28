import 'package:datahubai/Controllers/Main%20screen%20controllers/currency_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../drop_down_menu3.dart';

Widget addNewCurrencyOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CurrencyController controller,
  bool? canEdit = true,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 250,
    child: Form(
      key: controller.formKeyForAddingNewvalue,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          GetX<CurrencyController>(builder: (controller) {
            bool isCountryLoading = controller.allCountries.isEmpty;
            return CustomDropdown(
              // enabled: false,
              textcontroller: controller.code.text,
              validator: true,
              showedSelectedName: 'code',
              onChanged: (key, value) {
                controller.name.text = value['currency_name'];
                controller.countryId.value = key;
              },
              hintText: 'Code',
              items: isCountryLoading ? {} : controller.allCountries,
              itemBuilder: (context, key, value) {
                return ListTile(
                    title: Text('${value["code"]} (${value['name']})'));
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
    ),
  );
}
