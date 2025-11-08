import 'package:datahubai/Controllers/Main%20screen%20controllers/issue_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_issue_or_edit.dart';

Future<dynamic> issueDialog({
  required void Function()? onTapForSave,
  void Function()? onTapForDelete,
  void Function()? onTapForPost,
  void Function()? onTapForCancel,
  required IssueItemsController controller,
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
              GetX<IssueItemsController>(
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
                                        onTap:
                                            controller
                                                .deletingReceivingDoc
                                                .isFalse
                                            ? onTapForDelete
                                            : null,
                                        text: 'Delete',
                                      ),
                                    ],
                                  ),
                                separator(),
                                ClickableHoverText(
                                  onTap: controller.postingReceivingDoc.isFalse
                                      ? onTapForPost
                                      : null,
                                  text: 'Post',
                                ),
                                if (onTapForCancel != null)
                                  Row(
                                    spacing: 10,
                                    children: [
                                      point(),
                                      ClickableHoverText(
                                        onTap:
                                            controller
                                                .cancellingReceivingDoc
                                                .isFalse
                                            ? onTapForCancel
                                            : null,
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
                  child: addNewIssueOrEdit(
                    id: id ?? '',
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
