import 'package:datahubai/Controllers/Main%20screen%20controllers/job_tasks_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewTaskOrEdit({
  required JobTasksController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      SizedBox(
        height: 5,
      ),
      myTextFormFieldWithBorder(
        controller: controller.nameEN,
        labelText: 'English Name',
      ),
      SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        controller: controller.nameAR,
        labelText: 'Arabic Name',
      ),
      SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        isDouble: true,
        controller: controller.points,
        labelText: 'Points',
      ),
      SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        controller: controller.category,
        labelText: 'Category',
      ),
    ],
  );
}
