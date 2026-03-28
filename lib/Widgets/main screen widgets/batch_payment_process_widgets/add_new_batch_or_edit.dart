import 'package:datahubai/Controllers/Main%20screen%20controllers/batch_payment_process_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'account_information_for_batch.dart';
import 'batch_information.dart';
import 'items_dialog.dart';
import 'items_section.dart';

Widget addNewBatchOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required BatchPaymentProcessController controller,
  bool? canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text(
                                'Batch Information',
                                style: fontStyle1,
                              ),
                            ),
                            batchInformation(context, constraints),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text(
                                'Account Information',
                                style: fontStyle1,
                              ),
                            ),
                            accountInformation(context, constraints),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        labelContainer(
          lable: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items', style: fontStyle1),
              newItemButton(controller),
            ],
          ),
        ),
        itemsSection(context: context, constraints: constraints),
      ],
    ),
  );
}

ElevatedButton newItemButton(BatchPaymentProcessController controller) {
  return ElevatedButton(
    onPressed: () async {
      if (controller.currentBatchId.value.isEmpty) {
        alertMessage(context: Get.context!, content: 'Save the batch first');
        return;
      }
      Map status = await controller.getBatchStatus(
        controller.currentBatchId.value,
      );
      String status1 = status['status'];
      if ((status1 == 'Posted')) {
        alertMessage(
          context: Get.context!,
          content: 'Can\'t add items to posted batches',
        );
        return;
      }

      controller.clearItemValues();
      batchItemsDialog(
        controller: controller,
        onTapForSave: () async {
          await controller.addNewItem();
        },
      );
    },
    style: new2ButtonStyle,
    child: const Text('New Item'),
  );
}
