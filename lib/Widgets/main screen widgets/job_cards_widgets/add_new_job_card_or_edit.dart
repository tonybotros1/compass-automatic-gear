import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';
import 'job_card_section.dart';
import 'quotations_section.dart';

Widget addNewJobCardOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: Get.width, //constraints.maxWidth,
    child: ListView(
      children: [
        labelContainer(
            lable: Text(
          'Car Details',
          style: fontStyle1,
        )),
        carDetailsSection(),
        SizedBox(
          height: 20,
        ),
        labelContainer(
            lable: Text(
          'Customer Details',
          style: fontStyle1,
        )),
        customerDetailsSection(),
        SizedBox(
          height: 20,
        ),
        labelContainer(
            lable: Row(
          children: [
            GetX<JobCardController>(builder: (controller) {
              return ExpandIcon(
                  color: Colors.white,
                  isExpanded: controller.isQuotationExpanded.value,
                  onPressed: (value) {
                    if (controller.isQuotationExpanded.isTrue) {
                      controller.isQuotationExpanded.value = false;
                    } else {
                      controller.isQuotationExpanded.value = true;
                    }
                  });
            }),
            Text(
              'Quotation',
              style: fontStyle1,
            ),
          ],
        )),
        GetX<JobCardController>(builder: (controller) {
          return AnimatedCrossFade(
            duration: Duration(milliseconds: 300), // Set your desired duration
            firstChild: Container(), // Empty container when collapsed
            secondChild: quotationsSection(
                context, controller), // Your quotation section widget
            crossFadeState: controller.isQuotationExpanded.value
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          );
        }),
        SizedBox(
          height: 20,
        ),
        labelContainer(
            lable: Row(
          children: [
            GetX<JobCardController>(builder: (controller) {
              return ExpandIcon(
                  color: Colors.white,
                  isExpanded: controller.isJobCardExpanded.value,
                  onPressed: (value) {
                    if (controller.isJobCardExpanded.isTrue) {
                      controller.isJobCardExpanded.value = false;
                    } else {
                      controller.isJobCardExpanded.value = true;
                    }
                  });
            }),
            Text(
              'Job Card',
              style: fontStyle1,
            ),
          ],
        )),
        GetX<JobCardController>(builder: (controller) {
          return AnimatedCrossFade(
            duration: Duration(milliseconds: 300), // Set your desired duration
            firstChild: Container(), // Empty container when collapsed
            secondChild: jobCardSection(
                context, controller), // Your quotation section widget
            crossFadeState: controller.isJobCardExpanded.value
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          );
        }),
      ],
    ),
  );
}
