import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/job_card.dart';
import '../../../consts.dart';
import '../../Mobile widgets/inspection report widgets/inspection_report_body.dart';
import '../../text_button.dart';
import 'internal_notes_widget.dart';

Widget deleteJobButton(
    JobCardController controller, BuildContext context, jobId) {
  return ClickableHoverText(

      // style: cancelJobButtonStyle,
      onTap: () {
        if (controller.jobStatus1.value == 'New' ||
            controller.jobStatus1.value == '') {
          alertDialog(
              context: context,
              content: "This will be deleted permanently", 
              onPressed: () {
                controller.deleteJobCard(jobId);
              });
        } else {
          showSnackBar('Can Not Delete', 'Only New Cards Can be Deleted');
        }
      },
      text: 'Delete');
}

GetBuilder<JobCardController> changeStatusToCancelledButton(jobId) {
  return GetBuilder<JobCardController>(builder: (controller) {
    return ClickableHoverText(

        // style: cancelJobButtonStyle,
        onTap: () {
          if (controller.jobStatus1.value == 'Cancelled') {
            showSnackBar('Alert', 'Job is Already Cancelled');
          } else if (controller.jobStatus1.value == 'Posted') {
            showSnackBar('Alert', 'Job is Cancelled');
          } else if (controller.jobStatus1.value != 'Cancelled' &&
              controller.jobStatus2.value != 'Cancelled' &&
              controller.jobStatus1.value != '') {
            controller.editCancelForJobCard(jobId, 'Cancelled');
          } else if (controller.jobStatus1.value.isEmpty) {
            showSnackBar('Alert', 'Please Save The Job First');
          }
        },
        text: 'Cancel');
  });
}

GetBuilder<JobCardController> changeStatusToPostedButton(
    JobCardController controller, jobId) {
  return GetBuilder<JobCardController>(builder: (controllerr) {
    return ClickableHoverText(
        // style: postButtonStyle,
        onTap: () {
          if (controller.jobStatus1.value == 'Posted') {
            showSnackBar('Alert', 'Job is Already Posted');
          } else if (controller.jobStatus1.value == 'Cancelled') {
            showSnackBar('Alert', 'Job is Cancelled');
          } else if (controller.jobWarrentyEndDate.value.text.isEmpty &&
              controller.jobStatus1.value.isNotEmpty &&
              controller.jobStatus1.value != 'Cancelled' &&
              controller.jobStatus1.value != 'Posted') {
            showSnackBar('Alert', 'You Must Enter Warranty End Date First');
          } else if (controller.jobStatus1.value.isEmpty) {
            showSnackBar('Alert', 'Please Save The Job First');
          } else {
            controllerr.editPostForJobCard(jobId);
          }
        },
        text: 'Post');
  });
}

GetBuilder<JobCardController> changeStatusToReadyButton(jobId) {
  return GetBuilder<JobCardController>(builder: (controller) {
    return ClickableHoverText(

        // style: readyButtonStyle,
        onTap: () {
          if (controller.jobStatus1.value == 'New' &&
              controller.jobStatus2.value != 'Ready') {
            controller.editReadyForJobCard(jobId, 'Ready');
          } else if (controller.jobStatus2.value == 'Ready') {
            showSnackBar('Alert', 'Job is Already Ready');
          } else if (controller.jobStatus1.value == 'Posted') {
            showSnackBar('Alert', 'Job is Posted');
          } else if (controller.jobStatus1.value == 'Cancelled') {
            showSnackBar('Alert', 'Job is Cancelled');
          } else if (controller.jobStatus1.value.isEmpty) {
            showSnackBar('Alert', 'Please Save The Job First');
          }
        },
        text: 'Ready');
  });
}

GetBuilder<JobCardController> changeStatusToApproveButton(String jobId) {
  return GetBuilder<JobCardController>(builder: (controller) {
    return ClickableHoverText(

        // style: approveButtonStyle,
        onTap: () {
          if (controller.jobStatus1.value == 'New' &&
              controller.jobStatus2.value != 'Approved') {
            controller.editApproveForJobCard(jobId, 'Approved');
          } else if (controller.jobStatus2.value == 'Approved') {
            showSnackBar('Alert', 'Job is Already Approved');
          } else if (controller.jobStatus1.value == 'Posted') {
            showSnackBar('Alert', 'Job is Posted');
          } else if (controller.jobStatus1.value == 'Cancelled') {
            showSnackBar('Alert', 'Job is Cancelled');
          } else if (controller.jobStatus1.value.isEmpty) {
            showSnackBar('Alert', 'Please Save The Job First');
          }
        },
        text: 'Approve');
  });
}

