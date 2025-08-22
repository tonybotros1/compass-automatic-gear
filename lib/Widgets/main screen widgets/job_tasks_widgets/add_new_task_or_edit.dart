import 'package:datahubai/Controllers/Main%20screen%20controllers/job_tasks_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewTaskOrEdit({
  required JobTasksController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(
        height: 5,
      ),
      myTextFormFieldWithBorder(
        controller: controller.nameEN,
        labelText: 'English Name',
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        controller: controller.nameAR,
        labelText: 'Arabic Name',
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        isDouble: true,
        controller: controller.points,
        labelText: 'Points',
      ),
      const SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        controller: controller.category,
        labelText: 'Category',
      ),
    ],
  );
}
