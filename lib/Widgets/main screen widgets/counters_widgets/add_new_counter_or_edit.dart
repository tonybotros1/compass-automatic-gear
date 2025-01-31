import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/counters_controller.dart';
import '../../Auth screens widgets/register widgets/my_text_form_field.dart';

Widget addNewConterOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CountersController controller,
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
          hintText: 'Enter Counter Code',
          validate: true,
          canEdit: canEdit,
        ),
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: controller.description,
          labelText: 'Description',
          hintText: 'Enter counter Description',
          validate: true,
        ),
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: controller.prefix,
          labelText: 'Prefix',
          hintText: 'Enter counter Prefix',
          validate: true,
        ),
        myTextFormField(
          isnumber: true,
          constraints: constraints,
          obscureText: false,
          controller: controller.value,
          labelText: 'Value',
          hintText: 'Enter counter Value',
          validate: true,
        ),
      ],
    ),
  );
}
