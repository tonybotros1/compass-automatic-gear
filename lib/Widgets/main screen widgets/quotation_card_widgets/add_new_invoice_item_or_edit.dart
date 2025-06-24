import 'package:datahubai/Controllers/Main%20screen%20controllers/quotation_card_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Screens/Main screens/System Administrator/Setup/invoice_items.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Widget addNewinvoiceItemsOrEdit({
  required QuotationCardController controller,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (75%)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: myTextFormFieldWithBorder(
                          isnumber: true,
                          controller: controller.lineNumber,
                          labelText: 'Line Number',
                          hintText: 'Enter Line Number',
                          validate: true,
                        ),
                      ),
                      Expanded(flex: 4, child: SizedBox())
                    ],
                  ),
                  SizedBox(height: 12),
                  GetX<QuotationCardController>(builder: (context) {
                    bool isLoading =
                        controller.allInvoiceItemsFromCollection.isEmpty;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            hintText: 'Name',
                            textcontroller: controller.invoiceItemName.text,
                            showedSelectedName: 'name',
                            validator: true,
                            items: isLoading
                                ? {}
                                : controller.allInvoiceItemsFromCollection,
                            onChanged: (key, value) {
                              controller.invoiceItemName.text = value['name'];
                              controller.description.text =
                                  value['description'];
                              controller.invoiceItemNameId.value = key;
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
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        topRight:
                                                            Radius.circular(5)),
                                                color: mainColor,
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              width: constraints.maxWidth,
                                              child:
                                                  Row(spacing: 10, children: [
                                                Text(
                                                  'Invoice Items',
                                                  style:
                                                      fontStyleForScreenNameUsedInButtons,
                                                ),
                                                const Spacer(),
                                                closeIcon()
                                              ])),
                                          Expanded(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: InvoiceItems()))
                                        ],
                                      );
                                    }),
                                  ));
                            },
                            icon: Icon(Icons.add))
                      ],
                    );
                  }),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    maxLines: 13,
                    controller: controller.description,
                    labelText: 'Description',
                    hintText: 'Enter Description',
                    validate: true,
                  ),
                ],
              ),
            ),

            SizedBox(width: 24),

            // Right Column (25%)
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pricing Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    onChanged: (_) => controller.updateCalculating(),
                    isnumber: true,
                    controller: controller.quantity,
                    labelText: 'Quantity',
                    hintText: 'Enter Quantity',
                    validate: true,
                  ),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    onChanged: (_) => controller.updateCalculating(), 
                    isDouble: true,
                    controller: controller.price,
                    labelText: 'Price',
                    hintText: 'Enter Price',
                    validate: true,
                  ),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    onChanged: (_) => controller.updateCalculating(),
                    isEnabled: false,
                    controller: controller.amount,
                    labelText: 'Amount',
                    hintText: 'Auto-calculated',
                    validate: true,
                  ),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    onChanged: (_) => controller.updateCalculating(),
                    isDouble: true,
                    controller: controller.discount,
                    labelText: 'Discount',
                    hintText: 'Enter Discount',
                    validate: true,
                  ),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    isEnabled: false,
                    controller: controller.total,
                    labelText: 'Total',
                    hintText: 'Auto-calculated',
                    validate: true,
                  ),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    isEnabled: false,
                    onChanged: (_) => controller.updateCalculating(),
                    isDouble: true,
                    controller: controller.vat,
                    labelText: 'VAT',
                    hintText: 'Auto-calculated',
                    validate: true,
                  ),
                  SizedBox(height: 12),
                  myTextFormFieldWithBorder(
                    onChanged: (_) => controller.updateAmount(),
                    isDouble: true,
                    controller: controller.net,
                    labelText: 'Net',
                    hintText: 'Enter Net',
                    validate: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
