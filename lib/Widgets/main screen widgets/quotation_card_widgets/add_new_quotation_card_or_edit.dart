import 'package:datahubai/Controllers/Main%20screen%20controllers/quotation_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  return SizedBox(
    width: Get.width, //constraints.maxWidth,
    child: ListView(
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
                  const SizedBox(
                    height: 20,
                  ),
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
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                labelContainer(
                    lable: Row(
                  children: [
                    Text(
                      'Quotation Details',
                      style: fontStyle1,
                    ),
                   
                   
                    const Spacer(),
                    // quotaionId != null && quotaionId != ''
                    //     ? Row(
                    //         spacing: 10,
                    //         children: [
                    //           GetBuilder<QuotationCardController>(
                    //               builder: (controller) {
                    //             return ElevatedButton(
                    //                 style: postButtonStyle,
                    //                 onPressed: () {
                    //                   if (controller.quotationStatus.value !=
                    //                           'Posted' &&
                    //                       controller.quotationStatus.value !=
                    //                           'Cancelled' &&
                    //                       controller.quotationStatus.value
                    //                           .isNotEmpty) {
                    //                     controller
                    //                         .editPostForQuotation(quotaionId);
                    //                   } else if (controller
                    //                           .quotationStatus.value ==
                    //                       'Posted') {
                    //                     showSnackBar('Alert',
                    //                         'Quotation is Already Posted');
                    //                   } else if (controller
                    //                           .quotationStatus.value ==
                    //                       'Cancelled') {
                    //                     showSnackBar(
                    //                         'Alert', 'Quotation is Cancelled');
                    //                   } else if (controller
                    //                       .quotationStatus.value.isEmpty) {
                    //                     showSnackBar('Alert',
                    //                         'Please Save The Quotation First');
                    //                   }
                    //                 },
                    //                 child: const Text('Post',
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold)));
                    //           }),
                    //           GetBuilder<QuotationCardController>(
                    //               builder: (controller) {
                    //             return ElevatedButton(
                    //                 style: cancelJobButtonStyle,
                    //                 onPressed: () {
                    //                   if (controller.quotationStatus.value !=
                    //                           'Cancelled' &&
                    //                       controller.quotationStatus.value
                    //                           .isNotEmpty) {
                    //                     controller
                    //                         .editCancelForQuotation(quotaionId);
                    //                   } else if (controller
                    //                           .quotationStatus.value ==
                    //                       'Cancelled') {
                    //                     showSnackBar('Alert',
                    //                         'Quotation Already Cancelled');
                    //                   } else if (controller
                    //                       .quotationStatus.value.isEmpty) {
                    //                     showSnackBar('Alert',
                    //                         'Please Save The Quotation First');
                    //                   }
                    //                 },
                    //                 child: const Text('Cancel',
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold)));
                    //           }),
                    //         ],
                    //       )
                    //     : const SizedBox(),
                  ],
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
    ),
  );
}
