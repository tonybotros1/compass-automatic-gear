import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import 'add_new_payroll_element_or_edit.dart';

Future<dynamic> payrollElementsDialog({
  required EmployeesController controller,
  required bool canEdit,
  required void Function()? onPressed,
  required BuildContext context,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 400,
        width: 400,
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
                  Text('Payroll', style: fontStyleForScreenNameUsedInButtons),
                  const Spacer(),
                  GetX<EmployeesController>(
                    builder: (controller) {
                      return ClickableHoverText(
                        onTap: onPressed,
                        text: controller.addingNewEmployeePhoneValue.isFalse
                            ? 'Save'
                            : '•••',
                      );
                    },
                  ),
                  separator(),
                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewPayrollElementOrEdit(
                  controller: controller,
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
