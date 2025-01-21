import 'package:flutter/material.dart';
import '../../Controllers/Main screen controllers/system_variables_controller.dart';
import '../Auth screens widgets/register widgets/my_text_form_field.dart';

Widget addNewVariableOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required SystemVariablesController controller,
  TextEditingController? code,
  TextEditingController? value,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: code ?? controller.code,
          labelText: 'Code',
          hintText: 'Enter Variable Code',
          keyboardType: TextInputType.name,
          validate: true,
          canEdit: canEdit,
        ),
        myTextFormField(
          constraints: constraints,
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
