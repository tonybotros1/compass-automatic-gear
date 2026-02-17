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
        alertMessage(
          context: Get.context!,
          content: 'Only New Cards Can be Deleted',
        );
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
        alertMessage(context: Get.context!, content: 'Please Save Job First');
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
                  newData.type == 'JOB' ? false : true,
                ); // need to be changed
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
            alertMessage(
              context: Get.context!,
              content: 'Please Save Job First',
            );
          }
        },
        text: controller.creatingNewQuotation.isFalse
            ? 'Create Quotation'
            : '•••',
      );
    },
  );
}

GetBuilder<JobCardController> printButton(BuildContext context) {
  return GetBuilder<JobCardController>(
    builder: (controller) {
      return PopupMenuButton<String>(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        offset: const Offset(0, 40),
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: 'print_invoice',
            child: Text('Print Invoice', style: TextStyle(fontSize: 14)),
          ),
          PopupMenuItem(
            value: 'print_invoice_with_header',
            child: Text(
              'Print Invoice With Header',
              style: TextStyle(fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 'print_delevery_note_with_price',
            child: Text(
              'Print Delevery Note With Price',
              style: TextStyle(fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 'print_delevery_note_without_price',
            child: Text(
              'Print Delevery Note Without Price',
              style: TextStyle(fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 'print_proforma_invoice',
            child: Text(
              'Print Proforma Invoice',
              style: TextStyle(fontSize: 14),
            ),
          ),
          PopupMenuItem(
            value: 'print_job_card',
            child: Text('Print Job Card', style: TextStyle(fontSize: 14)),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'print_invoice':
              controller.printInvoice(false, false);
            case 'print_invoice_with_header':
              controller.printInvoice(true, false);
            case 'print_delevery_note_with_price':
              controller.printDeleveryNote(true);
            case 'print_delevery_note_without_price':
              controller.printDeleveryNote(false);
            case 'print_proforma_invoice':
              controller.printInvoice(true, true);
            case 'print_job_card':
              controller.printJobCard();

              break;
            default:
          }
        },
        child: const ClickableHoverText(text: 'Print'),
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
            alertMessage(
              context: Get.context!,
              content: 'Please Save Job First',
            );
          }
        },
        text: controller.creatingNewReceipt.isFalse ? 'Create Receipt' : '•••',
      );
    },
  );
}
