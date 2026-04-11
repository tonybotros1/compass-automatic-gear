import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';

Widget addNewContactAndRelativeOrEdit({
  required EmployeesController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      spacing: 15,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Full Name',
          controller: controller.contactAndRelativeFullName,
        ),
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: MenuWithValues(
                labelText: 'Relationship',
                headerLqabel: 'Relationship',
                dialogWidth: 600,
                controller: controller.contactAndRelativeRelationship,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getRELATIONSHIPS();
                },
                onDelete: () {
                  controller.contactAndRelativeRelationshipId.value = "";
                  controller.contactAndRelativeRelationship.clear();
                },
                onSelected: (value) {
                  controller.contactAndRelativeRelationshipId.value =
                      value['_id'];
                  controller.contactAndRelativeRelationship.text =
                      value['name'];
                },
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                labelText: 'Phone Number',
                controller: controller.contactAndRelativePhoneNumber,
              ),
            ),
          ],
        ),
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: MenuWithValues(
                labelText: 'Gender',
                headerLqabel: 'Genders',
                dialogWidth: 600,
                controller: controller.contactAndRelativeGender,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getGenders();
                },
                onDelete: () {
                  controller.contactAndRelativeGenderId.value = "";
                  controller.contactAndRelativeGender.clear();
                },
                onSelected: (value) {
                  controller.contactAndRelativeGenderId.value = value['_id'];
                  controller.contactAndRelativeGender.text = value['name'];
                },
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                labelText: 'Date Of Birth',
                controller: controller.contactAndRelativeDateOfBirth,
                isDate: true,
                suffixIcon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () async {
                    selectDateContext(
                      Get.context!,
                      controller.contactAndRelativeDateOfBirth,
                    );
                  },
                  icon: const Icon(Icons.date_range),
                ),
                onFieldSubmitted: (_) async {
                  normalizeDate(
                    controller.contactAndRelativeDateOfBirth.text,
                    controller.contactAndRelativeDateOfBirth,
                  );
                },
              ),
            ),
          ],
        ),
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: MenuWithValues(
                labelText: 'Nationality',
                headerLqabel: 'Nationalities',
                dialogWidth: 600,
                controller: controller.contactAndRelativeNationality,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getNationalities();
                },
                onDelete: () {
                  controller.contactAndRelativeNationalityId.value = "";
                  controller.contactAndRelativeNationality.clear();
                },
                onSelected: (value) {
                  controller.contactAndRelativeNationalityId.value =
                      value['_id'];
                  controller.contactAndRelativeNationality.text = value['name'];
                },
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                labelText: 'Email Address',
                controller: controller.contactAndRelativeEmailAddress,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: BoxBorder.all(color: Colors.grey),
            color: Colors.blue.shade50,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Call primary in case of medical/safety incidents',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GetX<EmployeesController>(
                builder: (controller) {
                  return FlutterSwitch(
                    width: 70.0,
                    height: 40.0,
                    valueFontSize: 25.0,
                    toggleSize: 25.0,
                    value: controller.isThisContactAnEmergencyConact.value,
                    borderRadius: 30.0,
                    padding: 8.0,
                    showOnOff: false,
                    onToggle: (val) {
                      controller.isThisContactAnEmergencyConact.value = val;
                    },
                  );
                },
              ),
            ],
          ),
        ),
        myTextFormFieldWithBorder(
          labelText: 'Notes',
          maxLines: 9,
          controller: controller.contactAndRelativeNotes,
        ),
      ],
    ),
  );
}
