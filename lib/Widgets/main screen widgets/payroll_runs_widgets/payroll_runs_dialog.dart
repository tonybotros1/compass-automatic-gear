import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_payroll_run_or_edit.dart';

Future<dynamic> payrollRunsDialog({
  required BoxConstraints constraints,
  required PayrollRunsController controller,
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
        height: 600,
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
                  Text(
                    controller.getScreenName(),
                    style: fontStyleForScreenNameUsedInButtons,
                  ),

                  const Spacer(),
                  separator(),

                  GetX<PayrollRunsController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.addingNewValue.value == false
                          ? 'Run'
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
                child: addNewPayrollRunsOrEdit(
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
