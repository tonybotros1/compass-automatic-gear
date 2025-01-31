import 'package:datahubai/Controllers/Main%20screen%20controllers/currency_controller.dart';
import 'package:flutter/material.dart';

import '../../Auth screens widgets/register widgets/my_text_form_field.dart';

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
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: controller.code,
          labelText: 'Code',
          hintText: 'Enter Code',
          validate: true,
          canEdit: canEdit,
        ),
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: controller.name,
          labelText: 'Name',
          hintText: 'Enter Name',
          validate: true,
        ),
        myTextFormField(
          isDouble: true,
          constraints: constraints,
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
