import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';
import 'job_card_section.dart';
import 'quotations_section.dart';

Widget addNewJobCardOrEdit(
    {required BoxConstraints constraints,
    required BuildContext context,
    required JobCardController controller,
    bool? canEdit,
    required jobId}) {
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
              if (controller.quotationStatus.value.isNotEmpty &&
                  controller.isQuotationExpanded.isTrue) {
                return statusBox(controller.quotationStatus.value);
              } else {
                return SizedBox();
              }
            }),
            Spacer(),
            jobId != null
                ? Row(
                    spacing: 10,
                    children: [
                      GetX<JobCardController>(builder: (controller) {
                        return controller.isQuotationExpanded.isTrue
                            ? ElevatedButton(
                                style: postButtonStyle,
                                onPressed: () {
                                  if (controller.quotationStatus.value !=
                                          'Posted' &&
                                      controller.quotationStatus.value !=
                                          'Cancelled' &&
                                      controller
                                          .quotationStatus.value.isNotEmpty) {
                                    controller.editPostForQuotation(jobId);
                                  } else if (controller.quotationStatus.value ==
                                      'Posted') {
                                    showSnackBar(
                                        'Alert', 'Quotation is Already Posted');
                                  } else if (controller.quotationStatus.value ==
                                      'Cancelled') {
                                    showSnackBar(
                                        'Alert', 'Quotation is Cancelled');
                                  } else if (controller
                                      .quotationStatus.value.isEmpty) {
                                    showSnackBar('Alert',
                                        'Please Save The Quotation First');
                                  }
                                },
                                child: Text('Post',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                            : SizedBox();
                      }),
                      GetX<JobCardController>(builder: (controller) {
                        return controller.isQuotationExpanded.isTrue
                            ? ElevatedButton(
                                style: cancelJobButtonStyle,
                                onPressed: () {
                                  if (controller.quotationStatus.value !=
                                          'Cancelled' &&
                                      controller
                                          .quotationStatus.value.isNotEmpty) {
                                    controller.editCancelForQuotation(jobId);
                                  } else if (controller.quotationStatus.value ==
                                      'Cancelled') {
                                    showSnackBar(
                                        'Alert', 'Quotation Already Cancelled');
                                  } else if (controller
                                      .quotationStatus.value.isEmpty) {
                                    showSnackBar('Alert',
                                        'Please Save The Quotation First');
                                  }
                                },
                                child: Text('Cancel',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                            : SizedBox();
                      }),
                    ],
                  )
                : SizedBox(),
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
            // GetX<JobCardController>(builder: (controller) {
            //   if (controller.jobStatus1.value.isNotEmpty &&
            //       controller.isJobCardExpanded.isTrue) {
            //     return statusBox(controller.jobStatus1.value);
            //   } else {
            //     return SizedBox();
            //   }
            // }),
            // SizedBox(width: 10),
            GetX<JobCardController>(builder: (controller) {
              if (controller.jobStatus2.value.isNotEmpty &&
                  controller.isJobCardExpanded.isTrue) {
                return statusBox(controller.jobStatus2.value);
              } else {
                return SizedBox();
              }
            }),
            Spacer(),
            jobId != null
                ? Row(
                    spacing: 10,
                    children: [
                      GetX<JobCardController>(builder: (controller) {
                        return controller.isJobCardExpanded.isTrue
                            ? ElevatedButton(
                                style: new2ButtonStyle,
                                onPressed: () {
                                  if (controller.jobStatus1.value == 'New' &&
                                      controller.jobStatus2.value != 'New') {
                                    controller.editNewForJobCard(jobId, 'New');
                                  } else if (controller.jobStatus2.value ==
                                      'New') {
                                    showSnackBar('Alert', 'Job is Already New');
                                  } else if (controller.jobStatus1.value ==
                                      'Cancelled') {
                                    showSnackBar('Alert', 'Job is Cancelled');
                                  } else if (controller.jobStatus1.value ==
                                      'Posted') {
                                    showSnackBar('Alert', 'Job is Posted');
                                  } else if (controller
                                      .jobStatus1.value.isEmpty) {
                                    showSnackBar(
                                        'Alert', 'Please Save The Job First');
                                  }
                                },
                                child: Text('New',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                            : SizedBox();
                      }),
                      GetX<JobCardController>(builder: (controller) {
                        return controller.isJobCardExpanded.isTrue
                            ? ElevatedButton(
                                style: approveButtonStyle,
                                onPressed: () {
                                  if (controller.jobStatus1.value == 'New' &&
                                      controller.jobStatus2.value !=
                                          'Approved') {
                                    controller.editApproveForJobCard(
                                        jobId, 'Approved');
                                  } else if (controller.jobStatus2.value ==
                                      'Approved') {
                                    showSnackBar(
                                        'Alert', 'Job is Already Approved');
                                  } else if (controller.jobStatus1.value ==
                                      'Posted') {
                                    showSnackBar('Alert', 'Job is Posted');
                                  } else if (controller.jobStatus1.value ==
                                      'Cancelled') {
                                    showSnackBar('Alert', 'Job is Cancelled');
                                  } else if (controller
                                      .jobStatus1.value.isEmpty) {
                                    showSnackBar(
                                        'Alert', 'Please Save The Job First');
                                  }
                                },
                                child: Text('Approve',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                            : SizedBox();
                      }),
                      GetX<JobCardController>(builder: (controller) {
                        return controller.isJobCardExpanded.isTrue
                            ? ElevatedButton(
                                style: readyButtonStyle,
                                onPressed: () {
                                  if (controller.jobStatus1.value == 'New' &&
                                      controller.jobStatus2.value != 'Ready') {
                                    controller.editReadyForJobCard(
                                        jobId, 'Ready');
                                  } else if (controller.jobStatus2.value ==
                                      'Ready') {
                                    showSnackBar(
                                        'Alert', 'Job is Already Ready');
                                  } else if (controller.jobStatus1.value ==
                                      'Posted') {
                                    showSnackBar('Alert', 'Job is Posted');
                                  } else if (controller.jobStatus1.value ==
                                      'Cancelled') {
                                    showSnackBar('Alert', 'Job is Cancelled');
                                  } else if (controller
                                      .jobStatus1.value.isEmpty) {
                                    showSnackBar(
                                        'Alert', 'Please Save The Job First');
                                  }
                                },
                                child: Text('Ready',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                            : SizedBox();
                      }),
                      GetX<JobCardController>(builder: (controllerr) {
                        return controller.isJobCardExpanded.isTrue
                            ? ElevatedButton(
                                style: postButtonStyle,
                                onPressed: () {
                                  if (controller.jobStatus1.value == 'Posted') {
                                    showSnackBar(
                                        'Alert', 'Job is Already Posted');
                                  } else if (controller.jobStatus1.value ==
                                      'Cancelled') {
                                    showSnackBar('Alert', 'Job is Cancelled');
                                  } else if (controller.jobWarrentyEndDate.value
                                          .text.isEmpty && controller.jobStatus1.value.isNotEmpty &&
                                      controller.jobStatus1.value !=
                                          'Cancelled' &&
                                      controller.jobStatus1.value != 'Posted') {
                                    showSnackBar('Alert',
                                        'You Must Enter Warranty End Date First');
                                  } else if (controller
                                      .jobStatus1.value.isEmpty) {
                                    showSnackBar(
                                        'Alert', 'Please Save The Job First');
                                  } else {
                                    controllerr.editPostForJobCard(jobId);
                                  }
                                },
                                child: controllerr.postingJob.isFalse
                                    ? Text('Post',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                    : SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ))
                            : SizedBox();
                      }),
                      GetX<JobCardController>(builder: (controller) {
                        return controller.isJobCardExpanded.isTrue
                            ? ElevatedButton(
                                style: cancelJobButtonStyle,
                                onPressed: () {
                                  if (controller.jobStatus1.value ==
                                      'Cancelled') {
                                    showSnackBar(
                                        'Alert', 'Job is Already Cancelled');
                                  } else if (controller.jobStatus1.value ==
                                      'Posted') {
                                    showSnackBar('Alert', 'Job is Cancelled');
                                  } else if (controller.jobStatus1.value !=
                                          'Cancelled' &&
                                      controller.jobStatus2.value !=
                                          'Cancelled' &&
                                      controller.jobStatus1.value != '') {
                                    controller.editCancelForJobCard(
                                        jobId, 'Cancelled');
                                  } else if (controller
                                      .jobStatus1.value.isEmpty) {
                                    showSnackBar(
                                        'Alert', 'Please Save The Job First');
                                  }
                                },
                                child: Text('Cancel',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                            : SizedBox();
                      }),
                    ],
                  )
                : SizedBox(),
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
                            : status == 'Closed' || status == 'Warranty'
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
