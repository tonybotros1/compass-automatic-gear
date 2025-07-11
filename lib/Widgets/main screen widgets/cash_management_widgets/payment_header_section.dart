import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget paymentHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CashManagementController>(builder: (controller) {
      bool isVendorLoading = controller.allVendors.isEmpty;
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                  child:
                      myTextFormFieldWithBorder(labelText: 'Payment Number')),
              Expanded(
                child: myTextFormFieldWithBorder(
                  // suffixIcon: IconButton(
                  //     onPressed: () {
                  //       controller.selectDateContext(
                  //           context, controller.receiptDate.value);
                  //     },
                  //     icon: const Icon(Icons.date_range)),
                  isDate: true,
                  labelText: 'Payment Date',
                ),
              ),
              Expanded(flex: 2, child: SizedBox()),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  flex: 4,
                  child: CustomDropdown(
                    hintText: 'Vendor Name',
                    showedSelectedName: 'entity_name',
                    items: isVendorLoading ? {} : controller.allVendors,
                    onChanged: (key, value) async {
                      controller.vendorName.text = value['entity_name'];
                      controller.vendorNameId.value = key;
                      controller.availableReceipts.clear();
                      controller.selectedAvailableReceipts.clear();
                      controller.outstanding.text =
                          await controller.calculateCustomerOutstanding(key);
                    },
                  )),
              Expanded(
                  child: myTextFormFieldWithBorder(
                      labelText: 'Outstanding', isEnabled: false)),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  flex: 4,
                  child: myTextFormFieldWithBorder(
                      labelText: 'Note', maxLines: 4)),
              Expanded(child: SizedBox())
            ],
          )
        ],
      );
    }),
  );
}
