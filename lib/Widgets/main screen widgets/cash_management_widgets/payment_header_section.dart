import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_payments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Widget paymentHeader(
  BuildContext context,
  BoxConstraints constraints,
  CashManagementPaymentsController controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: SingleChildScrollView(
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
                labelText: 'Payment Number',
                controller: controller.paymentCounter.value,
                isEnabled: false,
              ),
              myTextFormFieldWithBorder(
                focusNode: controller.focusNode1,
                nextFocusNode: controller.focusNode2,
                width: 150,
                controller: controller.paymentDate.value,
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.isPaymentModified.value = true;
                    controller.selectDateContext(
                      context,
                      controller.paymentDate.value,
                    );
                  },
                  icon: const Icon(Icons.date_range),
                ),
                isDate: true,
                labelText: 'Payment Date',
                onFieldSubmitted: (_) async {
                  controller.isPaymentModified.value = true;
                  normalizeDate(
                    controller.paymentDate.value.text,
                    controller.paymentDate.value,
                  );
                },
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              GetBuilder<CashManagementPaymentsController>(
                builder: (controller) {
                  return MenuWithValues(
                    focusNode: controller.focusNode2,
                    nextFocusNode: controller.focusNode3,
                    previousFocusNode: controller.focusNode1,
                    labelText: 'Vendor Name',
                    headerLqabel: 'Vendors',
                    dialogWidth: constraints.maxWidth / 2,
                    width: constraints.maxWidth / 2.75,
                    controller: controller.vendorName,
                    displayKeys: const ['entity_name'],
                    displaySelectedKeys: const ['entity_name'],
                    onOpen: () {
                      return controller.getAllVendors();
                    },
                    onDelete: () {
                      controller.isPaymentModified.value = true;
                      controller.vendorName.clear();
                      controller.vendorNameId.value = '';
                      controller.availablePayments.clear();
                      controller.selectedAvailablePayments.clear();
                      controller.outstanding.clear();
                    },
                    onSelected: (value) async {
                      controller.isPaymentModified.value = true;
                      controller.vendorName.text = value['entity_name'];
                      controller.vendorNameId.value = value['_id'];
                      controller.availablePayments.clear();
                      controller.selectedAvailablePayments.clear();
                      // controller.outstanding.value = formatter.formatEditUpdate(
                      //   controller.outstanding.value,
                      //   TextEditingValue(
                      //     text: await controller
                      //         .calculateVendorOutstanding(value['_id'])
                      //         .then((value) {
                      //           return value.toString();
                      //         }),
                      //   ),
                      // );
                      final outstandingAmount = await controller
                          .calculateVendorOutstanding(value['_id']);
                      controller.outstanding.text = outstandingAmount
                          .toStringAsFixed(2);
                    },
                  );
                },
              ),
              myTextFormFieldWithBorder(
                width: 150,
                controller: controller.outstanding,
                labelText: 'Outstanding',
                isEnabled: false,
              ),
            ],
          ),
          myTextFormFieldWithBorder(
            focusNode: controller.focusNode3,
            nextFocusNode: controller.focusNodeForAccountInfos1,
            previousFocusNode: controller.focusNode2,
            width: constraints.maxWidth / 2.75,
            controller: controller.note,
            labelText: 'Note',
            maxLines: 4,
            onChanged: (_) {
              controller.isPaymentModified.value = true;
            },
          ),
        ],
      ),
    ),
  );
}
