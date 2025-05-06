import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/job_card.dart';
import '../../../consts.dart';
import '../../Mobile widgets/inspection report widgets/inspection_report_body.dart';
import '../../text_button.dart';
import 'internal_notes_widget.dart';

ElevatedButton deleteJobButton(
    JobCardController controller, BuildContext context, jobId) {
  return ElevatedButton(
      style: cancelJobButtonStyle,
      onPressed: () {
        if (controller.jobStatus1.value == 'New' ||
            controller.jobStatus1.value == '') {
          alertDialog(
              context: context,
              controller: controller,
              content: "Theis will be deleted permanently",
              onPressed: () {
                controller.deleteJobCard(jobId);
              });
        } else {
          showSnackBar('Can Not Delete', 'Only New Cards Can be Deleted');
        }
      },
      child: Text(
        'Delete',
        style: fontStyleForElevatedButtons,
      ));
}

// GetX<JobCardController> changeStatusToCanceledButton(jobId) {
//   return GetX<JobCardController>(builder: (controller) {
//     return ElevatedButton(
//         style: cancelJobButtonStyle,
//         onPressed: () {
//           if (controller.jobStatus1.value == 'Cancelled') {
//             showSnackBar('Alert', 'Job is Already Cancelled');
//           } else if (controller.jobStatus1.value == 'Posted') {
//             showSnackBar('Alert', 'Job is Cancelled');
//           } else if (controller.jobStatus1.value != 'Cancelled' &&
//               controller.jobStatus2.value != 'Cancelled' &&
//               controller.jobStatus1.value != '') {
//             controller.editCancelForJobCard(jobId, 'Cancelled');
//           } else if (controller.jobStatus1.value.isEmpty) {
//             showSnackBar('Alert', 'Please Save The Job First');
//           }
//         },
//         child: controller.cancellingJob.isFalse
//             ? Text('Cancel', style: fontStyleForElevatedButtons)
//             : loadingProcess);
//   });
// }

GetBuilder<JobCardController> changeStatusToCanceledButton(jobId) {
  return GetBuilder<JobCardController>(builder: (controller) {
    return ClickableHoverText(
        color1: Colors.red,
        color2: Colors.white,
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

// GetX<JobCardController> changeStatusToPostedButton(
//     JobCardController controller, jobId) {
//   return GetX<JobCardController>(builder: (controllerr) {
//     return ElevatedButton(
//         style: postButtonStyle,
//         onPressed: () {
//           if (controller.jobStatus1.value == 'Posted') {
//             showSnackBar('Alert', 'Job is Already Posted');
//           } else if (controller.jobStatus1.value == 'Cancelled') {
//             showSnackBar('Alert', 'Job is Cancelled');
//           } else if (controller.jobWarrentyEndDate.value.text.isEmpty &&
//               controller.jobStatus1.value.isNotEmpty &&
//               controller.jobStatus1.value != 'Cancelled' &&
//               controller.jobStatus1.value != 'Posted') {
//             showSnackBar('Alert', 'You Must Enter Warranty End Date First');
//           } else if (controller.jobStatus1.value.isEmpty) {
//             showSnackBar('Alert', 'Please Save The Job First');
//           } else {
//             controllerr.editPostForJobCard(jobId);
//           }
//         },
//         child: controllerr.postingJob.isFalse
//             ? Text('Post', style: fontStyleForElevatedButtons)
//             : loadingProcess);
//   });
// }

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

GetX<JobCardController> changeStatusToReadyButton(jobId) {
  return GetX<JobCardController>(builder: (controller) {
    return ElevatedButton(
        style: readyButtonStyle,
        onPressed: () {
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
        child: controller.readingJob.isFalse
            ? Text('Ready', style: fontStyleForElevatedButtons)
            : loadingProcess);
  });
}

GetX<JobCardController> changeStatusToApproveButton(String jobId) {
  return GetX<JobCardController>(builder: (controller) {
    return ElevatedButton(
        style: approveButtonStyle,
        onPressed: () {
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
        child: controller.approvingJob.isFalse
            ? Text('Approve', style: fontStyleForElevatedButtons)
            : loadingProcess);
  });
}

GetX<JobCardController> changeStatusToNewButton(jobId) {
  return GetX<JobCardController>(builder: (controller) {
    return ElevatedButton(
        style: new2ButtonStyle,
        onPressed: () {
          if (controller.jobStatus1.value == 'New' &&
              controller.jobStatus2.value != 'New') {
            controller.editNewForJobCard(jobId, 'New');
          } else if (controller.jobStatus2.value == 'New') {
            showSnackBar('Alert', 'Job is Already New');
          } else if (controller.jobStatus1.value == 'Cancelled') {
            showSnackBar('Alert', 'Job is Cancelled');
          } else if (controller.jobStatus1.value == 'Posted') {
            showSnackBar('Alert', 'Job is Posted');
          } else if (controller.jobStatus1.value.isEmpty) {
            showSnackBar('Alert', 'Please Save The Job First');
          }
        },
        child: controller.newingJob.isFalse
            ? Text('New', style: fontStyleForElevatedButtons)
            : loadingProcess);
  });
}

GetX<JobCardController> saveJobButton(void Function() onSave) {
  return GetX<JobCardController>(builder: (controller) {
    return ElevatedButton(
        style: new2ButtonStyle,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                onSave();
              },
        child: controller.addingNewValue.value == false
            ? Text(
                'Save',
                style: fontStyleForElevatedButtons,
              )
            : loadingProcess);
  });
}

ElevatedButton internalNotesButton(
    JobCardController controller, BoxConstraints constraints, String jobId) {
  return ElevatedButton(
    style: internalNotesButtonStyle,
    onPressed: () async {
      if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
        controller.noteMessage.value = '';
        controller.internalNote.value.clear();
        internalNotesDialog(controller, constraints, jobId);
      } else {
        showSnackBar('Alert', 'Please Save Job First');
      }
    },
    child: Text(
      'Internal Notes',
      style: fontStyleForElevatedButtons,
    ),
  );
}

ElevatedButton inspectionFormButton(JobCardController controller, jobId,
    Map<String, dynamic> jobData, BuildContext context) {
  return ElevatedButton(
      style: inspectionFormButtonStyle,
      onPressed: () {
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
      child: Text('Inspection Form', style: fontStyleForElevatedButtons));
}

GetX<JobCardController> copyJobButton(jobId) {
  return GetX<JobCardController>(builder: (controller) {
    return ElevatedButton(
        style: copyJobButtonStyle,
        onPressed: () async {
          var newData = await controller.copyJob(jobId);
          Get.back();
          await controller.loadValues(newData['data']);
          await controller.getAllInvoiceItems(newData['newId']);
          controller.loadingCopyJob.value = false;

          editJobCardDialog(controller, newData['data'], newData['newId']);
        },
        child: controller.loadingCopyJob.isFalse
            ? Text(
                'Copy',
                style: fontStyleForElevatedButtons,
              )
            : const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ));
  });
}

GetX<JobCardController> creatQuotationButton(JobCardController controller) {
  return GetX<JobCardController>(builder: (context) {
    return ElevatedButton(
        style: creatJobOrQuotationButtonStyle,
        onPressed: () {
          if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
            controller.createQuotationCard();
          } else {
            showSnackBar('Alert', 'Please Save Job First');
          }
        },
        child: controller.creatingNewQuotation.isFalse
            ? Text(
                'Create Quotation',
                style: fontStyleForElevatedButtons,
              )
            : loadingProcess);
  });
}
