import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container quotationsSection(BuildContext context, QuotationCardController controller) {
  return Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      child: Column(spacing: 10, children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: controller.quotationCounter.value,
              labelText: 'Quotation No.',
              hintText: 'Enter Quotation No.',
            )),
            Expanded(
                flex: 2,
                child: myTextFormFieldWithBorder(
                  isDate: true,
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await controller.selectDateContext(
                            context, controller.quotationDate.value);
                        controller.changeQuotationEndDateDependingOnDays();
                      },
                      icon: const Icon(Icons.date_range)),
                  controller: controller.quotationDate.value,
                  labelText: 'Quotation Date',
                  hintText: 'Enter Quotation Date',
                )),
            const Expanded(flex: 2, child: SizedBox())
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
              isDate: true,
              onChanged: (value) {
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
              hintText: '(days)',
            )),
            Expanded(
                flex: 2,
                child: myTextFormFieldWithBorder(
                  isDate: true,
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await controller.selectDateContext(
                            context, controller.validityEndDate.value);
                        controller.changingDaysDependingOnQuotationEndDate();
                      },
                      icon: const Icon(Icons.date_range)),
                  controller: controller.validityEndDate.value,
                  labelText: 'Expiry Date',
                  hintText: 'Enter Expiry Date',
                )),
            const Expanded(flex: 2, child: SizedBox())
          ],
        ),
        Row(
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
              controller: controller.referenceNumber.value,
              labelText: 'Reference No.',
              hintText: 'Enter Reference No.',
            )),
            const Expanded(flex: 2, child: SizedBox())
          ],
        ),
        Row(
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
              controller: controller.deliveryTime.value,
              labelText: 'Delivery Time',
              hintText: 'Enter Delivery Time',
            )),
            const Expanded(flex: 2, child: SizedBox())
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
              isnumber: true,
              controller: controller.quotationWarrentyDays.value,
              labelText: 'Warrenty Days',
              hintText: 'Enter Warrenty Days',
            )),
            Expanded(
                child: myTextFormFieldWithBorder(
              isnumber: true,
              controller: controller.quotationWarrentyKM.value,
              labelText: 'Warrenty KM',
              hintText: 'Enter Warrenty KM',
            )),
            const Expanded(flex: 2, child: SizedBox())
          ],
        ),
        myTextFormFieldWithBorder(
          labelText: 'Quotation Notes',
          hintText: 'Enter Quotation Notes',
          controller: controller.quotationNotes,
          maxLines: null,
          minLines: 7,
        ),
      ]));
}
