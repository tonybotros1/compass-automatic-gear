import 'package:datahubai/Controllers/Main%20screen%20controllers/currency_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';

Widget addNewCurrencyOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CurrencyController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 200,
    child: ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.code,
          labelText: 'Code',
          hintText: 'Enter Code',
          validate: true,
          isEnabled: canEdit,
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
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
