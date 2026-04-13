import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Container parollDetails(PayrollController controller) {
  return Container(
    // height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 50,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myTextFormFieldWithBorder(
                    labelText: 'Name',
                    controller: controller.name,
                    width: 600,
                  ),

                  MenuWithValues(
                    labelText: 'Period Type',
                    headerLqabel: 'Period Types',
                    dialogWidth: 600,
                    width: 200,
                    controller: controller.periodType,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    data: controller.periodTypes,
                    onDelete: () {
                      controller.periodType.clear();
                    },
                    onSelected: (value) {
                      controller.periodType.text = value['name'];
                    },
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'First Period Start Date',
                    controller: controller.firstPeriodStartDate,
                    width: 200,
                    suffixIcon: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () async {
                        selectDateContext(
                          Get.context!,
                          controller.firstPeriodStartDate,
                        );
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                    onFieldSubmitted: (_) async {
                      normalizeDate(
                        controller.firstPeriodStartDate.text,
                        controller.firstPeriodStartDate,
                      );
                    },
                    onTapOutside: (_) {
                      normalizeDate(
                        controller.firstPeriodStartDate.text,
                        controller.firstPeriodStartDate,
                      );
                    },
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'Years #',
                    isnumber: true,
                    controller: controller.numberOfYears,
                    width: 100,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: myTextFormFieldWithBorder(
                maxLines: 10,
                labelText: 'Notes',
                controller: controller.notes,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
