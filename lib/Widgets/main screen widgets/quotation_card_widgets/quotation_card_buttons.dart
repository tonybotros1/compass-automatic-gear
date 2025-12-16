import 'package:datahubai/Models/quotation%20cards/quotation_cards_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'internal_notes_widget.dart';

Widget deleteButton(
  QuotationCardController controller,
  BuildContext context,
  quotationId,
) {
  return ClickableHoverText(
    onTap: () {
      if (controller.quotationStatus.value == 'New' ||
          controller.quotationStatus.value == '') {
        alertDialog(
          context: context,
          content: "This will be deleted permanently",
          onPressed: () {
            controller.deleteQuotationCard(quotationId);
          },
        );
      } else {
        showSnackBar('Can Not Delete', 'Only New Cards Can be Deleted');
      }
    },
    text: 'Delete',
  );
}

GetBuilder<QuotationCardController> changeStatusToCanceledButton(
  String quotationId,
) {
  return GetBuilder<QuotationCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: () {
          controller.editCancelForQuotation(quotationId);
        },
        text: 'Cancel',
      );
    },
  );
}

GetBuilder<QuotationCardController> changeStatusToPostedButton(
  String quotationId,
) {
  return GetBuilder<QuotationCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: () {
          controller.editPostForQuotation(quotationId);
        },
        text: 'Post',
      );
    },
  );
}

GetX<QuotationCardController> saveQuotationButton(
  void Function() onSave,
) {
  return GetX<QuotationCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: controller.addingNewValue.value
            ? null
            : () async {
                onSave();
              },
        text: controller.addingNewValue.isFalse ? 'Save' : '•••',
      );
    },
  );
}

GetBuilder<QuotationCardController> copyQuotationButton(String quotationId) {
  return GetBuilder<QuotationCardController>(
    builder: (controller) {
      return ClickableHoverText(
        onTap: controller.loadingCopyQuotation.isFalse
            ? () async {
                QuotationCardsModel newData = await controller.copyQuotation(
                  quotationId,
                );
                await controller.loadValues(newData);
                controller.loadingCopyQuotation.value = false;
                editQuotationCardDialog(controller, newData, newData.id ?? '');
                showSnackBar('Done', 'Quotation Copied');
              }
            : null,
        text: 'Copy',
      );
    },
  );
}

Widget internalNotesButton(
  QuotationCardController controller,
  BoxConstraints constraints,
  quotationId,
) {
  return ClickableHoverText(
    onTap: () async {
      if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
        controller.noteMessage.value = '';
        controller.internalNote.value.clear();
        controller.getQuotationCardInternalNotes(quotationId);
        internalNotesDialog(controller, constraints, quotationId);
      } else {
        showSnackBar('Alert', 'Please Save Quotation First');
      }
    },
    text: 'Internal Notes',
  );
}

GetBuilder<QuotationCardController> creatJobButton(String quotationID) {
  return GetBuilder<QuotationCardController>(
    builder: (controller) {
      return ClickableHoverText(
        // style: creatJobOrQuotationButtonStyle,
        onTap: controller.creatingNewJob.isFalse
            ? () async {
                if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
                  controller.createNewJobCard(quotationID);
                } else {
                  showSnackBar('Alert', 'Please Save Quotation First');
                }
              }
            : null,
        text: 'Create Job',
      );
    },
  );
}
