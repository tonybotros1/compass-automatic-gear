import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Container compassionateLeaveSection(LegislationController controller) {
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
          labelText: 'Paid Days No.',
          controller: controller.compassionateLeaveNumberOfPaidDays,
          isnumber: true,
          width: 150,
        ),
      ],
    ),
  );
}
