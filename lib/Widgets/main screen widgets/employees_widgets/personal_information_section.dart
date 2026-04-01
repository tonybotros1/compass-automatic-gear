import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';
import 'image_section.dart';

Container personalInformation(
  BuildContext context,
  EmployeesController controller,
  bool isReadOnly,
) {
  return Container(
    height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 50,
      children: [
        imageSection(controller),
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myTextFormFieldWithBorder(
                labelText: 'Full Name',
                controller: controller.employeeName,
                width: 620,
                readOnly: isReadOnly,
              ),
              Row(
                spacing: 10,
                children: [
                  MenuWithValues(
                    labelText: 'Country of Birth',
                    headerLqabel: 'Gender',
                    dialogWidth: 600,
                    width: 200,
                    controller: controller.employeeCountryOfBirth,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onOpen: () {
                      return controller.getCountries();
                    },
                    onDelete: () {
                      controller.employeeCountryOfBirth.clear();
                      controller.employeeCountryOfBirthId.value = '';
                    },
                    onSelected: (value) {
                      controller.employeeCountryOfBirth.text = value['name'];
                      controller.employeeCountryOfBirthId.value = value['_id'];
                    },
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'Place of Birth',
                    controller: controller.employeePlaceOfBirth,
                    width: 200,
                    readOnly: isReadOnly,
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'Date Of Birth',
                    isDate: true,
                    controller: controller.employeeDateOfBirth,
                    width: 200,
                    readOnly: isReadOnly,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        selectDateContext(
                          context,
                          controller.employeeDateOfBirth,
                        );
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
              Row(
                spacing: 10,
                children: [
                  MenuWithValues(
                    labelText: 'Gender',
                    headerLqabel: 'Gender',
                    dialogWidth: 600,
                    width: 200,
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
                  MenuWithValues(
                    labelText: 'Martial Status',
                    headerLqabel: 'Martial Status',
                    dialogWidth: 600,
                    width: 200,
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
                    labelText: 'Person Type',
                    controller: controller.personType,
                    width: 200,
                    readOnly: isReadOnly,
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
