import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';

Widget addNewValueOrEdit({
  required ListOfValuesController controller,
}) {
  return Form(
    key: controller.formKeyForAddingNewList,
    child: ListView(
      children: [
        myTextFormFieldWithBorder(
          obscureText: false,
          controller:  controller.valueName,
          labelText: 'Value Name',
          hintText: 'Enter Value name',
          validate: true,
        ),
        SizedBox(
          height: 20,
        ),
        dropDownValues(
           listValues: controller.valueMap.values
                  .map((value) => value
                      .toString()) 
                  .toList(),
            onSelected: (suggestion) {
              controller.restrictedBy.text = suggestion.toString();
              controller.valueMap.entries.where((entry) {
                return entry.value == suggestion.toString();
              }).forEach((entry) {
                controller.masteredByIdForValues.value = entry.key;
              });
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            labelText: 'Masterd By',
            hintText: 'Select the parent Value for this Value (Optional)',
            menus: controller.valueMap,
            validate: false,
            textController: controller.restrictedBy)
      ],
    ),
  );
}
