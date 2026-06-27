import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewPayrollElementOrEdit({
  required EmployeesController controller,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Form(
      key: controller.employeePayrollElementFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: MenuWithValues(
                  labelText: 'Name',
                  headerLqabel: 'Name',
                  dialogWidth: 600,
                  controller: controller.employeePayrollElementName,
                  displayKeys: const ['name'],
                  displaySelectedKeys: const ['name'],
                  onDelete: () {
                    controller.employeePayrollElementvalueName.value = 'Value';
                    controller.employeePayrollElementvalueComment.value = '';
                    controller.employeePayrollElementName.clear();
                    controller.employeePayrollElementNameId.value = '';
                    controller.employeePayrollElementFunction.value = '';
                  },
                  onSelected: (value) {
                    controller.employeePayrollElementvalueName.value =
                        value.containsKey('entry_value_name')
                        ? value['entry_value_name'] ?? 'Value'
                        : 'value';
                    controller.employeePayrollElementvalueComment.value =
                        value.containsKey('comments')
                        ? value['comments'] ?? ''
                        : '';
                    controller.employeePayrollElementName.text =
                        value['name']?.toString() ?? '';
                    controller.employeePayrollElementNameId.value =
                        value['_id']?.toString() ?? '';
                    controller.employeePayrollElementFunction.value =
                        value['function']?.toString() ?? '';
                    if (value['is_recurring'] == false) {
                      setThisMonthRange(
                        fromDate: controller.employeePayrollElementStartDate,
                        toDate: controller.employeePayrollElementEndDate,
                      );
                    }
                  },
                  onOpen: () {
                    return controller.getAllPayrollElements();
                  },
                ),
              ),
              GetX<EmployeesController>(
                builder: (controller) {
                  return Tooltip(
                    message:
                        controller.employeePayrollElementvalueComment.value,
                    child: const Icon(Icons.question_mark),
                  );
                },
              ),
            ],
          ),
          Obx(
            () => myTextFormFieldWithBorder(
              width: 200,
              obscureText: false,
              controller: controller.employeePayrollElementvalue,
              labelText: controller.employeePayrollElementvalueName.value,
              isDouble: true,
              validate: controller.isIncomeTaxDeductionPayrollElement,
            ),
          ),
          myTextFormFieldWithBorder(
            labelText: 'Start Date',
            isDate: true,
            controller: controller.employeePayrollElementStartDate,
            width: 200,
            validate: false,
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
            validate: false,
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
            maxLines: 8,
            validate: false,
          ),
        ],
      ),
    ),
  );
}
