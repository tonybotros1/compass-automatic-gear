import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Container serviceTaxSection(LegislationController controller) {
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
          labelText: 'Service Tax Percentage',
          controller: controller.serviceTax,
          isDouble: true,
          validate: false,
          width: 150,
          suffixIcon: const Icon(Icons.percent),
        ),
      ],
    ),
  );
}
