import 'package:flutter/material.dart';
import '../my_text_field.dart';

Widget addNewListOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required controller,
  TextEditingController? listName,
  TextEditingController? code,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 120,
    child: Form(
      key: controller.formKeyForAddingNewList,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          myTextFormField2(
            // constraints: constraints,
            obscureText: false,
            controller: listName ?? controller.listName,
            labelText: 'List Name',
            hintText: 'Enter List name',
            validate: true,
          ),
          myTextFormField2(
            // constraints: constraints,
            obscureText: false,
            controller: code ?? controller.code,
            labelText: 'Code',
            hintText: 'Enter code',
            validate: true,
          ),
          // dropDownValues(labelText: '', hintText: '', menus: {}, validate: null, controller: null)
        ],
      ),
    ),
  );
}
