import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Widget quotationsSection(
  BuildContext context,
  QuotationCardController controller,
  BoxConstraints constraints,
) {
  return Scrollbar(
    thumbVisibility: true,
    controller: controller.scrollerForQuotationSection,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: controller.scrollerForQuotationSection,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  width: 150,
                  isEnabled: false,
                  controller: controller.quotationCounter.value,
                  labelText: 'Quotation No.',
                ),
                myTextFormFieldWithBorder(
                  focusNode: controller.focusNodeForQuotationDetails1,
                  width: 150,
                  isDate: true,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await controller.selectDateContext(
                        context,
                        controller.quotationDate.value,
                      );
                      controller.changeQuotationEndDateDependingOnDays();
                      controller.isQuotationModified.value = true;
                    },
                    icon: const Icon(Icons.date_range),
                  ),
                  controller: controller.quotationDate.value,
                  labelText: 'Quotation Date',
                  onChanged: (_) {
                    controller.isQuotationModified.value = true;
                  },
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  width: 150,
                  isDate: true,
                  onChanged: (value) {
                    controller.isQuotationModified.value = true;

                    if (controller.quotationDays.value.text.isEmpty) {
                      controller.validityEndDate.value.clear();
                    } else {
                      if (int.parse(value) < 3000) {
                        controller.changeQuotationEndDateDependingOnDays();
                      }
                    }
                  },
                  isnumber: true,
                  controller: controller.quotationDays.value,
                  labelText: 'Validity',
                ),
                myTextFormFieldWithBorder(
                  width: 150,
                  isDate: true,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await controller.selectDateContext(
                        context,
                        controller.validityEndDate.value,
                      );
                      controller.changingDaysDependingOnQuotationEndDate();
                      controller.isQuotationModified.value = true;
                    },
                    icon: const Icon(Icons.date_range),
                  ),
                  controller: controller.validityEndDate.value,
                  labelText: 'Expiry Date',
                  onChanged: (_) {
                    controller.isQuotationModified.value = true;
                  },
                ),
              ],
            ),
            myTextFormFieldWithBorder(
              width: 150,
              controller: controller.referenceNumber.value,
              labelText: 'Reference No.',
              onChanged: (_) {
                controller.isQuotationModified.value = true;
              },
            ),
            myTextFormFieldWithBorder(
              width: 150,
              controller: controller.deliveryTime.value,
              labelText: 'Delivery Time',
              onChanged: (_) {
                controller.isQuotationModified.value = true;
              },
            ),
            Row(
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  width: 150,
                  isnumber: true,
                  controller: controller.quotationWarrentyDays.value,
                  labelText: 'Warrenty Days',
                  onChanged: (_) {
                    controller.isQuotationModified.value = true;
                  },
                ),
                myTextFormFieldWithBorder(
                  width: 150,
                  isnumber: true,
                  controller: controller.quotationWarrentyKM.value,
                  labelText: 'Warrenty KM',
                  onChanged: (_) {
                    controller.isQuotationModified.value = true;
                  },
                ),
              ],
            ),
            myTextFormFieldWithBorder(
              width: constraints.maxWidth / 3.35,
              labelText: 'Quotation Notes',
              controller: controller.quotationNotes,
              maxLines: null,
              minLines: 7,
              onChanged: (_) {
                controller.isQuotationModified.value = true;
              },
            ),
          ],
        ),
      ),
    ),
  );
}
