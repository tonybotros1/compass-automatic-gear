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
            labelText: 'Shipping',
            controller: controller.shipping.value,
            isDouble: true,
          ),
        ),
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            labelText: 'Handling',
            controller: controller.handling.value,
            isDouble: true,
          ),
        ),
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            labelText: 'Other',
            controller: controller.other.value,
            isDouble: true,
          ),
        ),
      ],
    ),
  );
}
