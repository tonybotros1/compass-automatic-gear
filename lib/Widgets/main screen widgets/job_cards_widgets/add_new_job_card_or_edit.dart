import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/job_cards_widgets/invoice_items_widget.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';
import 'job_card_section.dart';

Widget addNewJobCardOrEdit(
    {required BoxConstraints constraints,
    required BuildContext context,
    required JobCardController controller,
    bool? canEdit,
    required jobId}) {
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
                      'Job Details',
                      style: fontStyle1,
                    )),
                jobCardSection(context, controller)
              ],
            ),
          ),
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
          newinvoiceItemsButton(context, constraints, controller, jobId),
        ],
      )),
      SizedBox(
        height: 250,
        child: invoiceItemsSection(
            constraints: constraints, context: context, jobId: jobId),
      )
    ],
  );
}
