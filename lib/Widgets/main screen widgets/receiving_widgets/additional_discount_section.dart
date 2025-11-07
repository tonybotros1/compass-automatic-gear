import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container additionalDiscountSection(
  BuildContext context,
  ReceivingController controller,
) {
  return Container(
    height: 155,
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
            labelText: 'Amount',
            controller: controller.amount.value,
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
