import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewPayrollElementOrEdit({
  required EmployeesController controller,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Name',
          headerLqabel: 'Name',
          dialogWidth: 600,
          controller: controller.employeePayrollElementName,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.employeePayrollElementName.clear();
            controller.employeePayrollElementNameId.value = '';
          },
          onSelected: (value) {
            controller.employeePayrollElementName.text = value['name'];
            controller.employeePayrollElementNameId.value = value['_id'];
          },
          onOpen: () {
            return controller.getAllPayrollElements();
          },
        ),
        myTextFormFieldWithBorder(
          width: 200,
          obscureText: false,
          controller: controller.employeePayrollElementvalue,
          labelText: 'Value',
          isDouble: true,
        ),
        myTextFormFieldWithBorder(
          labelText: 'Start Date',
          isDate: true,
          controller: controller.employeePayrollElementStartDate,
          width: 200,
          suffixIcon: IconButton(
            onPressed: () async {
              selectDateContext(
                context,
                controller.employeePayrollElementStartDate,
              );
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.employeePayrollElementStartDate.text,
              controller.employeePayrollElementStartDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.employeePayrollElementStartDate.text,
              controller.employeePayrollElementStartDate,
            );
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'End Date',
          isDate: true,
          controller: controller.employeePayrollElementEndDate,
          width: 200,
          suffixIcon: IconButton(
            onPressed: () async {
              selectDateContext(
                context,
                controller.employeePayrollElementEndDate,
              );
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.employeePayrollElementEndDate.text,
              controller.employeePayrollElementEndDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.employeePayrollElementEndDate.text,
              controller.employeePayrollElementEndDate,
            );
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.employeePayrollElementNote,
          labelText: 'Note',
        ),
      ],
    ),
  );
}
