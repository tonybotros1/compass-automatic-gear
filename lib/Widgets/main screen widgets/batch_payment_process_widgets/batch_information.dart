import 'package:datahubai/Controllers/Main%20screen%20controllers/batch_payment_process_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Widget batchInformation(BuildContext context, BoxConstraints constraints) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    height: 280,
    child: GetBuilder<BatchPaymentProcessController>(
      builder: (controller) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myTextFormFieldWithBorder(
              width: 200,
              controller: controller.batchNumber,
              labelText: 'Batch Number',
              isEnabled: false,
            ),
            myTextFormFieldWithBorder(
              width: 200,
              suffixIcon: ExcludeFocus(
                child: IconButton(
                  onPressed: () {
                    selectDateContext(context, controller.batchDate);
                  },
                  icon: const Icon(Icons.date_range),
                ),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(controller.batchDate.text, controller.batchDate);
              },
              controller: controller.batchDate,
              labelText: 'Batch Date',
              isDate: true,
            ),
            myTextFormFieldWithBorder(
              width: double.infinity,
              maxLines: 4,
              controller: controller.note,
              labelText: 'Note',
            ),
          ],
        );
      },
    ),
  );
}
