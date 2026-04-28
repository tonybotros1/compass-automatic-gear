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
    height: 410,
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
                labelText: 'Department',
                headerLqabel: 'Departments',
                dialogWidth: 600,
                width: 310,
                controller: controller.jobDepartment,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getAllJobDepartments();
                },
                onDelete: () {
                  controller.jobDepartment.clear();
                  controller.jobDepartmentId.value = '';
                },
                onSelected: (value) {
                  controller.jobDepartment.text = value['name'];
                  controller.jobDepartmentId.value = value['_id'];
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
              MenuWithValues(
                labelText: 'Reporting Manager',
                headerLqabel: 'Reporting Managers',
                dialogWidth: 600,
                width: 310,
                controller: controller.reportingManager,
                displayKeys: const ['full_name'],
                displaySelectedKeys: const ['full_name'],
                onOpen: () {
                  return controller.getAllReporingManagers(
                    controller.currentEmployeeId.value,
                    controller.jobEmployerId.value,
                  );
                },
                onDelete: () {
                  controller.reportingManager.clear();
                  controller.reportingManagerId.value = '';
                },
                onSelected: (value) {
                  controller.reportingManager.text = value['full_name'];
                  controller.reportingManagerId.value = value['_id'];
                },
              ),
            ],
          ),
        ),
        Expanded(
          // need to edit
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MenuWithValues(
                labelText: 'Payroll',
                headerLqabel: 'Payrolls',
                dialogWidth: 600,
                width: 310,
                controller: controller.payroll,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getAllPayrolls();
                },
                onDelete: () {
                  controller.payroll.clear();
                  controller.payrollId.value = '';
                },
                onSelected: (value) {
                  controller.payroll.text = value['name'];
                  controller.payrollId.value = value['_id'];
                },
              ),
              myTextFormFieldWithBorder(
                labelText: 'Sick Leave Balance',
                isDouble: true,
                width: 310,
                readOnly: true,
              ),
              myTextFormFieldWithBorder(
                labelText: 'Annual Leave Balance',
                isDouble: true,
                width: 310,
                readOnly: true,
              ),
              myTextFormFieldWithBorder(
                labelText: 'Unpaid Leave Balance',
                isDouble: true,
                width: 310,
                readOnly: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
