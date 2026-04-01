import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Container assignmentInformation(
  BuildContext context,
  EmployeesController controller,
) {
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
              MenuWithValues(
                labelText: 'Status',
                headerLqabel: 'Status',
                dialogWidth: 600,
                width: 150,
                controller: controller.employeeStatus,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getEmployeeStatus();
                },
                onDelete: () {
                  controller.employeeStatus.clear();
                  controller.employeeStatusId.value = '';
                },
                onSelected: (value) {
                  controller.employeeStatus.text = value['name'];
                  controller.employeeStatusId.value = value['_id'];
                },
              ),
              MenuWithValues(
                labelText: 'Employer',
                headerLqabel: 'Employers',
                dialogWidth: 600,
                width: 310,
                controller: controller.jobEmployer,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getallJobEmployers();
                },
                onDelete: () {
                  controller.jobEmployer.clear();
                  controller.jobEmployerId.value = '';
                },
                onSelected: (value) {
                  controller.jobEmployer.text = value['name'];
                  controller.jobEmployerId.value = value['_id'];
                },
              ),
              MenuWithValues(
                labelText: 'Job Title',
                headerLqabel: 'Job Titles',
                dialogWidth: 600,
                width: 310,
                controller: controller.jobTitle,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getallJobTitle();
                },
                onDelete: () {
                  controller.jobTitle.clear();
                  controller.jobTitleId.value = '';
                },
                onSelected: (value) {
                  controller.jobTitle.text = value['name'];
                  controller.jobTitleId.value = value['_id'];
                },
              ),
              MenuWithValues(
                labelText: 'Location',
                headerLqabel: 'Locations',
                dialogWidth: 600,
                width: 310,
                controller: controller.jobLocation,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getallJobLocations();
                },
                onDelete: () {
                  controller.jobLocation.clear();
                  controller.jobLocationId.value = '';
                },
                onSelected: (value) {
                  controller.jobLocation.text = value['name'];
                  controller.jobLocationId.value = value['_id'];
                },
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
            ],
          ),
        ),
        const Expanded( // need to edit
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ],
    ),
  );
}
