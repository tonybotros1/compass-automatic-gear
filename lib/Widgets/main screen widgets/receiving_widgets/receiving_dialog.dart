import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_receiving_or_edit.dart';

Future<dynamic> receivigDialog({
  required void Function()? onTapForSave,
  void Function()? onTapForDelete,
  void Function()? onTapForPost,
  void Function()? onTapForCancel,
  required ReceivingController controller,
  String? id,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              GetX<ReceivingController>(
                builder: (controller) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      color: mainColor,
                    ),
                    padding: const EdgeInsets.all(16),
                    width: constraints.maxWidth,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 40,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 20,
                              children: [
                                Text(
                                  controller.getScreenName(),
                                  style: fontStyleForScreenNameUsedInButtons,
                                ),
                                controller.status.value.isNotEmpty
                                    ? statusBox(
                                        controller.status.value,
                                        hieght: 35,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                separator(),
                                ClickableHoverText(
                                  onTap: controller.addingNewValue.isFalse
                                      ? onTapForSave
                                      : null,
                                  text: 'Save',
                                ),
                                if (onTapForDelete != null)
                                  Row(
                                    spacing: 10,
                                    children: [
                                      point(),

                                      ClickableHoverText(
                                        onTap: onTapForDelete,
                                        text: 'Delete',
                                      ),
                                    ],
                                  ),
                                separator(),
                                ClickableHoverText(
                                  onTap: onTapForPost,
                                  text: 'Post',
                                ),
                                if (onTapForCancel != null)
                                  Row(
                                    spacing: 10,
                                    children: [
                                      point(),
                                      ClickableHoverText(
                                        onTap: onTapForCancel,
                                        text: 'Cancel',
                                      ),
                                    ],
                                  ),
                                separator(),
                                closeIcon(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: addNewReceiveOrEdit(
                    controller: controller,
                    constraints: constraints,
                    context: context,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
