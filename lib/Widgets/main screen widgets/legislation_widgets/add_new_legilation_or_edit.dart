import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';
import 'compassionate_leave_section.dart';
import 'legilation_information.dart';
import 'maternity_leave_section.dart';
import 'overtime_holidays_section.dart';
import 'overtime_normal_section.dart';
import 'paternity_leave_section.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    lable: Text('Paternity Leave', style: fontStyle1),
                  ),
                  paternityLeaveSection(controller),
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
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Overtime Normal', style: fontStyle1),
                  ),
                  overtimeNormalSection(controller),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Overtime Holidays', style: fontStyle1),
                  ),
                  overtimeHolidaysSection(controller),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
