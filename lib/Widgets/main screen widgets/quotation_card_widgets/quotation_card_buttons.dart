import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../../consts.dart';
import 'internal_notes_widget.dart';

ElevatedButton deleteButton(
    QuotationCardController controller, BuildContext context, quotationId) {
  return ElevatedButton(
      style: cancelJobButtonStyle,
      onPressed: () {
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
      child: Text('Delete', style: fontStyleForElevatedButtons));
}

GetX<QuotationCardController> changeStatusToCanceledButton(quotationId) {
  return GetX<QuotationCardController>(builder: (controller) {
    return ElevatedButton(
        style: cancelJobButtonStyle,
        onPressed: controller.cancelingQuotation.isFalse
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
        child: controller.cancelingQuotation.isFalse
            ? Text('Cancel', style: fontStyleForElevatedButtons)
            : loadingProcess);
  });
}

GetX<QuotationCardController> changeStatusToPostedButton(quotationId) {
  return GetX<QuotationCardController>(builder: (controller) {
    return ElevatedButton(
        style: postButtonStyle,
        onPressed: controller.postingQuotation.isFalse
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
        child: controller.postingQuotation.isFalse
            ? Text('Post', style: fontStyleForElevatedButtons)
            : loadingProcess);
  });
}

GetX<QuotationCardController> saveQuotationButton(void Function() onSave) {
  return GetX<QuotationCardController>(builder: (controller) {
    return ElevatedButton(
      onPressed: controller.addingNewValue.value
          ? null
          : () async {
              onSave();
            },
      style: new2ButtonStyle,
      child: controller.addingNewValue.value == false
          ? Text(
              'Save',
              style: fontStyleForElevatedButtons,
            )
          : loadingProcess,
    );
  });
}

GetX<QuotationCardController> copyQuotationButton(quotationId) {
  return GetX<QuotationCardController>(builder: (controller) {
    return ElevatedButton(
        style: copyJobButtonStyle,
        onPressed: controller.loadingCopyQuotation.isFalse
            ? () async {
                var newData = await controller.copyQuotation(quotationId);
                Get.back();
                controller.loadValues(newData['data']);
                editQuotationCardDialog(
                    controller, newData['data'], newData['newId']);
              }
            : null,
        child: controller.loadingCopyQuotation.isFalse
            ? Text(
                'Copy',
                style: fontStyleForElevatedButtons,
              )
            : loadingProcess);
  });
}

ElevatedButton internalNotesButton(QuotationCardController controller,
    BoxConstraints constraints, quotationId) {
  return ElevatedButton(
    style: internalNotesButtonStyle,
    onPressed: () async {
      if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
        controller.noteMessage.value = '';
        controller.internalNote.value.clear();
        internalNotesDialog(controller, constraints, quotationId);
      } else {
        showSnackBar('Alert', 'Please Save Quotation First');
      }
    },
    child: Text(
      'Internal Notes',
      style: fontStyleForElevatedButtons,
    ),
  );
}

GetX<QuotationCardController> creatJobButton() {
  return GetX<QuotationCardController>(builder: (controller) {
    return ElevatedButton(
        style: creatJobOrQuotationButtonStyle,
        onPressed: controller.creatingNewJob.isFalse
            ? () async {
                if (controller.canAddInternalNotesAndInvoiceItems.isFalse) {
                  controller.createNewJobCard();
                } else {
                  showSnackBar('Alert', 'Please Save Quotation First');
                }
              }
            : null,
        child: controller.creatingNewJob.isFalse
            ? Text(
                'Create Job',
                style: fontStyleForElevatedButtons,
              )
            : loadingProcess);
  });
}
