import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewNationalityOrEdit({
  required EmployeesController controller,
  required bool canEdit,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Nationality',
          headerLqabel: 'Nationalities',
          dialogWidth: 600,
          controller: controller.nationality,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.nationality.clear();
            controller.nationalityId.value = '';
          },
          onSelected: (value) {
            controller.nationality.text = value['name'];
            controller.nationalityId.value = value['_id'];
          },
          onOpen: () {
            return controller.getNationalities();
          },
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
      ],
    ),
  );
}
