import 'package:flutter/material.dart';

import '../drop_down_menu.dart';
import 'smart_field.dart';

Widget addressField({
  required String labelTextForLine,
  required String hintTextForLine,
  required bool validateForLine,
  required void Function(String) onChangedForLine,
  required TextEditingController? textControllerForCountry,
  required TextEditingController? textControllerForCity,
  required String labelTextForCountry,
  required String labelTextForCity,
  required String hintTextForCountry,
  required String hintTextForCity,
  required bool validateForCountry,
  required bool validateForcity,
  required Map countryValues,
  required Map cityValues,
  required Widget Function(BuildContext, dynamic) itemBuilder,
  required void Function(dynamic)? onSelectedForCountry,
  required void Function(dynamic)? onSelectedForCity,
  required controller,
}) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: typeSection(
            labelText: labelTextForLine,
            hintText: hintTextForLine,
            validate: validateForLine,
            onChanged: onChangedForLine),
      ),
      SizedBox(
        width: 5,
      ),
      Expanded(
        child: dropDownValues(
            textController: textControllerForCountry,
            labelText: labelTextForCountry,
            hintText: hintTextForCountry,
            menus: countryValues,
            validate: validateForCountry,
            itemBuilder: itemBuilder,
            onSelected: onSelectedForCountry),
      ),
      SizedBox(
        width: 5,
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: Expanded(
          child: dropDownValues(
              textController: textControllerForCity,
              labelText: labelTextForCity,
              hintText: hintTextForCity,
              menus: cityValues,
              validate: validateForcity,
              itemBuilder: itemBuilder,
              onSelected: onSelectedForCity),
        ),
      ),
    ],
  );
}
