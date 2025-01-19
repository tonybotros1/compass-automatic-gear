import 'package:flutter/material.dart';
import '../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../my_text_field.dart';
import 'drop_down_menu.dart';

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
      child: ListView(
        children: [
          myTextFormField2(
            obscureText: false,
            controller: valueName ?? controller.valueName,
            labelText: 'Value Name',
            hintText: 'Enter Value name',
            validate: true,
          ),
          SizedBox(
            height: 20,
          ),
          dropDownValues(
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
              controller: controller,
              textController: restrictedBy ?? controller.restrictedBy)
        ],
      ),
    ),
  );
}
