import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/employees_controller.dart';

InkWell imageSection(EmployeesController controller) {
  return InkWell(
    onTap: () {
      controller.pickImage();
    },
    child: GetBuilder<EmployeesController>(
      builder: (controller) {
        return Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(style: BorderStyle.solid, color: Colors.grey),
          ),
          child:
              controller.imageBytes == null &&
                  controller.employeeImage.value.isEmpty
              ? const Center(
                  child: FittedBox(
                    child: Text(
                      'No image selected',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : controller.imageBytes != null
              ? Image.memory(controller.imageBytes!, fit: BoxFit.contain)
              : Image.network(
                  controller.employeeImage.value,
                  fit: BoxFit.contain,
                ),
        );
      },
    ),
  );
}
