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
    child: GetX<CashManagementPaymentsController>(builder: (controller) {
      bool isVendorLoading = controller.allVendors.isEmpty;
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
                      isEnabled: false)),
              Expanded(
                child: myTextFormFieldWithBorder(
                  controller: controller.paymentDate.value,
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.selectDateContext(
                            context, controller.paymentDate.value);
                      },
                      icon: const Icon(Icons.date_range)),
                  isDate: true,
                  labelText: 'Payment Date',
                  onFieldSubmitted: (_) async {
                    normalizeDate(controller.paymentDate.value.text,
                        controller.paymentDate.value);
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
                    items: isVendorLoading ? {} : controller.allVendors,
                    onChanged: (key, value) async {
                      controller.vendorName.text = value['entity_name'];
                      controller.vendorNameId.value = key;
                      controller.availableReceipts.clear();
                      controller.selectedAvailableReceipts.clear();
                      // controller.outstanding.text =
                      // await controller.getVendorInvoices(key);
                      controller.getVendorOutstanding(key);
                    },
                  )),
              Expanded(
                  child: myTextFormFieldWithBorder(
                      controller: controller.outstanding,
                      labelText: 'Outstanding',
                      isEnabled: false)),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  flex: 4,
                  child: myTextFormFieldWithBorder(
                      labelText: 'Note', maxLines: 4)),
              const Expanded(child: SizedBox())
            ],
          )
        ],
      );
    }),
  );
}
