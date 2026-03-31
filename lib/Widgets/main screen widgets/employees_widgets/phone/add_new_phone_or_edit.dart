import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewPhoneOrEdit({
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
          controller: controller.country,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.phoneType.clear();
            controller.phoneTypeId.value = '';
          },
          onSelected: (value) {
            controller.phoneType.text = value['name'];
            controller.phoneTypeId.value = value['_id'];
          },
          onOpen: () {
            return controller.getPhoneTypes();
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.phoneNumber,
          labelText: 'Phone',
          validate: true,
        ),
      ],
    ),
  );
}
