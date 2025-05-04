import 'package:datahubai/Controllers/Main%20screen%20controllers/quotation_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'add_new_invoice_item_or_edit.dart';

Future<dynamic> invoiceItemsForQuotationDialog(
    {required QuotationCardController controller,
    required BoxConstraints constraints,
    required void Function()? onPressed}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          width: Get.width / 2,
          height: 600,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: mainColor,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      '💵 Invoice Items',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    const Spacer(),
                    GetX<QuotationCardController>(
                        builder: (controller) => ElevatedButton(
                              onPressed: onPressed,
                              style: new2ButtonStyle,
                              child:
                                  controller.addingNewinvoiceItemsValue.isFalse
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
                padding: const EdgeInsets.all(16),
                child: addNewinvoiceItemsOrEdit(
                  controller: controller,
                ),
              ))
            ],
          ),
        ),
      ));
}
