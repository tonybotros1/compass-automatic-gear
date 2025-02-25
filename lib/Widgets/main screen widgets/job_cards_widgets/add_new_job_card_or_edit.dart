import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/cupertino.dart';
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
      controller: controller.scrollController,
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
              return CupertinoCheckbox(
                  checkColor: mainColor,
                  activeColor: Colors.white,
                  value: controller.isQuotationExpanded.value,
                  onChanged: (value) {
                    if (controller.isQuotationExpanded.isTrue) {
                      controller.isQuotationExpanded.value = false;
                    } else {
                      controller.isQuotationExpanded.value = true;
                      controller.scrollToBottom();
                    }
                  });
            }),
            Text(
              'Quotation',
              style: fontStyle1,
            ),
            SizedBox(width: 10),
            GetX<JobCardController>(builder: (controller) {
              if (controller.quotationStatus.value.isNotEmpty) {
                return statusBox(controller.quotationStatus.value);
              } else {
                return SizedBox();
              }
            })
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
              return CupertinoCheckbox(
                  checkColor: mainColor,
                  activeColor: Colors.white,
                  value: controller.isJobCardExpanded.value,
                  onChanged: (value) {
                    if (controller.isJobCardExpanded.isTrue) {
                      controller.isJobCardExpanded.value = false;
                    } else {
                      controller.isJobCardExpanded.value = true;
                      controller.scrollToBottom();
                    }
                  });
            }),
            Text(
              'Job Card',
              style: fontStyle1,
            ),
            SizedBox(width: 10),
            GetX<JobCardController>(builder: (controller) {
              if (controller.jobStatus1.value.isNotEmpty) {
                return statusBox(controller.jobStatus1.value);
              } else {
                return SizedBox();
              }
            }),
            SizedBox(width: 10),
            GetX<JobCardController>(builder: (controller) {
              if (controller.jobStatus2.value.isNotEmpty) {
                return statusBox(controller.jobStatus2.value);
              } else {
                return SizedBox();
              }
            })
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

Container statusBox(String status, {hieght = 30, width}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(5),
        color: status == 'New' 
            ? Colors.green
            : status == 'Posted' 
                ? Colors.teal
                : status == 'Cancelled'
                    ? Colors.red
                    : status == 'Approved' 
                        ? Color(0xffD2665A)
                        : status == 'Ready' 
                            ? Color(0xff7886C7)
                            : status == 'Closed' || status == 'Under Warranty' 
                                ? Colors.black
                                : Colors.brown),
    height: hieght,
    width: width,
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      status,
      style: TextStyle(color: Colors.white),
    ),
  );
}
