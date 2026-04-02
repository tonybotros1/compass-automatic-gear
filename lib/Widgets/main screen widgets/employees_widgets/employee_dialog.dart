import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_employee_or_edit.dart';

Future<dynamic> employeeDialog({
  required BoxConstraints constraints,
  required EmployeesController controller,
  required bool canEdit,
  required void Function()? onPressed,
  required void Function()? onPressedForAttachment,
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
                    canEdit == true
                        ? controller.getScreenName()
                        : "🫆 ${controller.employeeName.text}",
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  GetX<EmployeesController>(
                    builder: (ctl) {
                      if (ctl.employeeStatusForBar.value.isNotEmpty) {
                        return statusBox(
                          ctl.employeeStatusForBar.value,
                          hieght: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                        );
                      }
                      return const SizedBox();
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
                  canEdit: canEdit,
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
