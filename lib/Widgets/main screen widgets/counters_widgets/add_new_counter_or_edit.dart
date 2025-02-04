import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/counters_controller.dart';
import '../../my_text_field.dart';

Widget addNewConterOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CountersController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 300,
    child: ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.code,
          labelText: 'Code',
          hintText: 'Enter Counter Code',
          validate: true,
          isEnabled: canEdit,
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.description,
          labelText: 'Description',
          hintText: 'Enter counter Description',
          validate: true,
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.prefix,
          labelText: 'Prefix',
          hintText: 'Enter counter Prefix',
          validate: true,
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          isnumber: true,
          obscureText: false,
          controller: controller.value,
          labelText: 'Value',
          hintText: 'Enter counter Value',
          validate: true,
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          isnumber: true,
          obscureText: false,
          controller: controller.length,
          labelText: 'Length',
          hintText: 'Enter value length',
          validate: true,
        ),
      ],
    ),
  );
}
