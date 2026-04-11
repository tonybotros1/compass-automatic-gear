import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../consts.dart';
import 'leaves_screen.dart';

Future<dynamic> leavesDialog({
  required BoxConstraints constraints,
  required EmployeesController controller,
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
                    "Leaves",
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: leavesScreen(
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
