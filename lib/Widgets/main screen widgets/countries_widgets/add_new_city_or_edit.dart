import 'package:datahubai/Controllers/Main%20screen%20controllers/countries_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewCityOrEdit({
  required CountriesController controller,
  bool? isEnabled,
}) {
  return Form(
    key: controller.formKeyForAddingNewvalue,
    child: ListView(
      children: [
        myTextFormFieldWithBorder(
          obscureText: false,
          controller:  controller.cityCode,
          labelText: 'City Code',
          hintText: 'Enter City Code',
          validate: true,
          isEnabled: isEnabled
        ),
        const SizedBox(
          height: 20,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller:  controller.cityName,
          labelText: 'City Name',
          hintText: 'Enter City name',
          validate: true,
        ),
      ],
    ),
  );
}
