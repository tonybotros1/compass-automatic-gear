import 'package:flutter/material.dart';
import '../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../my_text_field.dart';

Widget addNewValueOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ListOfValuesController controller,
  TextEditingController? valueName,
  TextEditingController? valueCode,
  TextEditingController? restrictedBy,
  bool? isEnabled,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 200,
    child: Form(
      key: controller.formKeyForAddingNewList,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          myTextFormField2(
            obscureText: false,
            controller: valueName ?? controller.valueName,
            labelText: 'Value Name',
            hintText: 'Enter Value name',
            validate: true,
          ),
          myTextFormField2(
              obscureText: false,
              controller: valueCode ?? controller.valueCode,
              labelText: 'Code',
              hintText: 'Enter code',
              validate: true,
              isEnabled: isEnabled),
          myTextFormField2(
            obscureText: false,
            controller: restrictedBy ?? controller.restrictedBy,
            labelText: 'Restricted By',
            hintText: 'Optional',
            validate: true,
          ),
        ],
      ),
    ),
  );
}
