import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_contact_and_relavente_or_edit.dart';

Future<dynamic> contactsAndRelativesInsertingDialog({
  required BoxConstraints constraints,
  required EmployeesController controller,
  required bool canEdit,
  required void Function()? onPressed,
  required void Function()? onPressedForDocumentAndRecord,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: 600,
        height: 700,
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
                  Text('C & R', style: fontStyleForScreenNameUsedInButtons),

                  const Spacer(),
                  separator(),

                  GetX<EmployeesController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text:
                          controller.addingNewContactAndRelativesValue.value ==
                              false
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
                child: addNewContactAndRelativeOrEdit(
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
