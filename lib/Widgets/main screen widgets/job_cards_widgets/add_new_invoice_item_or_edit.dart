import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import '../../../Screens/Main screens/System Administrator/Setup/invoice_items.dart';
import '../../my_text_field.dart';
import '../add_new_values_button.dart';

Widget addNewinvoiceItemsOrEdit({
  required JobCardController controller,
  required BoxConstraints constraints,
}) {
  return SingleChildScrollView(
    child: FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
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
                    const Text(
                      'Item Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: myTextFormFieldWithBorder(
                            focusNode: controller.focusNodeForItemsDetails1,
                            onFieldSubmitted: (_) => controller
                                .focusNodeForItemsDetails2
                                .requestFocus(),
                            isnumber: true,
                            controller: controller.lineNumber,
                            labelText: 'Line Number',
                            validate: true,
                          ),
                        ),
                        const Expanded(flex: 4, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            focusNode: controller.focusNodeForItemsDetails2,
                            nextFocusNode: controller.focusNodeForItemsDetails3,
                            hintText: 'Name',
                            textcontroller: controller.invoiceItemName.text,
                            showedSelectedName: 'name',
                            validator: true,
                            onChanged: (key, value) {
                              controller.invoiceItemName.text = value['name'];
                              controller.description.text =
                                  value['description'];
                              controller.invoiceItemNameId.value = key;
                            },
                            onOpen: () {
                              return controller.getInvoiceItemsFromCollection();
                            },
                            onDelete: () {
                              controller.invoiceItemName.clear();
                              controller.invoiceItemNameId.value = '';
                            },
                          ),
                        ),
                        ExcludeFocus(
                          child: newValueButton(
                            constraints,
                            'New Item',
                            'Invoice Items',
                            const InvoiceItems(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      focusNode: controller.focusNodeForItemsDetails3,
                      maxLines: 13,
                      controller: controller.description,
                      labelText: 'Description',
                      validate: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Right Column (25%)
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pricing Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      onChanged: (_) => controller.updateCalculating(),
                      isnumber: true,
                      controller: controller.quantity,
                      labelText: 'Quantity',
                      validate: true,
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      onChanged: (_) => controller.updateCalculating(),
                      isDouble: true,
                      controller: controller.price,
                      labelText: 'Price',
                      validate: true,
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      onChanged: (_) => controller.updateCalculating(),
                      isEnabled: false,
                      controller: controller.amount,
                      labelText: 'Amount',
                      validate: true,
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      onChanged: (_) => controller.updateCalculating(),
                      isDouble: true,
                      controller: controller.discount,
                      labelText: 'Discount',
                      validate: true,
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      isEnabled: false,
                      controller: controller.total,
                      labelText: 'Total',
                      validate: true,
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      isEnabled: false,
                      onChanged: (_) => controller.updateCalculating(),
                      isDouble: true,
                      controller: controller.vat,
                      labelText: 'VAT',
                      validate: true,
                    ),
                    const SizedBox(height: 12),
                    myTextFormFieldWithBorder(
                      onChanged: (_) => controller.updateAmount(),
                      isDouble: true,
                      controller: controller.net,
                      labelText: 'Net',
                      validate: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
