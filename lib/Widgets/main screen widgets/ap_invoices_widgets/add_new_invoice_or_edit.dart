import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../consts.dart';
import 'invoices_section.dart';
import 'payment_header.dart';

Widget addNewAPInvoiceOrEdit({
  required ApInvoicesController controller,
  required bool canEdit,
  required String id,
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
                        Expanded(
                          child: Column(
                            children: [
                              labelContainer(
                                lable: Text(
                                  'Payment Header',
                                  style: fontStyle1,
                                ),
                              ),
                              paymentHeader(context),
                              const SizedBox(height: 20),
                              labelContainer(
                                lable: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Invoices', style: fontStyle1),
                                    newinvoiceItemsButton(
                                      context,
                                      constraints,
                                      controller,
                                      id,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: invoicesSection(
                                  context: context,
                                  constraints: constraints,
                                  id: id,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GetX<ApInvoicesController>(
              builder: (controller) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Total Amount: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: NumberFormat("#,##0.00").format(
                                controller
                                    .calculatedAmountForInvoiceItems
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
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Total VAT: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: NumberFormat("#,##0.00").format(
                                controller.calculatedVatForInvoiceItems.value,
                              ),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
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
