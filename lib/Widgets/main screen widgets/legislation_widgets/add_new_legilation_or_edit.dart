import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';
import 'compassionate_leave_section.dart';
import 'legilation_information.dart';
import 'maternity_leave_section.dart';
import 'sick_leave_section.dart';

Widget addNewLegistlationOrEdit({
  required LegislationController controller,
  required BoxConstraints constraints,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        labelContainer(lable: Text('Information', style: fontStyle1)),
        legislationInformation(controller),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: Column(
                children: [
                  labelContainer(lable: Text('Sick Leave', style: fontStyle1)),
                  sickLeaveSection(controller),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Maternity Leave', style: fontStyle1),
                  ),
                  maternityLeaveSection(controller),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Compassionate Leave', style: fontStyle1),
                  ),
                  compassionateLeaveSection(controller),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
