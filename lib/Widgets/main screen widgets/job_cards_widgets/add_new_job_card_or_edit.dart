import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/job_cards_widgets/invoice_items_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    lable: Row(
                  children: [
                    Text(
                      'Job Details',
                      style: fontStyle1,
                    ),
                   
                   
                    const Spacer(),
                    // jobId != null
                    //     ? Row(
                    //         spacing: 10,
                    //         children: [
                    //           GetX<JobCardController>(builder: (controller) {
                    //             return ElevatedButton(
                    //                 style: new2ButtonStyle,
                    //                 onPressed: () {
                    //                   if (controller.jobStatus1.value ==
                    //                           'New' &&
                    //                       controller.jobStatus2.value !=
                    //                           'New') {
                    //                     controller.editNewForJobCard(
                    //                         jobId, 'New');
                    //                   } else if (controller.jobStatus2.value ==
                    //                       'New') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Already New');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Cancelled') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Cancelled');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Posted') {
                    //                     showSnackBar('Alert', 'Job is Posted');
                    //                   } else if (controller
                    //                       .jobStatus1.value.isEmpty) {
                    //                     showSnackBar('Alert',
                    //                         'Please Save The Job First');
                    //                   }
                    //                 },
                    //                 child: const Text('New',
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold)));
                    //           }),
                    //           GetX<JobCardController>(builder: (controller) {
                    //             return ElevatedButton(
                    //                 style: approveButtonStyle,
                    //                 onPressed: () {
                    //                   if (controller.jobStatus1.value ==
                    //                           'New' &&
                    //                       controller.jobStatus2.value !=
                    //                           'Approved') {
                    //                     controller.editApproveForJobCard(
                    //                         jobId, 'Approved');
                    //                   } else if (controller.jobStatus2.value ==
                    //                       'Approved') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Already Approved');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Posted') {
                    //                     showSnackBar('Alert', 'Job is Posted');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Cancelled') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Cancelled');
                    //                   } else if (controller
                    //                       .jobStatus1.value.isEmpty) {
                    //                     showSnackBar('Alert',
                    //                         'Please Save The Job First');
                    //                   }
                    //                 },
                    //                 child: const Text('Approve',
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold)));
                    //           }),
                    //           GetX<JobCardController>(builder: (controller) {
                    //             return ElevatedButton(
                    //                 style: readyButtonStyle,
                    //                 onPressed: () {
                    //                   if (controller.jobStatus1.value ==
                    //                           'New' &&
                    //                       controller.jobStatus2.value !=
                    //                           'Ready') {
                    //                     controller.editReadyForJobCard(
                    //                         jobId, 'Ready');
                    //                   } else if (controller.jobStatus2.value ==
                    //                       'Ready') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Already Ready');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Posted') {
                    //                     showSnackBar('Alert', 'Job is Posted');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Cancelled') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Cancelled');
                    //                   } else if (controller
                    //                       .jobStatus1.value.isEmpty) {
                    //                     showSnackBar('Alert',
                    //                         'Please Save The Job First');
                    //                   }
                    //                 },
                    //                 child: const Text('Ready',
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold)));
                    //           }),
                    //           GetX<JobCardController>(builder: (controllerr) {
                    //             return ElevatedButton(
                    //                 style: postButtonStyle,
                    //                 onPressed: () {
                    //                   if (controller.jobStatus1.value ==
                    //                       'Posted') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Already Posted');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Cancelled') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Cancelled');
                    //                   } else if (controller.jobWarrentyEndDate
                    //                           .value.text.isEmpty &&
                    //                       controller
                    //                           .jobStatus1.value.isNotEmpty &&
                    //                       controller.jobStatus1.value !=
                    //                           'Cancelled' &&
                    //                       controller.jobStatus1.value !=
                    //                           'Posted') {
                    //                     showSnackBar('Alert',
                    //                         'You Must Enter Warranty End Date First');
                    //                   } else if (controller
                    //                       .jobStatus1.value.isEmpty) {
                    //                     showSnackBar('Alert',
                    //                         'Please Save The Job First');
                    //                   } else {
                    //                     controllerr.editPostForJobCard(jobId);
                    //                   }
                    //                 },
                    //                 child: controllerr.postingJob.isFalse
                    //                     ? const Text('Post',
                    //                         style: TextStyle(
                    //                             fontWeight: FontWeight.bold))
                    //                     : const SizedBox(
                    //                         height: 20,
                    //                         width: 20,
                    //                         child: CircularProgressIndicator(
                    //                           strokeWidth: 2,
                    //                         ),
                    //                       ));
                    //           }),
                    //           GetX<JobCardController>(builder: (controller) {
                    //             return ElevatedButton(
                    //                 style: cancelJobButtonStyle,
                    //                 onPressed: () {
                    //                   if (controller.jobStatus1.value ==
                    //                       'Cancelled') {
                    //                     showSnackBar('Alert',
                    //                         'Job is Already Cancelled');
                    //                   } else if (controller.jobStatus1.value ==
                    //                       'Posted') {
                    //                     showSnackBar(
                    //                         'Alert', 'Job is Cancelled');
                    //                   } else if (controller.jobStatus1.value !=
                    //                           'Cancelled' &&
                    //                       controller.jobStatus2.value !=
                    //                           'Cancelled' &&
                    //                       controller.jobStatus1.value != '') {
                    //                     controller.editCancelForJobCard(
                    //                         jobId, 'Cancelled');
                    //                   } else if (controller
                    //                       .jobStatus1.value.isEmpty) {
                    //                     showSnackBar('Alert',
                    //                         'Please Save The Job First');
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
            constraints: constraints,
            context: context,
            jobId: jobId),
      )
    ],
  );
}
