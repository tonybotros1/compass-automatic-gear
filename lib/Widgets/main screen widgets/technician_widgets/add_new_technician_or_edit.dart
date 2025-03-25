import 'package:datahubai/Controllers/Main%20screen%20controllers/technician_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewTechnicianOrEdit({
  required TechnicianController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(
        height: 5,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.name,
        labelText: 'Name',
        validate: true,
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.job,
        labelText: 'Job',
        validate: true,
      ),
    ],
  );
}
