import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container jobInformation(BuildContext context, EmployeesController controller) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              myTextFormFieldWithBorder(
                labelText: 'Job Title',
                width: 310,
                controller: controller.jobTitle,
              ),
              Row(
                spacing: 10,
                children: [
                  myTextFormFieldWithBorder(
                    labelText: 'Hire Date',
                    width: 150,
                    isDate: true,
                    controller: controller.hireDate,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        selectDateContext(context, controller.hireDate);
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                    onFieldSubmitted: (_) async {
                      normalizeDate(
                        controller.hireDate.text,
                        controller.hireDate,
                      );
                    },
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'End Date',
                    width: 150,
                    controller: controller.endDate,
                    isDate: true,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        selectDateContext(context, controller.endDate);
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                    onFieldSubmitted: (_) async {
                      normalizeDate(
                        controller.endDate.text,
                        controller.endDate,
                      );
                    },
                  ),
                ],
              ),
              myTextFormFieldWithBorder(
                labelText: 'Job Description',
                maxLines: 5,
                controller: controller.jobDescription,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                hintText: 'Employee Status',
                width: 300,
                showedSelectedName: 'name',
                textcontroller: controller.employeeStatus.text,
                onChanged: (key, value) {
                  controller.employeeStatus.text = value['name'];
                  controller.employeeStatusId.value = key;
                },
                onDelete: () {
                  controller.employeeStatus.clear();
                  controller.employeeStatusId.value = '';
                },
                onOpen: () {
                  return controller.getEmployeeStatus();
                },
              ),
              Text('Category', style: textFieldLabelStyle),
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        GetX<EmployeesController>(
                          builder: (controller) {
                            return CupertinoCheckbox(
                              checkColor: mainColor,
                              activeColor: Colors.white,
                              value: controller.isTimeSheetsSelected.value,
                              onChanged: (value) {
                                controller.selectDepartment(
                                  "Time Sheets",
                                  value!,
                                );
                              },
                            );
                          },
                        ),
                        Text('Time Sheets', style: textFieldLabelStyle),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GetX<EmployeesController>(
                        builder: (controller) {
                          return CupertinoCheckbox(
                            checkColor: mainColor,
                            activeColor: Colors.white,
                            value: controller.isJobCardsSelected.value,
                            onChanged: (value) {
                              controller.selectDepartment("Job Cards", value!);
                            },
                          );
                        },
                      ),
                      Text('Job Cards', style: textFieldLabelStyle),
                    ],
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        GetX<EmployeesController>(
                          builder: (controller) {
                            return CupertinoCheckbox(
                              checkColor: mainColor,
                              activeColor: Colors.white,
                              value: controller.isReceivingSelected.value,
                              onChanged: (value) {
                                controller.selectDepartment(
                                  "Receiving",
                                  value!,
                                );
                              },
                            );
                          },
                        ),
                        Text('Receiving', style: textFieldLabelStyle),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GetX<EmployeesController>(
                        builder: (controller) {
                          return CupertinoCheckbox(
                            checkColor: mainColor,
                            activeColor: Colors.white,
                            value: controller.isIssueingSelected.value,
                            onChanged: (value) {
                              controller.selectDepartment("Issueing", value!);
                            },
                          );
                        },
                      ),
                      Text('Issueing', style: textFieldLabelStyle),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
