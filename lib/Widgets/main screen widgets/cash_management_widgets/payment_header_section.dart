import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_payments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget paymentHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CashManagementPaymentsController>(
      builder: (controller) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    labelText: 'Payment Number',
                    controller: controller.paymentCounter.value,
                    isEnabled: false,
                  ),
                ),
                Expanded(
                  child: myTextFormFieldWithBorder(
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
                ),
                const Expanded(flex: 2, child: SizedBox()),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 4,
                  child: CustomDropdown(
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
                  ),
                ),
                Expanded(
                  child: myTextFormFieldWithBorder(
                    controller: controller.outstanding,
                    labelText: 'Outstanding',
                    isEnabled: false,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 4,
                  child: myTextFormFieldWithBorder(
                    labelText: 'Note',
                    maxLines: 4,
                    onChanged: (_) {
                      controller.isPaymentModified.value = true;
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        );
      },
    ),
  );
}
