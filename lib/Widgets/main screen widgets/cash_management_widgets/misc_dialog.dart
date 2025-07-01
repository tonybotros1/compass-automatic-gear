import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_misc_or_delete.dart';

Future<dynamic> miscDialog(
    {required BoxConstraints constraints,
    required BuildContext context,
    required CashManagementController controller,
    required void Function()? onPressedForSave,
    required void Function()? onPressedForPost,
    required void Function()? onPressedForDelete,
    required bool canEdit}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        insetPadding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  color: mainColor,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      '💸 Misc',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    GetX<CashManagementController>(builder: (controller) {
                      return controller.miscStatus.value != ''
                          ? statusBox(controller.miscStatus.value)
                          : SizedBox();
                    }),
                    const Spacer(),
                    separator(),
                    GetBuilder<CashManagementController>(
                        builder: (controller) => ClickableHoverText(
                              onTap: onPressedForSave,
                              text: 'Save',
                            )),
                    point(),
                    GetBuilder<CashManagementController>(builder: (controller) {
                      return ClickableHoverText(
                          onTap: onPressedForPost, text: 'Post');
                    }),
                    separator(),
                    if (onPressedForDelete != null)
                      GetBuilder<CashManagementController>(
                          builder: (controller) {
                        return Row(spacing: 10,
                          children: [
                            ClickableHoverText(
                                onTap: onPressedForDelete, text: 'Delete'),
                            separator(),
                          ],
                        );
                      }),
                    closeIcon(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: addNewMiscOrEdit(
                    context: context,
                    controller: controller,
                    canEdit: canEdit,
                  ),
                ),
              )
            ],
          );
        }),
      ));
}
