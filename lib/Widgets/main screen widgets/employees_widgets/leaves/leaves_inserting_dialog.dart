import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../consts.dart';
import '../../../text_button.dart';
import 'add_new_leave_or_edit.dart';

Future<dynamic> leavesInsertingDialog({
  required BoxConstraints constraints,
  required EmployeesController controller,
  required bool canEdit,
  required void Function()? onPressed,
  required void Function()? onPressedForPost,
  required void Function()? onPressedForCancel,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: 600,
        height: 570,
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
                  Text('Leaves', style: fontStyleForScreenNameUsedInButtons),
                  controller.employeeLeaveStatus.value.isNotEmpty
                      ? statusBox(
                          controller.employeeLeaveStatus.value,
                          hieght: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                        )
                      : const SizedBox(),

                  const Spacer(),
                  separator(),

                  GetX<EmployeesController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.addingNewLeaveValue.value == false
                          ? 'Save'
                          : "•••",
                    ),
                  ),

                  onPressedForPost != null
                      ? Row(
                          spacing: 10,
                          children: [
                            separator(),
                            ClickableHoverText(
                              onTap: onPressedForPost,
                              text: 'Post',
                            ),
                            point(),
                            ClickableHoverText(
                              onTap: onPressedForCancel,
                              text: 'Cancel',
                            ),
                          ],
                        )
                      : const SizedBox(),
                  separator(),

                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewLeaveOrEdit(
                  controller: controller,
                  canEdit: canEdit,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
