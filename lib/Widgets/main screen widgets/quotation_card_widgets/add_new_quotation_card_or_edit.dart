import 'package:datahubai/Controllers/Main%20screen%20controllers/quotation_card_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import 'car_details_section.dart';
import 'customer_details_screen.dart';
import 'invoice_items_section.dart';
import 'quotation_section.dart';

Widget addNewQuotationCardOrEdit(
    {required BoxConstraints constraints,
    required BuildContext context,
    required QuotationCardController controller,
    bool? canEdit,
    required quotaionId}) {
  return ListView(
    controller: controller.scrollController,
    children: [
      Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                labelContainer(
                    lable: Text(
                  'Car Details',
                  style: fontStyle1,
                )),
                carDetailsSection(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                labelContainer(
                    lable: Text(
                  'Customer Details',
                  style: fontStyle1,
                )),
                customerDetailsSection(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Expanded(
              child: Column(
            children: [
              labelContainer(
                  lable: Text(
                    'Quotation Details',
                    style: fontStyle1,
                  )),
              quotationsSection(context, controller)
            ],
          ))
        ],
      ),
      labelContainer(
          lable: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Invoice Items',
            style: fontStyle1,
          ),
          newinvoiceItemsButton(context, constraints, controller, quotaionId),
        ],
      )),
      SizedBox(
        height: 250,
        child: invoiceItemsSection(
            constraints: constraints,
            context: context,
            quotationId: quotaionId),
      )
    ],
  );
}
