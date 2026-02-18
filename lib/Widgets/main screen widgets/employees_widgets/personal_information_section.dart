import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Container personalInformation(
  BuildContext context,
  EmployeesController controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              labelText: 'Employee Name',
              controller: controller.employeeName,
              width: 310,
            ),
            myTextFormFieldWithBorder(
              labelText: 'Employee Number',
              controller: controller.employeeNumber,
              width: 150,
              isEnabled: false,
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            MenuWithValues(
              labelText: 'Gender',
              headerLqabel: 'Gender',
              dialogWidth: 600,
              width: 150,
              controller: controller.employeeGender,
              displayKeys: const ['name'],
              displaySelectedKeys: const ['name'],
              onOpen: () {
                return controller.getGenders();
              },
              onDelete: () {
                controller.employeeGender.clear();
                controller.employeeGenderId.value = '';
              },
              onSelected: (value) {
                controller.employeeGender.text = value['name'];
                controller.employeeGenderId.value = value['_id'];
              },
            ),
            myTextFormFieldWithBorder(
              labelText: 'Date Of Birth',
              isDate: true,
              controller: controller.employeeDateOfBirth,
              width: 150,
              suffixIcon: IconButton(
                onPressed: () async {
                  selectDateContext(context, controller.employeeDateOfBirth);
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.employeeDateOfBirth.text,
                  controller.employeeDateOfBirth,
                );
              },
            ),
          ],
        ),
        MenuWithValues(
          labelText: 'Nationality',
          headerLqabel: 'Nationality',
          dialogWidth: 600,
          width: 310,
          controller: controller.employeeNationality,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onOpen: () {
            return controller.getNationalities();
          },
          onDelete: () {
            controller.employeeNationality.clear();
            controller.employeeNamtionalityId.value = '';
          },
          onSelected: (value) {
            controller.employeeNationality.text = value['name'];
            controller.employeeNamtionalityId.value = value['_id'];
          },
        ),

        MenuWithValues(
          labelText: 'Martial Status',
          headerLqabel: 'Martial Status',
          dialogWidth: 600,
          width: 310,
          controller: controller.employeeMaritalStatus,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onOpen: () {
            return controller.getMaritalStatus();
          },
          onDelete: () {
            controller.employeeMaritalStatus.clear();
            controller.employeeMaritalStatusId.value = '';
          },
          onSelected: (value) {
            controller.employeeMaritalStatus.text = value['name'];
            controller.employeeMaritalStatusId.value = value['_id'];
          },
        ),
        myTextFormFieldWithBorder(
          width: 310,
          labelText: 'National ID / Passport Number',
          controller: controller.employeeNationalIdOrPassportNumber,
        ),
      ],
    ),
  );
}
