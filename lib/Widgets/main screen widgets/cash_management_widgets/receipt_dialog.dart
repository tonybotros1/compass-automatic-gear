import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../consts.dart';
import 'add_new_receipt_or_edit.dart';

Future<dynamic> receiptDialog(
    {required BoxConstraints constraints,
    required CashManagementController controller,
    required void Function()? onPressed,
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
                      '💸 Receipt',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    const Spacer(),
                    GetX<CashManagementController>(
                        builder: (controller) => ElevatedButton(
                              onPressed: onPressed,
                              style: new2ButtonStyle,
                              child: controller.addingNewValue.value == false
                                  ? const Text(
                                      'Save',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                            )),
                    closeButton,
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: addNewReceiptOrEdit(
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
