import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_elements_controller.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Widget addNewBasedElementsOrEdit({
  required PayrollElementsController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.basedElementName,
          labelText: 'Element Name',
          validate: true,
        ),
        MenuWithValues(
          labelText: 'Type',
          headerLqabel: 'Types',
          dialogWidth: 600,
          controller: controller.basedElementType,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.basedElementType.clear();
          },
          data: controller.allBasedElementTypes,
          onSelected: (value) {
            controller.basedElementType.text = value['name'];
          },
        ),
      ],
    ),
  );
}
