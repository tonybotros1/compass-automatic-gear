import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Container sickLeaveSection(LegislationController controller) {
  return Container(
    // height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Paid Days No.',
          controller: controller.numberOfPaidDays,
          isnumber: true,
          width: 150,
        ),
        myTextFormFieldWithBorder(
          labelText: 'Half Paid Days No.',
          controller: controller.numberOfHalfPaidDays,
          isnumber: true,
          width: 150,
        ),
        myTextFormFieldWithBorder(
          labelText: 'Unpaid Days No.',
          controller: controller.numberOfUnPaidDays,
          isnumber: true,
          width: 150,
        ),
      ],
    ),
  );
}
