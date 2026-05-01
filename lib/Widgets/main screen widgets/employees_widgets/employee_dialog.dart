import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../text_button.dart';
import 'add_new_employee_or_edit.dart';

Future<dynamic> employeeDialog({
  required BoxConstraints constraints,
  required EmployeesController controller,
  required void Function()? onPressed,
  required void Function()? onPressedForAttachment,
  required void Function()? onPressedForContactsAndRelatives,
  required void Function()? onPressedForLeaves,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: mainColor,
              ),
              child: Row(
                spacing: 10,
                children: [
                  Text(
                    controller.getScreenName(),
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  MenuWithValues(
                    hideClearButton: true,
                    dialogWidth: 600,
                    width: 150,
                    controller: controller.periodFilter,
                    displayKeys: const ['period_name'],
                    displaySelectedKeys: const ['period_name'],
                    data: controller.generatePeriodsFromString(
                      convertDateToIson(controller.hireDate.text).toString(),
                    ),
                    onSelected: (value) async {
                      await controller.filterEmployeePayrollElementsByPeriod(
                        value['period_name'],
                      );
                    },
                  ),
                  const Spacer(),
                  GetX<EmployeesController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.addingNewValue.value == false
                          ? 'Save'
                          : "•••",
                    ),
                  ),
                  separator(),
                  ClickableHoverText(onTap: onPressedForLeaves, text: 'Leaves'),
                  point(),

                  ClickableHoverText(
                    onTap: onPressedForContactsAndRelatives,
                    text: 'Contacts and Relatives',
                  ),
                  point(),
                  ClickableHoverText(
                    onTap: onPressedForAttachment,
                    text: 'Document of Record',
                  ),
                  separator(),
                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewEmployeeOrEdit(
                  controller: controller,
                  constraints: constraints,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
