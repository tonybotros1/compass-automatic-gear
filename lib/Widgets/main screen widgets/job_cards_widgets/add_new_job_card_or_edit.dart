import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/job_cards_widgets/invoice_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
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
                  carDetailsSection(controller, constraints),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Customer Details', style: fontStyle1),
                  ),
                  customerDetailsSection(controller, constraints),
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

        labelContainer(lable: Text('Notes', style: fontStyle1)),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: containerDecor,
          child: Row(
            spacing: 50,
            children: [
              Expanded(
                child: myTextFormFieldWithBorder(
                  labelText: 'Job Notes',
                  controller: controller.jobNotes,
                  maxLines: 3,
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
              ),
              Expanded(
                child: myTextFormFieldWithBorder(
                  labelText: 'Delivery Notes',
                  controller: controller.deliveryNotes,
                  maxLines: 3,
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
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
