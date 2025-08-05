import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';

Widget addNewReceiveOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ReceivingController controller,
  bool? canEdit,
  required jobId,
}) {
  return ListView(
    children: [
      Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                labelContainer(lable: Text('Car Details', style: fontStyle1)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                labelContainer(
                  lable: Text('Customer Details', style: fontStyle1),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                labelContainer(
                  lable: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Job Details', style: fontStyle1)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // labelContainer(
      //   lable: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text('Invoice Items', style: fontStyle1),
      //       newinvoiceItemsButton(context, constraints, controller, jobId),
      //     ],
      //   ),
      // ),
      // SizedBox(
      //   height: 250,
      //   child: invoiceItemsSection(
      //     constraints: constraints,
      //     context: context,
      //     jobId: jobId,
      //   ),
      // ),
    ],
  );
}
