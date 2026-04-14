import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_period_or_edit.dart';

Future<dynamic> periodDialog({
  required PayrollController controller,
  required void Function()? onPressed,
  required BuildContext context,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 350,
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
                  Text("Periods", style: fontStyleForScreenNameUsedInButtons),

                  const Spacer(),
                  GetX<PayrollController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.addingNewPeriodValue.value == false
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
                child: addNewPeriodOrEdit(
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
