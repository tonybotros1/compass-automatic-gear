import 'package:flutter/material.dart';
import '../../Controllers/Main screen controllers/responsibilities_controller.dart';
import '../Auth screens widgets/register widgets/my_text_form_field.dart';
import 'drop_down_menu.dart';

Widget addNewResponsibilityOrView({
  required BoxConstraints constraints,
  required BuildContext context,
  required ResponsibilitiesController controller,
  TextEditingController? responsibilityName,
  TextEditingController? menuName,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 170,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        children: [
          myTextFormField(
            constraints: constraints,
            obscureText: false,
            controller: responsibilityName ?? controller.responsibilityName,
            labelText: 'Responsibility Name',
            hintText: 'Enter Responsibility name',
            keyboardType: TextInputType.name,
            validate: true,
          ),
          SizedBox(
            height: 10,
          ),
          dropDownValues(
            textController: menuName ?? controller.menuName,
            onSelected: (suggestion) {
              menuName!.text =
                  '${suggestion['name']} (${suggestion['description']})';
              controller.menuMap.entries.where((entry) {
                return entry.value['name'] == suggestion['name'].toString() &&
                    entry.value['description'] == suggestion['description'];
              }).forEach((entry) {
                controller.menuIDFromList.value = entry.key;
              });
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(
                    '${suggestion['name']} (${suggestion['description']})'),
              );
            },
            labelText: 'Menus',
            hintText: 'Select Menu',
            menus: controller.menuMap,
            validate: true,
            controller: controller,
          ),
        ],
      ),
    ),
  );
}
