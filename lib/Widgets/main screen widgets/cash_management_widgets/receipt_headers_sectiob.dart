import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget receiptHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CashManagementController>(builder: (controller) {
      bool isCustomerLoading = controller.allCustomers.isEmpty;
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: myTextFormFieldWithBorder(
                  isEnabled: false,
                  controller: controller.receiptCounter.value,
                  labelText: 'Receipt Number',
                ),
              ),
              Expanded(
                // flex: 2,
                child: myTextFormFieldWithBorder(
                  controller: controller.receiptDate.value,
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.selectDateContext(
                            context, controller.receiptDate.value);
                      },
                      icon: const Icon(Icons.date_range)),
                  isDate: true,
                  labelText: 'Receipt Date',
                   onFieldSubmitted: (_) async {
                    await normalizeDate(controller.receiptDate.value.text,
                        controller.receiptDate.value);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 4,
                child: CustomDropdown(
                  textcontroller: controller.customerName.text,
                  showedSelectedName: 'entity_name',
                  hintText: 'Customer Name',
                  items: isCustomerLoading ? {} : controller.allCustomers,
                  // itemBuilder: (context, key, value) {
                  //   return ListTile(
                  //     title: Text(value['entity_name']),
                  //   );
                  // },
                  onChanged: (key, value) async {
                    controller.customerName.text = value['entity_name'];
                    controller.customerNameId.value = key;
                    controller.availableReceipts.clear();
                    controller.selectedAvailableReceipts.clear();
                    controller.outstanding.text =
                        await controller.calculateCustomerOutstanding(key);
                  },
                ),
              ),
              Expanded(
                  child: myTextFormFieldWithBorder(
                      labelText: 'Outstanding',
                      controller: controller.outstanding,
                      isEnabled: false)),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 4,
                child: myTextFormFieldWithBorder(
                  controller: controller.note,
                  labelText: 'Notes',
                  maxLines: 4,
                ),
              ),
              Expanded(child: SizedBox())
            ],
          ),
        ],
      );
    }),
  );
}
