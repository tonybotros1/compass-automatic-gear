import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/system_variables_controller.dart';
import '../../my_text_field.dart';

Widget addNewVariableOrEdit({
  required SystemVariablesController controller,
  bool? canEdit = true,
}) {
  return ListView(
    children: [
      myTextFormFieldWithBorder(
        obscureText: false,
        controller:  controller.code,
        labelText: 'Code',
        hintText: 'Enter Variable Code',
        keyboardType: TextInputType.name,
        validate: true,
        isEnabled: canEdit,
      ),
      SizedBox(
        height: 20,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller:  controller.value,
        labelText: 'Value',
        hintText: 'Enter Variable Value',
        keyboardType: TextInputType.emailAddress,
        validate: true,
      ),
    ],
  );
}
