import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_receipts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget receiptHeader(BuildContext context, BoxConstraints constraints) {
  return Container(
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
                    width: 150,
                    controller: controller.receiptDate.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.isReceiptModified.value = true;
                        controller.selectDateContext(
                          context,
                          controller.receiptDate.value,
                        );
                      },
                      icon: const Icon(Icons.date_range),
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
                  CustomDropdown(
                    width: constraints.maxWidth / 2.75,
                    textcontroller: controller.customerName.text,
                    showedSelectedName: 'entity_name',
                    hintText: 'Customer Name',
                    onChanged: (key, value) async {
                      controller.isReceiptModified.value = true;
                      controller.customerName.text = value['entity_name'];
                      controller.customerNameId.value = key;
                      controller.availableReceipts.clear();
                      controller.selectedAvailableReceipts.clear();
                      controller.outstanding.value = formatter.formatEditUpdate(
                        controller.outstanding.value,
                        TextEditingValue(
                          text: await controller
                              .calculateCustomerOutstanding(key)
                              .then((value) {
                                return value.toString();
                              }),
                        ),
                      );
                    },
                    onDelete: () {
                      controller.customerName.clear();
                      controller.customerNameId.value = '';
                      controller.availableReceipts.clear();
                      controller.selectedAvailableReceipts.clear();
                      controller.outstanding.clear();
                      controller.isReceiptModified.value = true;
                    },
                    onOpen: () {
                      return controller.getAllCustomers();
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
  );
}
