import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewListOrEdit({
  required ListOfValuesController controller,
}) {
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
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.code,
          labelText: 'Code',
          hintText: 'Enter code',
          validate: true,
        ),
        SizedBox(
          height: 10,
        ),
        CustomDropdown(
          showedSelectedName: 'list_name',
          hintText: 'Masterd By',
          items: controller.listMap,
          textcontroller: controller.masteredByForList.text,
          itemBuilder: (context, key, value) {
            return ListTile(
              title: Text(value['list_name']),
            );
          },
          onChanged: (key, value) {
            controller.masteredByForList.text = value['list_name'];
            controller.masteredByIdForList.value = key;
          },
        )
        
      ],
    ),
  );
}
