import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/counters_controller.dart';
import '../../my_text_field.dart';

Widget addNewConterOrEdit({
  required CountersController controller,
 required bool canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.code,
        labelText: 'Code',
        validate: true,
        isEnabled: canEdit,
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.description,
        labelText: 'Description',
        validate: true,
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.prefix,
        labelText: 'Prefix',
        validate: true,
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        spacing: 10,
        children: [
          Expanded(
            child: myTextFormFieldWithBorder(
              isnumber: true,
              obscureText: false,
              controller: controller.value,
              labelText: 'Value',
              validate: true,
            ),
          ),
          Expanded(
            child: myTextFormFieldWithBorder(
              obscureText: false,
              controller: controller.separator,
              labelText: 'separator',
              validate: true,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        isnumber: true,
        obscureText: false,
        controller: controller.length,
        labelText: 'Value Length',
        validate: true,
      ),
    ],
  );
}
