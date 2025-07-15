import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import 'account_informations_section.dart';
import 'available_invoices_dialog.dart';
import 'invoices_table_section.dart';
import 'payment_header_section.dart';

Widget addNewPaymentOrEdit({
  required BuildContext context,
  required CashManagementController controller,
  required bool canEdit,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight - 60),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  labelContainer(
                                    lable: Text('Payment Header',
                                        style: fontStyle1),
                                  ),
                                  paymentHeader(context),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  labelContainer(
                                    lable: Text('Account Information',
                                        style: fontStyle1),
                                  ),
                                  accountInformations(context, true),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        const SizedBox(height: 10),
                        // Invoices button
                        labelContainer(
                          lable: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Invoices', style: fontStyle1),
                              GetX<CashManagementController>(builder: (_) {
                                return ElevatedButton(
                                  style: new2ButtonStyle,
                                  onPressed: controller.vendorNameId.isEmpty
                                      ? () {
                                          showSnackBar('Alert',
                                              'Please Select vendor First');
                                        }
                                      : () {
                                          if (controller
                                              .availablePayments.isEmpty) {
                                            controller.getVendorInvoices(
                                                controller.vendorNameId.value);
                                          }
                                          Get.dialog(
                                            barrierDismissible: false,
                                            Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, dlgConstraints) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        width: dlgConstraints
                                                                .maxWidth /
                                                            1.1,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                          color: mainColor,
                                                        ),
                                                        child: Row(
                                                          spacing: 10,
                                                          children: [
                                                            Text('💸 Invoices',
                                                                style:
                                                                    fontStyleForScreenNameUsedInButtons),
                                                            const Spacer(),
                                                            ElevatedButton(
                                                              style:
                                                                  new2ButtonStyle,
                                                              onPressed: controller
                                                                  .addSelectedPayments,
                                                              child: Text('Add',
                                                                  style:
                                                                      fontStyleForElevatedButtons),
                                                            ),
                                                            closeButton,
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:
                                                            availableInvoicesDialog(
                                                                dlgConstraints,
                                                                context,true,controller.availablePayments,controller.selectedAvailablePayments),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                  child: Text('Vendor Invoices',
                                      style: fontStyleForElevatedButtons),
                                );
                              }),
                            ],
                          ),
                        ),
                        // Expanding invoices table
                        Expanded(
                          child: Container(
                            decoration: containerDecor,
                            child: invoicesTable(
                              context: context,
                              constraints: BoxConstraints(),
                              isPayment: true,
                              list: controller.selectedAvailablePayments
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
            GetX<CashManagementController>(builder: (controller) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Total Amount Paid: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: NumberFormat("#,##0.00").format(controller
                            .calculatedAmountForAllSelectedReceipts.value),
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}
