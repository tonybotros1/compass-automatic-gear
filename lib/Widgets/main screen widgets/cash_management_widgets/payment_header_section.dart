import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_payments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
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
                  return CustomDropdown(
                    width: constraints.maxWidth / 2.75,
                    textcontroller: controller.vendorName.text,
                    hintText: 'Vendor Name',
                    showedSelectedName: 'entity_name',
                    onChanged: (key, value) async {
                      controller.isPaymentModified.value = true;
                      controller.vendorName.text = value['entity_name'];
                      controller.vendorNameId.value = key;
                      controller.availablePayments.clear();
                      controller.selectedAvailablePayments.clear();
                      controller.outstanding.value = formatter.formatEditUpdate(
                        controller.outstanding.value,
                        TextEditingValue(
                          text: await controller
                              .calculateVendorOutstanding(key)
                              .then((value) {
                                return value.toString();
                              }),
                        ),
                      );
                    },
                    onDelete: () {
                      controller.isPaymentModified.value = true;
                      controller.vendorName.clear();
                      controller.vendorNameId.value = '';
                      controller.availablePayments.clear();
                      controller.selectedAvailablePayments.clear();
                      controller.outstanding.clear();
                    },
                    onOpen: () {
                      return controller.getAllVendors();
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
            width: constraints.maxWidth / 2.75,
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
