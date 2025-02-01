import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import '../my_text_field.dart';
import 'drop_down_menu.dart';

Widget addNewListOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ListOfValuesController controller,
  TextEditingController? listName,
  TextEditingController? code,
  TextEditingController? masterdBy,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 200,
    child: Form(
      key: controller.formKeyForAddingNewList,
      child: ListView(
        children: [
          myTextFormFieldWithBorder(
            // constraints: constraints,
            obscureText: false,
            controller: listName ?? controller.listName,
            labelText: 'List Name',
            hintText: 'Enter List name',
            validate: true,
          ),
          SizedBox(
            height: 10,
          ),
          myTextFormFieldWithBorder(
            // constraints: constraints,
            obscureText: false,
            controller: code ?? controller.code,
            labelText: 'Code',
            hintText: 'Enter code',
            validate: true,
          ),
          SizedBox(
            height: 10,
          ),
          dropDownValues(
              onSelected: (suggestion) {
                controller.masteredByForList.text = suggestion.toString();
                controller.listMap.entries.where((entry) {
                  return entry.value == suggestion.toString();
                }).forEach((entry) {
                  controller.masteredByIdForList.value = entry.key;
                });
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.toString()),
                );
              },
              labelText: 'Masterd By',
              hintText: 'Select the parent list for this list (Optional)',
              menus: controller.listMap,
              validate: false,
              controller: controller,
              textController: masterdBy ?? controller.masteredByForList)
        ],
      ),
    ),
  );
}
