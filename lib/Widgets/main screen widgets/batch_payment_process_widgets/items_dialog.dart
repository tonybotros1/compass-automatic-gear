import 'package:datahubai/Controllers/Main%20screen%20controllers/batch_payment_process_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_item_or_edit.dart';

Future<dynamic> batchItemsDialog({
  required void Function()? onTapForSave,
  required BatchPaymentProcessController controller,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 600,
        height: 700,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                GetX<BatchPaymentProcessController>(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items',
                            style: fontStyleForScreenNameUsedInButtons,
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

                              separator(),
                              closeIcon(),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: addNewBatchItemOrEdit(
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
    ),
  );
}
