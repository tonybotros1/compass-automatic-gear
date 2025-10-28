import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/cash_management_receipts_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_receipt_or_edit.dart';

Future<dynamic> receiptDialog({
  required BoxConstraints constraints,
  required CashManagementReceiptsController controller,
  required void Function()? onPressedForSave,
  required void Function()? onPressedForPost,
  required void Function()? onPressedForcancel,
  required void Function()? onPressedForDelete,
  required bool canEdit,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  color: mainColor,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      '💸 Receipt',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    GetX<CashManagementReceiptsController>(
                      builder: (controller) {
                        return controller.status.value != ''
                            ? statusBox(controller.status.value)
                            : const SizedBox();
                      },
                    ),
                    const Spacer(),
                    separator(),
                    GetX<CashManagementReceiptsController>(
                      builder: (controller) => ClickableHoverText(
                        onTap: onPressedForSave,
                        text: controller.addingNewValue.isFalse
                            ? 'Save'
                            : "•••",
                      ),
                    ),
                    point(),
                    GetBuilder<CashManagementReceiptsController>(
                      builder: (controller) {
                        return ClickableHoverText(
                          onTap: onPressedForPost,
                          text: 'Post',
                        );
                      },
                    ),
                    if (onPressedForcancel != null)
                      Row(
                        spacing: 10,
                        children: [
                          point(),
                          GetBuilder<CashManagementReceiptsController>(
                            builder: (controller) {
                              return ClickableHoverText(
                                onTap: onPressedForcancel,
                                text: 'Cancel',
                              );
                            },
                          ),
                        ],
                      ),
                    separator(),
                    if (onPressedForDelete != null)
                      GetBuilder<CashManagementReceiptsController>(
                        builder: (controller) {
                          return Row(
                            spacing: 10,
                            children: [
                              ClickableHoverText(
                                onTap: onPressedForDelete,
                                text: 'Delete',
                              ),
                              separator(),
                            ],
                          );
                        },
                      ),
                    closeIcon(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: addNewReceiptOrEdit(
                    context: context,
                    controller: controller,
                    canEdit: canEdit,
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
