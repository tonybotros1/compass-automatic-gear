import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewListOrEdit({required ListOfValuesController controller}) {
  return Form(
    key: controller.formKeyForAddingNewList,
    child: ListView(
      children: [
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.listName,
          labelText: 'List Name',
          hintText: 'Enter List name',
          validate: true,
        ),
        const SizedBox(height: 10),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.code,
          labelText: 'Code',
          hintText: 'Enter code',
          validate: true,
        ),
        const SizedBox(height: 10),
        CustomDropdown(
          showedSelectedName: 'name',
          hintText: 'Masterd By',
          items: controller.listMap,
          textcontroller: controller.masteredByForList.text,

          onChanged: (key, value) {
            controller.masteredByForList.text = value['name'];
            controller.masteredByIdForList.value = key;
          },
        ),
      ],
    ),
  );
}
