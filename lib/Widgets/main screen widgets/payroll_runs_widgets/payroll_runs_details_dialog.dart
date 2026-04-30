import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../../consts.dart';
import 'payroll_runs_details_screen.dart';

Future<dynamic> payrollRunsDetails({
  required BoxConstraints constraints,
  required PayrollRunsController controller,
  required BuildContext context,
  void Function()? onTapForRollback,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                GetX<PayrollRunsController>(
                  builder: (controller) {
                    return ClickableHoverText(
                      text: controller.rollingBack.isFalse ? 'Rollback' : "•••",
                      onTap: onTapForRollback,
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
              child: payrollRunsDetailsScreen(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
