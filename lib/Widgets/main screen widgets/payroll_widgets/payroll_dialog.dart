import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_payroll_or_edit.dart';

Future<dynamic> payrollDialog({
  required BoxConstraints constraints,
  required PayrollController controller,
  required void Function()? onPressed,
  required void Function()? onPressedForDelete,
  required BuildContext context,
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

                  const Spacer(),
                  separator(),

                  GetX<PayrollController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: controller.addingNewValue.isFalse
                          ? onPressed
                          : null,
                      text: controller.addingNewValue.value == false
                          ? 'Save'
                          : "•••",
                    ),
                  ),
                  onPressedForDelete != null
                      ? Row(
                          spacing: 10,
                          children: [
                            point(),
                            ClickableHoverText(
                              onTap: onPressedForDelete,
                              text: 'Delete',
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
                child: addNewPayrollOrEdit(
                  controller: controller,
                  constraints: constraints,
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
