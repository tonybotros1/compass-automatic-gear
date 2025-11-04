import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container contactInformation(
  BuildContext context,
  EmployeesController controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Email',
          width: 310,
          controller: controller.employeeEmail,
        ),
        myTextFormFieldWithBorder(
          labelText: 'Phone Number',
          width: 310,
          controller: controller.employeePhoneNumber,
        ),
        Row(
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              labelText: 'Emergency Contact Name',
              width: 310,
              controller: controller.employeeEmergencyName,
            ),
            myTextFormFieldWithBorder(
              labelText: 'Emergency Contact Number',
              width: 310,
              controller: controller.employeeEmergencyPhoneNumber,
            ),
          ],
        ),

        myTextFormFieldWithBorder(
          labelText: 'Address',
          maxLines: 4,
          controller: controller.employeeAddress,
        ),
      ],
    ),
  );
}
