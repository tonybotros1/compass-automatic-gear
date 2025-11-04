import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import 'contact_information_section.dart';
import 'job_information_section.dart';
import 'personal_information_section.dart';

Widget addNewEmployeeOrEdit({
  required EmployeesController controller,
  required bool canEdit,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
            child: IntrinsicWidth(
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text(
                                'Personal Information',
                                style: fontStyle1,
                              ),
                            ),
                            personalInformation(context, controller),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text(
                                'Contact Information',
                                style: fontStyle1,
                              ),
                            ),
                            contactInformation(context, controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      labelContainer(
                        lable: Text('Job Information', style: fontStyle1),
                      ),
                      jobInformation(context, controller),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
