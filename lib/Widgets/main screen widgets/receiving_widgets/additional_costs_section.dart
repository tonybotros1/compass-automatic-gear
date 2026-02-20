import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../../consts.dart';

Container additionalCostsSection(
  BuildContext context,
  ReceivingController controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            focusNode: controller.focusNode11,
            nextFocusNode: controller.focusNode12,
            previousFocusNode: controller.focusNode10,
            labelText: 'Shipping',
            controller: controller.shipping.value,
            isDouble: true,
            onChanged: (_) {
              controller.isReceivingModified.value = true;
            },
          ),
        ),
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            focusNode: controller.focusNode12,
            nextFocusNode: controller.focusNode13,
            previousFocusNode: controller.focusNode11,
            labelText: 'Handling',
            controller: controller.handling.value,
            isDouble: true,
            onChanged: (_) {
              controller.isReceivingModified.value = true;
            },
          ),
        ),
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            focusNode: controller.focusNode13,
            nextFocusNode: controller.focusNode14,
            previousFocusNode: controller.focusNode12,
            labelText: 'Other',
            controller: controller.other.value,
            isDouble: true,
            onChanged: (_) {
              controller.isReceivingModified.value = true;
            },
          ),
        ),
      ],
    ),
  );
}
