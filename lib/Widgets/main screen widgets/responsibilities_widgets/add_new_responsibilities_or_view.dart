import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/responsibilities_controller.dart';
import '../../my_text_field.dart';

Widget addNewResponsibilityOrView({
  required ResponsibilitiesController controller,
}) {
  return ListView(
    children: [
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.responsibilityName,
        labelText: 'Responsibility Name',
        hintText: 'Enter Responsibility name',
        keyboardType: TextInputType.name,
        validate: true,
      ),
      const SizedBox(height: 15),
      CustomDropdown(
        textcontroller: controller.menuName.text,
        hintText: 'Menus',
        showedSelectedName: 'name',
        items: controller.allMenus,
        itemBuilder: (context, key, value) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text('${value['name']} ${value['code']}'),
          );
        },
        onChanged: (key, value) {
          controller.menuIDFromList.value = key;
        },
      ),
    ],
  );
}
