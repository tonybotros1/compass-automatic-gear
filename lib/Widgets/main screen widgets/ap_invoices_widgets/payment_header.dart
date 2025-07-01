import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';

Widget paymentHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<ApInvoicesController>(builder: (controller) {
      bool isMiscTypesLoading = controller.allMiscTypes.isEmpty;
      bool isVendorLoading = controller.allVendors.isEmpty;
      return Row(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      showedSelectedName: 'name',
                      textcontroller: controller.miscType.text,
                      hintText: 'Misc Type',
                      items: isMiscTypesLoading ? {} : controller.allMiscTypes,
                      onChanged: (key, value) {
                        controller.miscTypeId.value = key;
                        controller.miscType.text = value['name'];
                      },
                    ),
                  ),
                  Expanded(flex: 3, child: SizedBox())
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: myTextFormFieldWithBorder(
                          controller: controller.referenceNumber,
                          isEnabled: false,
                          labelText: 'Reference Number')),
                  Expanded(flex: 4, child: SizedBox())
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: myTextFormFieldWithBorder(
                          isDate: true,
                          suffixIcon: IconButton(
                              onPressed: () {
                                selectDateContext(
                                    context, controller.transactionDate);
                              },
                              icon: const Icon(Icons.date_range)),
                          controller: controller.transactionDate,
                          onFieldSubmitted: (_) {
                            normalizeDate(controller.transactionDate.value.text,
                                controller.transactionDate);
                          },
                          labelText: 'Transaction Date')),
                  Expanded(flex: 3, child: SizedBox())
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomDropdown(
                      showedSelectedName: 'entity_name',
                      textcontroller: controller.vendor.text,
                      hintText: 'Beneficiary ',
                      items: isVendorLoading ? {} : controller.allVendors,
                      onChanged: (key, value) {
                        controller.vendorId.value = key;
                        controller.vendor.text = value['entity_name'];
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.dialog(
                            barrierDismissible: false,
                            Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              insetPadding: const EdgeInsets.all(8),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: mainColor,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        width: constraints.maxWidth,
                                        child: Row(spacing: 10, children: [
                                          Text(
                                            'Entity Information',
                                            style:
                                                fontStyleForScreenNameUsedInButtons,
                                          ),
                                          const Spacer(),
                                          closeIcon()
                                        ])),
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: EntityInformations()))
                                  ],
                                );
                              }),
                            ));
                      },
                      icon: Icon(Icons.add))
                ],
              )
            ],
          )),
          Expanded(
              child: myTextFormFieldWithBorder(
                  labelText: 'Note', maxLines: 10, controller: controller.note))
        ],
      );
    }),
  );
}
