import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Container socialSecuritySection(LegislationController controller) {
  return Container(
    height: 230,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Employee Percentage',
          controller: controller.socialSecurityEmployee,
          isDouble: true,
          width: 150,
          suffixIcon: const Icon(Icons.percent),
        ),
        myTextFormFieldWithBorder(
          labelText: 'Employer Percentage',
          controller: controller.socialSecurityEmployer,
          isDouble: true,
          width: 150,
          suffixIcon: const Icon(Icons.percent),
        ),
        myTextFormFieldWithBorder(
          labelText: 'Ceiling',
          controller: controller.socialSecurityCeiling,
          isDouble: true,
          width: 150,
        ),
      ],
    ),
  );
}
