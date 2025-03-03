import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/invoice_items_controller.dart';
import '../../../consts.dart';
import 'add_new_invoice_item_or_edit.dart';

Future<dynamic> invoiceItemsDialog({
  required BoxConstraints constraints,
  required InvoiceItemsController controller,
  required void Function()? onPressed,
}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: EdgeInsets.all(8),
        child: SizedBox(
          height: 500,
          width: constraints.maxWidth / 2.5,
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
                      controller.getScreenName(),
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    Spacer(),
                    GetX<InvoiceItemsController>(
                        builder: (controller) => ElevatedButton(
                              onPressed: onPressed,
                              style: new2ButtonStyle,
                              child: controller.addingNewValue.value == false
                                  ? const Text(
                                      'Save',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SizedBox(
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
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: addNewinvoiceItemsOrEdit(
                  controller: controller,
                ),
              ))
            ],
          ),
        ),
      ));
}
