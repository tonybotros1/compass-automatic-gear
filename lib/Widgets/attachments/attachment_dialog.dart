import 'package:datahubai/Controllers/Widgets%20controllers/attachment_controller.dart';
import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'add_new_attachment.dart';

Future<dynamic> attachmentDialog({
  required AttachmentController controller,
  required bool canEdit,
  required void Function()? onPressed,
  required BuildContext context,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 500,
        width: 800,
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
                    'Attachments',
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  GetX<AttachmentController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: controller.addingNewAttachment.isFalse
                          ? onPressed
                          : null,
                      text: controller.addingNewAttachment.isFalse
                          ? 'Save'
                          : '•••',
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
                child: addNewAttachment(
                  controller: controller,
                  canEdit: canEdit,
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
