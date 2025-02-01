import 'package:datahubai/Controllers/Main%20screen%20controllers/functions_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewScreenOrView({
  required BoxConstraints constraints,
  required BuildContext context,
  required FunctionsController controller,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 150,
    child: ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller:  controller.screenName,
          labelText: 'Screen Name',
          hintText: 'Enter Screen name',
          keyboardType: TextInputType.name,
          validate: true,
        ),
        SizedBox(
          height: 20,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller:  controller.route,
          labelText: 'Route',
          hintText: 'Enter route name',
          keyboardType: TextInputType.emailAddress,
          validate: true,
        ),
      ],
    ),
  );
}
