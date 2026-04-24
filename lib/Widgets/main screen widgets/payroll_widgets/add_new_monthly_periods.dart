import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';

Widget addNewMonthlyPeriods({required PayrollController controller}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        myTextFormFieldWithBorder(
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              selectDateContext(Get.context!, controller.yearStartDate);
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.yearStartDate.text,
              controller.yearStartDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.yearStartDate.text,
              controller.yearStartDate,
            );
          },
          controller: controller.yearStartDate,
          labelText: 'Year Start Date',
          onChanged: (_) {},
        ),
      ],
    ),
  );
}
