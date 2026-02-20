import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_receipts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Widget receiptHeader(BuildContext context, BoxConstraints constraints) {
  return FocusTraversalGroup(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      child: GetX<CashManagementReceiptsController>(
        builder: (controller) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    myTextFormFieldWithBorder(
                      width: 150,
                      isEnabled: false,
                      controller: controller.receiptCounter.value,
                      labelText: 'Receipt Number',
                    ),
                    myTextFormFieldWithBorder(
                      focusNode: controller.focusNodeForReceiptHeader1,
                      nextFocusNode: controller.focusNodeForReceiptHeader2,
                      width: 150,
                      controller: controller.receiptDate.value,
                      suffixIcon: ExcludeFocus(
                        child: IconButton(
                          onPressed: () {
                            controller.isReceiptModified.value = true;
                            controller.selectDateContext(
                              context,
                              controller.receiptDate.value,
                            );
                          },
                          icon: const Icon(Icons.date_range),
                        ),
                      ),
                      isDate: true,
                      labelText: 'Receipt Date',
                      onFieldSubmitted: (_) async {
                        controller.isReceiptModified.value = true;
                        normalizeDate(
                          controller.receiptDate.value.text,
                          controller.receiptDate.value,
                        );
                      },
                      onChanged: (_) {
                        controller.isReceiptModified.value = true;
                      },
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    MenuWithValues(
                      focusNode: controller.focusNodeForReceiptHeader2,
                      nextFocusNode: controller.focusNodeForReceiptHeader3,
                      labelText: 'Customer Name',
                      headerLqabel: 'Customers',
                      dialogWidth: constraints.maxWidth / 2,
                      width: constraints.maxWidth / 2.75,
                      controller: controller.customerName,
                      displayKeys: const ['entity_name'],
                      displaySelectedKeys: const ['entity_name'],
                      onOpen: () {
                        return controller.getAllCustomers();
                      },
                      onDelete: () {
                        controller.customerName.clear();
                        controller.customerNameId.value = '';
                        controller.availableReceipts.clear();
                        controller.selectedAvailableReceipts.clear();
                        controller.outstanding.clear();
                        controller.isReceiptModified.value = true;
                      },
                      onSelected: (value) async {
                        controller.isReceiptModified.value = true;
                        controller.customerName.text = value['entity_name'];
                        controller.customerNameId.value = value['_id'];
                        controller.availableReceipts.clear();
                        controller.selectedAvailableReceipts.clear();
                        // controller.outstanding.value = formatter
                        //     .formatEditUpdate(
                        //       controller.outstanding.value,
                        //       TextEditingValue(
                        //         text: await controller
                        //             .calculateCustomerOutstanding(value['_id'])
                        //             .then((value) {
                        //               return value.toString();
                        //             }),
                        //       ),
                        //     );
                        final outstandingAmount = await controller
                            .calculateCustomerOutstanding(value['_id']);
                        controller.outstanding.text = outstandingAmount
                            .toStringAsFixed(2);
                      },
                    ),
                    myTextFormFieldWithBorder(
                      width: 150,
                      moneyFormat: true,
                      labelText: 'Outstanding',
                      controller: controller.outstanding,
                      isEnabled: false,
                    ),
                  ],
                ),
                myTextFormFieldWithBorder(
                  focusNode: controller.focusNodeForReceiptHeader3,
                  nextFocusNode: controller.focusNodeForAccountInfos1,
                  width: constraints.maxWidth / 2.75,
                  controller: controller.note,
                  labelText: 'Notes',
                  maxLines: 4,
                  onChanged: (_) {
                    controller.isReceiptModified.value = true;
                  },
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
