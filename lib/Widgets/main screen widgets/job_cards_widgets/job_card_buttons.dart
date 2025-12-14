import 'package:datahubai/Models/job%20cards/job_card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/job_card.dart';
import '../../../consts.dart';
import '../../Mobile widgets/inspection report widgets/inspection_report_body.dart';
import '../../text_button.dart';
import 'internal_notes_widget.dart';

Widget deleteJobButton(
  JobCardController controller,
  BuildContext context,
  jobId,
) {
  return ClickableHoverText(
    onTap: () {
      if (controller.jobStatus1.value == 'New' ||
          controller.jobStatus1.value == '') {
        alertDialog(
          context: context,
          content: "This will be deleted permanently",
          onPressed: () {
            controller.deleteJobCard(jobId);
          },
        );
      } else {
        showSnackBar('Can Not Delete', 'Only New Cards Can be Deleted');
      }
    },
    text: 'Delete',
  );
}

GetBuilder<JobCardController> changeStatusToCancelledButton(String jobId) {
  return GetBuilder<JobCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: () {
          controller.editCancelForJobCard(jobId, 'Cancelled');
        },
        text: 'Cancel',
      );
    },
  );
}

GetBuilder<JobCardController> changeStatusToPostedButton(
  JobCardController controller,
  String jobId,
) {
  return GetBuilder<JobCardController>(
    builder: (controllerr) {
      return ClickableHoverText(
        onTap: () {
          controller.editPostForJobCard(jobId);
        },
        text: 'Post',
      );
    },
  );
}

GetBuilder<JobCardController> changeStatusToReadyButton(String jobId) {
  return GetBuilder<JobCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: () {
          controller.editReadyForJobCard(jobId, 'Ready');
        },
        text: 'Ready',
      );
    },
  );
}

GetBuilder<JobCardController> changeStatusToApproveButton(String jobId) {
  return GetBuilder<JobCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: () {
          controller.editApproveForJobCard(jobId, 'Approved');
        },
        text: 'Approve',
      );
    },
  );
}

GetBuilder<JobCardController> changeStatusToNewButton(String jobId) {
  return GetBuilder<JobCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: () {
          controller.editNewForJobCard(jobId, 'New');
        },
        text: 'New',
      );
    },
  );
}

GetX<JobCardController> saveJobButton(void Function() onSave) {
  return GetX<JobCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: controller.addingNewValue.value
            ? null
            : () {
                onSave();
              },
        text: controller.addingNewValue.isFalse ? 'Save' : "•••",
      );
    },
  );
}

Widget internalNotesButton(
  JobCardController controller,
  BoxConstraints constraints,
  String jobId,
) {
  return ClickableHoverText(
    onTap: () async {
      if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
        controller.noteMessage.value = '';
        controller.internalNote.value.clear();
        controller.getJobCardInternalNotes(jobId);
        internalNotesDialog(controller, constraints, jobId);
      } else {
        showSnackBar('Alert', 'Please Save Job First');
      }
    },
    text: 'Internal Notes',
  );
}

Widget inspectionFormButton(
  JobCardController controller,
  String jobId,
  // JobCardModel jobData,
  BuildContext context,
) {
  return GetX<JobCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: controller.loadingIspectionReport.isFalse
            ? () async {
                await controller.loadInspectionFormValues(jobId);
                Get.dialog(
                  barrierDismissible: false,
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    insetPadding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 600,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                              color: mainColor,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '🚘 Inspection Form',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildInspectionReportBody(Get.context!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            : null,
        text: controller.loadingIspectionReport.isFalse
            ? 'Inspection Form'
            : "•••",
      );
    },
  );
}

GetBuilder<JobCardController> copyJobButton(
  String jobId,
  BuildContext context,
) {
  return GetBuilder<JobCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: controller.loadingCopyJob.isFalse
            ? () async {
                JobCardModel newData = await controller.copyJob(jobId);
                await controller.loadValues(newData);
                controller.loadingCopyJob.value = false;
                editJobCardDialog(
                  controller,
                  newData,
                  newData.id ?? '',
                  newData.isSales == true ? false : true,
                ); // need to be changed
                showSnackBar('Done', 'Job Copied Successfully');
              }
            : null,
        text: 'Copy',
      );
    },
  );
}

GetX<JobCardController> creatQuotationButton(
  JobCardController controller,
  String jobId,
) {
  return GetX<JobCardController>(
    builder: (context) {
      return ClickableHoverText(
        // style: creatJobOrQuotationButtonStyle,
        onTap: () {
          if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
            controller.createQuotationCard(jobId);
          } else {
            showSnackBar('Alert', 'Please Save Job First');
          }
        },
        text: controller.creatingNewQuotation.isFalse
            ? 'Create Quotation'
            : '•••',
      );
    },
  );
}

GetX<JobCardController> creatReceiptButton(
  JobCardController controller,
  String jobId,
) {
  return GetX<JobCardController>(
    builder: (context) {
      return ClickableHoverText(
        onTap: () {
          if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
            controller.createReceipt(jobId, controller.customerId.value);
          } else {
            showSnackBar('Alert', 'Please Save Job First');
          }
        },
        text: controller.creatingNewReceipt.isFalse ? 'Create Receipt' : '•••',
      );
    },
  );
}
