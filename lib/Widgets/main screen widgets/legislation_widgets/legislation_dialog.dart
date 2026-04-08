import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_legilation_or_edit.dart';

Future<dynamic> legislationDialog({
  required BoxConstraints constraints,
  required LegislationController controller,
  required BuildContext context,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: constraints.maxWidth * 0.75,
        height: constraints.maxHeight * 0.75,
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
                  GetX<LegislationController>(
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
                child: addNewLegistlationOrEdit(
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
