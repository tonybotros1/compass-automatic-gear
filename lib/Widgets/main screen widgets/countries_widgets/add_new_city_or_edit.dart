import 'package:datahubai/Controllers/Main%20screen%20controllers/countries_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewCityOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CountriesController controller,
  TextEditingController? valueName,
  TextEditingController? valueCode,
  TextEditingController? restrictedBy,
  bool? isEnabled,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 200,
    child: Form(
      key: controller.formKeyForAddingNewvalue,
      child: ListView(
        children: [
          myTextFormFieldWithBorder(
            obscureText: false,
            controller: valueName ?? controller.cityCode,
            labelText: 'City Code',
            hintText: 'Enter City Code',
            validate: true,
            isEnabled: isEnabled
          ),
          SizedBox(
            height: 20,
          ),
          myTextFormFieldWithBorder(
            obscureText: false,
            controller: valueName ?? controller.cityName,
            labelText: 'City Name',
            hintText: 'Enter City name',
            validate: true,
          ),
        ],
      ),
    ),
  );
}
