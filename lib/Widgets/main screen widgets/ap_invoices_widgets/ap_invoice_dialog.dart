import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_invoice_or_edit.dart';

Future<dynamic> apInvoiceDialog(
    {required BoxConstraints constraints,
    required String id,
    required ApInvoicesController controller,
    required void Function()? onPressedForSave,
    required void Function()? onPressedForPost,
    required void Function()? onPressedForDelete,
    required void Function()? onPressedForCancel,
    required bool canEdit}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        insetPadding: const EdgeInsets.all(8),
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
                      '💸 Invoices',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    GetX<ApInvoicesController>(builder: (controller) {
                      return controller.status.value != ''
                          ? statusBox(controller.status.value)
                          : const SizedBox();
                    }),
                    const Spacer(),
                    separator(),
                    GetBuilder<ApInvoicesController>(
                        builder: (controller) => ClickableHoverText(
                              onTap: onPressedForSave,
                              text: 'Save',
                            )),
                    point(),
                    GetBuilder<ApInvoicesController>(builder: (controller) {
                      return ClickableHoverText(
                          onTap: onPressedForPost, text: 'Post');
                    }),
                    if (onPressedForCancel != null)
                      GetBuilder<ApInvoicesController>(builder: (controller) {
                        return Row(
                          spacing: 10,
                          children: [
                            point(),
                            ClickableHoverText(
                                onTap: onPressedForCancel, text: 'Cancel'),
                          ],
                        );
                      }),
                    separator(),
                    if (onPressedForDelete != null)
                      GetBuilder<ApInvoicesController>(builder: (controller) {
                        return Row(
                          spacing: 10,
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
                  child: addNewAPInvoiceOrEdit(
                    id: id,
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
