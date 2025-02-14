import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/system_variables_controller.dart';
import '../../my_text_field.dart';

Widget addNewVariableOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required SystemVariablesController controller,
  TextEditingController? code,
  TextEditingController? value,
  bool? canEdit = true,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 150,
    child: ListView(
      children: [
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: code ?? controller.code,
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
          controller: value ?? controller.value,
          labelText: 'Value',
          hintText: 'Enter Variable Value',
          keyboardType: TextInputType.emailAddress,
          validate: true,
        ),
      ],
    ),
  );
}
