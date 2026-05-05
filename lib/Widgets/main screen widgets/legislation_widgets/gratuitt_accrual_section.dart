import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Container gratuityAccrualSection(LegislationController controller) {
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
          labelText: 'First 5 years',
          controller: controller.gratuityFirst5Years,
          isnumber: true,
          width: 150,
        ),
        myTextFormFieldWithBorder(
          labelText: 'After 5 years',
          controller: controller.gratuityAfter5Years,
          isnumber: true,
          width: 150,
        ),
      ],
    ),
  );
}
