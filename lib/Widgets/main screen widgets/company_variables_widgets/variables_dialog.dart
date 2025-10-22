import 'package:datahubai/Controllers/Main%20screen%20controllers/company_variables_controller.dart';
import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'update_variables.dart';

Future<dynamic> variablesDialog({
  required BoxConstraints constraints,
  required CompanyVariablesController controller,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 300,
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
                    '🔣 Variables',
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  GetX<CompanyVariablesController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.updatingVariables.value == false
                          ? 'Save'
                          : '•••',
                    ),
                  ),
                  separator(),
                  closeIcon(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: updateVariables(controller: controller),
            ),
          ],
        ),
      ),
    ),
  );
}
