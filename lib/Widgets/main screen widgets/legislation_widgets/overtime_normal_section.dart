import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Container overtimeNormalSection(LegislationController controller) {
  return Container(
    height: 100,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Working Hours',
          controller: controller.numberOfWorkingHoursForOvertimeNormal,
          isnumber: true,
          width: 150,
        ),
      ],
    ),
  );
}
