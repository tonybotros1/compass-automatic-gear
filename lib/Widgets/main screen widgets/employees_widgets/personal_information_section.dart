import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
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
            CustomDropdown(
              width: 150,
              hintText: 'Gender',
              textcontroller: controller.employeeGender.text,
              showedSelectedName: 'name',
              onChanged: (key, value) {
                controller.employeeGender.text = value['name'];
                controller.employeeGenderId.value = key;
              },onDelete: (){
                 controller.employeeGender.clear();
                controller.employeeGenderId.value = '';
              },
              onOpen: (){
                return controller.getGenders();
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
        CustomDropdown(
          width: 310,
          hintText: 'Nationality',
          showedSelectedName: 'name',
          textcontroller: controller.employeeNationality.text,
          onChanged: (key, value) {
            controller.employeeNationality.text = value['name'];
            controller.employeeNamtionalityId.value = key;
          },
          onDelete: () {
            controller.employeeNationality.clear();
            controller.employeeNamtionalityId.value = '';
          },
          onOpen: () {
            return controller.getNationalities();
          },
        ),
        CustomDropdown(
          width: 310,
          hintText: 'Martial Status',
          showedSelectedName: 'name',
          textcontroller: controller.employeeMaritalStatus.text,
          onChanged: (key, value) {
            controller.employeeMaritalStatus.text = value['name'];
            controller.employeeMaritalStatusId.value = key;
          },
          onDelete: () {
            controller.employeeMaritalStatus.clear();
            controller.employeeMaritalStatusId.value = '';
          },
          onOpen: () {
            return controller.getMaritalStatus();
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
