import 'package:datahubai/Widgets/text_button.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Controllers/Main screen controllers/cash_management_receipts_controller.dart';
import 'account_informations_section.dart';
import 'available_invoices_dialog.dart';
import 'invoices_table_section.dart';
import 'receipt_headers_sectiob.dart';

Widget addNewReceiptOrEdit({
  required BuildContext context,
  required CashManagementReceiptsController controller,
  required bool canEdit,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 60,
                  ), // reserve space for total
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top sections
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  labelContainer(
                                    lable: Text(
                                      'Receipt Header',
                                      style: fontStyle1,
                                    ),
                                  ),
                                  receiptHeader(context, constraints),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  labelContainer(
                                    lable: Text(
                                      'Account Information',
                                      style: fontStyle1,
                                    ),
                                  ),
                                  accountInformations(
                                    context,
                                    false,
                                    controller,
                                    constraints,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Invoices button
                        labelContainer(
                          lable: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Invoices', style: fontStyle1),
                              GetBuilder<CashManagementReceiptsController>(
                                builder: (_) {
                                  return ElevatedButton(
                                    style: new2ButtonStyle,
                                    onPressed: () {
                                      if (controller.customerNameId.isEmpty) {
                                        alertMessage(
                                          context: Get.context!,
                                          content:
                                              'Please Select customer First',
                                        );
                                        return;
                                      }

                                      controller.getCustomerInvoices(
                                        controller.customerNameId.value,
                                      );
                                      Get.dialog(
                                        barrierDismissible: false,
                                        Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: LayoutBuilder(
                                            builder: (context, dlgConstraints) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        dlgConstraints
                                                            .maxWidth /
                                                        1.1,
                                                    padding:
                                                        const EdgeInsets.all(
                                                          16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  5,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  5,
                                                                ),
                                                          ),
                                                      color: mainColor,
                                                    ),
                                                    child: Row(
                                                      spacing: 10,
                                                      children: [
                                                        Text(
                                                          '💸 Invoices',
                                                          style:
                                                              fontStyleForScreenNameUsedInButtons,
                                                        ),
                                                        const Spacer(),
                                                        ClickableHoverText(
                                                          onTap: controller
                                                              .addSelectedReceipts,
                                                          text: 'Add',
                                                        ),
                                                        separator(),
                                                        closeIcon(),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child:
                                                        availableInvoicesDialog(
                                                          dlgConstraints,
                                                          context,
                                                          false,
                                                          controller,
                                                        ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Customer Invoices',
                                      style: fontStyleForElevatedButtons,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Expanding invoices table
                        Expanded(
                          child: Container(
                            decoration: containerDecor,
                            child: invoicesTable(
                              context: context,
                              constraints: const BoxConstraints(),
                              isPayment: false,
                              controller: controller,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Fixed Total Amount at bottom
            GetX<CashManagementReceiptsController>(
              builder: (controller) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Total Amount Received: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: NumberFormat("#,##0.00").format(
                            controller
                                .calculatedAmountForAllSelectedReceipts
                                .value,
                          ),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
