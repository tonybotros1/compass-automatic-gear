
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../consts.dart';
import 'add_new_invoice_item_or_edit.dart';

Future<dynamic> invoiceItemsForJobDialog(
    {required String jobId,
    required JobCardController controller,
    required BoxConstraints constraints,
    required void Function()? onPressed}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          width: Get.width / 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: mainColor,
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      '💵 Invoice Items',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    Spacer(),
                    GetX<JobCardController>(
                        builder: (controller) => ElevatedButton(
                              onPressed: onPressed,
                              style: new2ButtonStyle,
                              child:
                                  controller.addingNewinvoiceItemsValue.value ==
                                          false
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
                    closeButton
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: addNewinvoiceItemsOrEdit(
                  controller: controller,
                ),
              ))
            ],
          ),
        ),
      ));
}
