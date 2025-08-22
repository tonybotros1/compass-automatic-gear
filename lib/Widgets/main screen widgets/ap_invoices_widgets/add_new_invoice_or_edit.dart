import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:flutter/material.dart';
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
                      minHeight: constraints.maxHeight -
                          60), // reserve space for total
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top sections
                        Expanded(
                          child: Column(
                            children: [
                              labelContainer(
                                lable:
                                    Text('Payment Header', style: fontStyle1),
                              ),
                              paymentHeader(context),
                              const SizedBox(height: 20),
                              labelContainer(
                                lable: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Invoices', style: fontStyle1),
                                 newinvoiceItemsButton(context,constraints,controller,id)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 250,
                                child: invoicesSection(
                                    context: context,
                                    constraints: constraints,
                                    id: id),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
