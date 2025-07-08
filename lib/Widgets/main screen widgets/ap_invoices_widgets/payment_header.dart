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
      bool isMiscTypesLoading = controller.allInvoiceTypes.isEmpty;
      bool isVendorLoading = controller.allVendors.isEmpty;
      return Row(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FocusTraversalGroup(
            child: Expanded(
                child: Column(
              spacing: 10,
              children: [
                Row(
                  children: [
                    FocusTraversalOrder(
                      order: NumericFocusOrder(1),
                      child: Expanded(
                        child: CustomDropdown(
                          focusNode: controller.focusNodePayementHeader1,
                          nextFocusNode: controller.focusNodePayementHeader2,
                          showedSelectedName: 'name',
                          textcontroller: controller.invoiceType.text,
                          hintText: 'Invoice Type',
                          items: isMiscTypesLoading
                              ? {}
                              : controller.allInvoiceTypes,
                          onChanged: (key, value) {
                            controller.invoiceTypeId.value = key;
                            controller.invoiceType.text = value['name'];
                          },
                        ),
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
                        child: FocusTraversalOrder(
                      order: NumericFocusOrder(2),
                      child: myTextFormFieldWithBorder(
                          textInputAction: TextInputAction.next,
                          focusNode: controller.focusNodePayementHeader2,
                          onEditingComplete: () {
                            Get.focusScope!.requestFocus(
                                controller.focusNodePayementHeader3);
                            // FocusScope.of(context).requestFocus(
                            //     controller.focusNodePayementHeader3);
                          },
                          isDate: true,
                          suffixIcon: IconButton(
                              focusNode: FocusNode(skipTraversal: true),
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
                          labelText: 'Transaction Date'),
                    )),
                    Expanded(flex: 3, child: SizedBox())
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: FocusTraversalOrder(
                        order: NumericFocusOrder(3),
                        child: CustomDropdown(
                          focusNode: controller.focusNodePayementHeader3,
                          nextFocusNode: controller.focusNodePayementHeader4,
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
                    ),
                    addNewEntityButton()
                  ],
                )
              ],
            )),
          ),
          Expanded(
              child: FocusTraversalOrder(
            order: NumericFocusOrder(4),
            child: myTextFormFieldWithBorder(
                // focusNode: FocusNode(skipTraversal: true),
                focusNode: controller.focusNodePayementHeader4,
                labelText: 'Note',
                maxLines: 10,
                controller: controller.note),
          ))
        ],
      );
    }),
  );
}

IconButton addNewEntityButton() {
  return IconButton(
      focusNode: FocusNode(skipTraversal: true),
      onPressed: () {
        Get.dialog(
            barrierDismissible: false,
            Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              insetPadding: const EdgeInsets.all(8),
              child: LayoutBuilder(builder: (context, constraints) {
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
                            style: fontStyleForScreenNameUsedInButtons,
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
      icon: Icon(Icons.add));
}
