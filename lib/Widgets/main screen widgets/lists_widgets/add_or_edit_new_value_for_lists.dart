import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../my_text_field.dart';

Widget addNewValueOrEdit({required ListOfValuesController controller}) {
  return Form(
    key: controller.formKeyForAddingNewList,
    child: ListView(
      children: [
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.valueName,
          labelText: 'Value Name',
          hintText: 'Enter Value name',
          validate: true,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          hintText: 'Masterd By',
          showedSelectedName: 'name',
          textcontroller: controller.masteredBy.text,
          items: controller.valueMap,
          onChanged: (key, value) {
            // print(value);
            controller.masteredBy.text = value['name'];
            controller.masteredByIdForValues.value = key;
          },
        ),
      ],
    ),
  );
}
