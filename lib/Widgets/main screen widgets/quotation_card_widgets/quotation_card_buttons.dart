import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'internal_notes_widget.dart';

Widget deleteButton(
    QuotationCardController controller, BuildContext context, quotationId) {
  return ClickableHoverText(
      onTap: () {
        if (controller.quotationStatus.value == 'New' ||
            controller.quotationStatus.value == '') {
          alertDialog(
              context: context,
              controller: controller,
              content: "Theis will be deleted permanently",
              onPressed: () {
                controller.deleteQuotationCard(quotationId);
              });
        } else {
          showSnackBar('Can Not Delete', 'Only New Cards Can be Deleted');
        }
      },
      text: 'Delete');
}

GetBuilder<QuotationCardController> changeStatusToCanceledButton(quotationId) {
  return GetBuilder<QuotationCardController>(builder: (controller) {
    return ClickableHoverText(
        onTap: controller.cancelingQuotation.isFalse
            ? () {
                if (controller.quotationStatus.value != 'Cancelled' &&
                    controller.quotationStatus.value.isNotEmpty) {
                  controller.editCancelForQuotation(quotationId);
                } else if (controller.quotationStatus.value == 'Cancelled') {
                  showSnackBar('Alert', 'Quotation Already Cancelled');
                } else if (controller.quotationStatus.value.isEmpty) {
                  showSnackBar('Alert', 'Please Save The Quotation First');
                }
              }
            : null,
        text: 'Cancel');
  });
}

GetBuilder<QuotationCardController> changeStatusToPostedButton(quotationId) {
  return GetBuilder<QuotationCardController>(builder: (controller) {
    return ClickableHoverText(
        onTap: controller.postingQuotation.isFalse
            ? () {
                if (controller.quotationStatus.value != 'Posted' &&
                    controller.quotationStatus.value != 'Cancelled' &&
                    controller.quotationStatus.value.isNotEmpty) {
                  controller.editPostForQuotation(quotationId);
                } else if (controller.quotationStatus.value == 'Posted') {
                  showSnackBar('Alert', 'Quotation is Already Posted');
                } else if (controller.quotationStatus.value == 'Cancelled') {
                  showSnackBar('Alert', 'Quotation is Cancelled');
                } else if (controller.quotationStatus.value.isEmpty) {
                  showSnackBar('Alert', 'Please Save The Quotation First');
                }
              }
            : null,
        text: 'Post');
  });
}

GetBuilder<QuotationCardController> saveQuotationButton(
    void Function() onSave) {
  return GetBuilder<QuotationCardController>(builder: (controller) {
    return ClickableHoverText(
      onTap: controller.addingNewValue.value
          ? null
          : () async {
              onSave();
            },
      text: 'Save',
    );
  });
}

GetBuilder<QuotationCardController> copyQuotationButton(quotationId) {
  return GetBuilder<QuotationCardController>(builder: (controller) {
    return ClickableHoverText(
        onTap: controller.loadingCopyQuotation.isFalse
            ? () async {
                if (controller.quotationStatus.value == 'New') {
                  showSnackBar('Alert',
                      'Only Posted / Cancelled Quotations Can be Copied');
                } else {

                  var newData = await controller.copyQuotation(quotationId);
                  Get.back();
                  controller.loadValues(newData['data'],quotationId);
                  editQuotationCardDialog(
                      controller, newData['data'], newData['newId']);
                  showSnackBar('Done', 'Quotation Copied');
                }
              }
            : null,
        text: 'Copy');
  });
}

Widget internalNotesButton(QuotationCardController controller,
    BoxConstraints constraints, quotationId) {
  return ClickableHoverText(
    onTap: () async {
      if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
        controller.noteMessage.value = '';
        controller.internalNote.value.clear();
        internalNotesDialog(controller, constraints, quotationId);
      } else {
        showSnackBar('Alert', 'Please Save Quotation First');
      }
    },
    text: 'Internal Notes',
  );
}

GetBuilder<QuotationCardController> creatJobButton(quotationID) {
  return GetBuilder<QuotationCardController>(builder: (controller) {
    return ClickableHoverText(
        // style: creatJobOrQuotationButtonStyle,
        onTap: controller.creatingNewJob.isFalse
            ? () async {
                if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
                  if (controller.quotationStatus.value == 'Posted') {
                    controller.createNewJobCard(quotationID);
                  } else {
                    showSnackBar(
                        'Alert', 'Only Posted Quotations Can Create Job From');
                  }
                } else {
                  showSnackBar('Alert', 'Please Save Quotation First');
                }
              }
            : null,
        text: 'Create Job');
  });
}
