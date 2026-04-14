import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';

Widget addNewPeriodOrEdit({
  required PayrollController controller,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Period Name',
          controller: controller.periodName,
        ),
        myTextFormFieldWithBorder(
          width: 150,
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              selectDateContext(context, controller.periodStartDate);
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.periodStartDate.text,
              controller.periodStartDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.periodStartDate.text,
              controller.periodStartDate,
            );
          },
          controller: controller.periodStartDate,
          labelText: 'Start Date',
          onChanged: (_) {},
        ),
        myTextFormFieldWithBorder(
          width: 150,
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              selectDateContext(context, controller.periodEndDate);
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.periodEndDate.text,
              controller.periodEndDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.periodEndDate.text,
              controller.periodEndDate,
            );
          },
          controller: controller.periodEndDate,
          labelText: 'End Date',
          onChanged: (_) {},
        ),
        GetX<PayrollController>(
          builder: (controller) {
            return RadioGroup<bool>(
              groupValue: controller.isActiveSelected.value,
              onChanged: (bool? value) {
                if (value != null) {
                  controller.selecetActiveInactive(
                    value ? 'active' : 'inactive',
                    value,
                  );
                }
              },
              child: Row(
                children: [
                  Row(
                    children: [
                      Radio<bool>(value: true, activeColor: mainColor),
                      const Text('Active'),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Radio<bool>(value: false, activeColor: mainColor),
                      const Text('Inactive'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

