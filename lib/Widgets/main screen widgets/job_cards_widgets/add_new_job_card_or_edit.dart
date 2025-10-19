import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/job_cards_widgets/invoice_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';
import 'job_card_section.dart';

Widget addNewJobCardOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  bool? canEdit,
  required jobId,
}) {
  return SingleChildScrollView(
    controller: controller.scrollController,
    child: Column(
      children: [
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  labelContainer(lable: Text('Car Details', style: fontStyle1)),
                  carDetailsSection(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Customer Details', style: fontStyle1),
                  ),
                  customerDetailsSection(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Job Details', style: fontStyle1),
                        GetX<JobCardController>(
                          builder: (controller) {
                            return controller.quotationCounter.value.isNotEmpty
                                ? ClickableHoverText(
                                    color2:
                                        controller
                                            .openingQuotationCardScreen
                                            .isFalse
                                        ? null
                                        : Colors.yellow,
                                    text:
                                        controller
                                            .openingQuotationCardScreen
                                            .isFalse
                                        ? controller.quotationCounter.value
                                        : 'Loading...',
                                    onTap:
                                        controller
                                            .openingQuotationCardScreen
                                            .isFalse
                                        ? () async {
                                            controller
                                                .openQuotationCardScreenByNumber(
                                                  controller.quotationId.value,
                                                );
                                          }
                                        : null,
                                  )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                  jobCardSection(context, controller),
                ],
              ),
            ),
          ],
        ),
        labelContainer(
          lable: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Invoice Items', style: fontStyle1),
              newinvoiceItemsButton(context, constraints, controller, jobId),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: invoiceItemsSection(
            constraints: constraints,
            context: context,
            jobId: jobId,
          ),
        ),
      ],
    ),
  );
}
