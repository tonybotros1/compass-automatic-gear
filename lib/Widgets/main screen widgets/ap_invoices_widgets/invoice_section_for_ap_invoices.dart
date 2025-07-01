import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'add_new_invoice_for_ap_invoices_or_edit.dart';

Future<dynamic> invoiceItemsForapInvoicesDialog(
    {required String apInvoiceID,
    required ApInvoicesController controller,
    required BuildContext context,
    required BoxConstraints constraints,
    required void Function()? onPressed}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          width: Get.width / 1.7,
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
                      '💵 Invoices',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    const Spacer(),
                    GetX<ApInvoicesController>(
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
                padding: const EdgeInsets.all(16),
                child: addNewinvoiceForApInvoicesOrEdit(
                  context: context,
                  controller: controller,
                  constraints:constraints,
                ),
              ))
            ],
          ),
        ),
      ));
}
