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
          labelText: 'name',
          headerLqabel: 'name',
          dialogWidth: 600,
          controller: controller.country,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.phoneType.clear();
            controller.phoneTypeId.value = '';
          },
          onSelected: (value) {
            controller.phoneType.text = value['name'];
            controller.phoneTypeId.value = value['_id'];
          },
          onOpen: () {
            return controller.getPhoneTypes();
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.phoneNumber,
          labelText: 'Value',
        ),
        myTextFormFieldWithBorder(
          labelText: 'Start Date',
          isDate: true,
          controller: controller.nationalityStartDate,
          width: 200,
          suffixIcon: IconButton(
            onPressed: () async {
              selectDateContext(context, controller.nationalityStartDate);
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.nationalityStartDate.text,
              controller.nationalityStartDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.nationalityStartDate.text,
              controller.nationalityStartDate,
            );
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'End Date',
          isDate: true,
          controller: controller.nationalityEndDate,
          width: 200,
          suffixIcon: IconButton(
            onPressed: () async {
              selectDateContext(context, controller.nationalityEndDate);
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.nationalityEndDate.text,
              controller.nationalityEndDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.nationalityEndDate.text,
              controller.nationalityEndDate,
            );
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.phoneNumber,
          labelText: 'Note',
        ),
      ],
    ),
  );
}
