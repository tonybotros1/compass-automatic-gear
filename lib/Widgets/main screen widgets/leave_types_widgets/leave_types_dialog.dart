import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/leave_types_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_leave_type_or_edit.dart';

Future<dynamic> leaveTypesDialog({
  required BoxConstraints constraints,
  required LeaveTypesController controller,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 370,
        width: 500,
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

                  const Spacer(),
                  GetX<LeaveTypesController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.addingNewValue.value == false
                          ? 'Save'
                          : "•••",
                    ),
                  ),
                  separator(),
                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewLeaveTypeOrEdit(
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
