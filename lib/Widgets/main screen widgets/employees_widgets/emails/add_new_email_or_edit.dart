import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewEmailOrEdit({
  required EmployeesController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Type',
          headerLqabel: 'Types',
          dialogWidth: 600,
          controller: controller.emailType,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.emailType.clear();
            controller.emailTypeId.value = '';
          },
          onSelected: (value) {
            controller.emailType.text = value['name'];
            controller.emailTypeId.value = value['_id'];
          },
          onOpen: () {
            return controller.getTypeOfSocial();
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.emailAddress,
          labelText: 'Contact Details',
          validate: true,
        ),
      ],
    ),
  );
}
