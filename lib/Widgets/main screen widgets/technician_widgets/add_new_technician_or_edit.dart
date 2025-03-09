import 'package:datahubai/Controllers/Main%20screen%20controllers/technician_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewTechnicianOrEdit({
  required TechnicianController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      SizedBox(
        height: 5,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.name,
        labelText: 'Code',
        hintText: 'Enter Code',
        validate: true,
      ),
      SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.job,
        labelText: 'Description',
        hintText: 'Enter Name',
        validate: true,
      ),
     
     
     
      
    ],
  );
}
