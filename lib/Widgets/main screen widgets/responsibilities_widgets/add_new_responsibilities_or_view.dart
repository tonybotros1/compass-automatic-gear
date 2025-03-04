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
      SizedBox(
        height: 15,
      ),
      CustomDropdown(
        textcontroller: controller.menuName.text,
        hintText: 'Menus',
        showedSelectedName: 'name',
        items: controller.menuMap,
        itemBuilder: (context, key, value) {
          return ListTile(
            title: Text('${value['name']} (${value['description']})'),
          );
        },
        onChanged: (key, value) {
          
          controller.menuIDFromList.value = key;
        },
      )
      
    ],
  );
}