GetBuilder<JobCardController> changeStatusToNewButton(jobId) {
  return GetBuilder<JobCardController>(builder: (controller) {
    return ClickableHoverText(

        // style: new2ButtonStyle,
        onTap: () {
          if (controller.jobStatus1.value == 'New' &&
              controller.jobStatus2.value != 'New') {
            controller.editNewForJobCard(jobId, 'New');
          } else if (controller.jobStatus2.value == 'New') {
            showSnackBar('Alert', 'Job is Already New');
          } else if (controller.jobStatus1.value == 'Cancelled') {
            // showSnackBar('Alert', 'Job is Cancelled');
            controller.editNewForJobCard(jobId, 'New');
          } else if (controller.jobStatus1.value == 'Posted') {
            showSnackBar('Alert', 'Job is Posted');
          } else if (controller.jobStatus1.value.isEmpty) {
            showSnackBar('Alert', 'Please Save The Job First');
          }
        },
        text: 'New');
  });
}

GetBuilder<JobCardController> saveJobButton(void Function() onSave) {
  return GetBuilder<JobCardController>(builder: (controller) {
    return ClickableHoverText(
        // style: new2ButtonStyle,
        onTap: controller.addingNewValue.value
            ? null
            : () {
                onSave();
              },
        text: 'Save');
  });
}

Widget internalNotesButton(
    JobCardController controller, BoxConstraints constraints, String jobId) {
  return ClickableHoverText(
      // style: internalNotesButtonStyle,
      onTap: () async {
        if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
          controller.noteMessage.value = '';
          controller.internalNote.value.clear();
          internalNotesDialog(controller, constraints, jobId);
        } else {
          showSnackBar('Alert', 'Please Save Job First');
        }
      },
      text: 'Internal Notes');
}

Widget inspectionFormButton(JobCardController controller, jobId,
    Map<String, dynamic> jobData, BuildContext context) {
  return ClickableHoverText(
      // style: inspectionFormButtonStyle,
      onTap: () {
        controller.loadInspectionFormValues(jobId, jobData);
        Get.dialog(
            barrierDismissible: false,
            Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                insetPadding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 600,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          color: mainColor,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '🚘 Inspection Form',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildInspectionReportBody(context),
                        ),
                      ),
                    ],
                  ),
                )));
      },
      text: 'Inspection Form');
}

GetBuilder<JobCardController> copyJobButton(jobId, context) {
  return GetBuilder<JobCardController>(builder: (controller) {
    return ClickableHoverText(
        // style: copyJobButtonStyle,
        onTap: () async {
          if (controller.jobStatus1.value == 'New' ||
              controller.jobStatus1.value == 'Approved' ||
              controller.jobStatus1.value == 'Ready') {
            showSnackBar('Alert', 'Only Posted / Cancelled Jobs Can be Copied');
          } else {
            Get.back();
            showSnackBar('Copying', 'Please Wait');

            var newData = await controller.copyJob(jobId);
            await controller.getAllInvoiceItems(newData['newId']);
            await controller.loadValues(newData['data']);
            controller.loadingCopyJob.value = false;
            editJobCardDialog(controller, newData['data'], newData['newId']);
            showSnackBar('Done', 'Job Copied Successfully');
            // alertMessage(
            //     context: context,
            //     content: "Job Copied Successfully",
            //     onPressed: () {
            //       Get.back();
            //       // controller.deleteJobCard(jobId);
            //     });
          }
        },
        text: 'Copy');
  });
}

GetBuilder<JobCardController> creatQuotationButton(
    JobCardController controller, String jobId) {
  return GetBuilder<JobCardController>(builder: (context) {
    return ClickableHoverText(
        // style: creatJobOrQuotationButtonStyle,
        onTap: () {
          if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
            controller.createQuotationCard(jobId);
          } else {
            showSnackBar('Alert', 'Please Save Job First');
          }
        },
        text: 'Create Quotation');
  });
}
