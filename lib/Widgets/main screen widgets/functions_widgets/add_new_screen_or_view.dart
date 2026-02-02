import 'package:datahubai/Controllers/Main%20screen%20controllers/functions_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewScreenOrView({
  required FunctionsController controller,
}) {
  return ListView(
    children: [
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.screenName,
        labelText: 'Screen Name',
        keyboardType: TextInputType.name,
        validate: true,
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.route,
        labelText: 'Route',
        validate: true,
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        maxLines: 4,
        obscureText: false,
        controller: controller.description,
        labelText: 'Description',
        keyboardType: TextInputType.text,
        validate: true,
      ),
    ],
  );
}
