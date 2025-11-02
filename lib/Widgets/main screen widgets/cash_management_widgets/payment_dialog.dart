import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/cash_management_payments_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_payment_or_edit.dart';

Future<dynamic> paymentDialog({
  required BoxConstraints constraints,
  required CashManagementPaymentsController controller,
  required void Function()? onPressedForSave,
  required void Function()? onPressedForPost,
  required void Function()? onPressedForDelete,
  required void Function()? onPressedForCancel,
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
                      '💸 Payment',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    GetX<CashManagementPaymentsController>(
                      builder: (controller) {
                        return controller.paymentStatus.value != ''
                            ? statusBox(controller.paymentStatus.value)
                            : const SizedBox();
                      },
                    ),
                    const Spacer(),
                    separator(),
                    GetBuilder<CashManagementPaymentsController>(
                      builder: (controller) => ClickableHoverText(
                        onTap: onPressedForSave,
                        text: controller.isScreenLodingForPayments.isFalse
                            ? 'Save'
                            : "•••",
                      ),
                    ),
                    point(),
                    GetBuilder<CashManagementPaymentsController>(
                      builder: (controller) {
                        return ClickableHoverText(
                          onTap: onPressedForPost,
                          text: 'Post',
                        );
                      },
                    ),
                    if (onPressedForCancel != null)
                      Row(
                        spacing: 10,
                        children: [
                          point(),
                          GetBuilder<CashManagementPaymentsController>(
                            builder: (controller) {
                              return ClickableHoverText(
                                onTap: onPressedForCancel,
                                text: 'Cancel',
                              );
                            },
                          ),
                        ],
                      ),
                    separator(),
                    if (onPressedForDelete != null)
                      GetBuilder<CashManagementPaymentsController>(
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
                  child: addNewPaymentOrEdit(
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
