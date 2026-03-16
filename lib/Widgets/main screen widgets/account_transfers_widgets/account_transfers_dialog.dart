import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/account_transfers_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_account_transfer_or_edit.dart';

Future<dynamic> accounTransferItemDialog({
  required AccountTransfersController controller,
  required void Function()? onPressed,
  required void Function()? onPressedForPosted,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: 600,
            width: 500,
            child: Column(
              children: [
                Container(
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
                        '🧾 Items',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      GetBuilder<AccountTransfersController>(
                        builder: (controller) => ClickableHoverText(
                          onTap: controller.addingNewTransferValue.isTrue
                              ? null
                              : onPressed,
                          text: controller.addingNewTransferValue.isTrue
                              ? '•••'
                              : 'Save',
                        ),
                      ),
                      onPressedForPosted != null
                          ? Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                point(),
                                GetBuilder<AccountTransfersController>(
                                  builder: (controller) => ClickableHoverText(
                                    onTap: onPressedForPosted,
                                    text: 'Post',
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      separator(),
                      closeIcon(),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: addNewAccountTransferItemOrEdit(
                      controller: controller,
                      constraints: constraints,
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
