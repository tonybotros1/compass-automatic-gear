import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';

Widget paymentHeader(BuildContext context, BoxConstraints constraints) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetBuilder<ApInvoicesController>(
      builder: (controller) {
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
                      spacing: 10,
                      children: [
                        Expanded(
                          flex: 3,
                          child: MenuWithValues(
                            focusNode: controller.focusNodePayementHeader1,
                            nextFocusNode: controller.focusNodePayementHeader2,
                            labelText: 'Invoice Type',
                            headerLqabel: 'Invoice Types',
                            dialogWidth: constraints.maxWidth / 3,
                            dialogHeight: 400,
                            controller: controller.invoiceType,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onSelected: (value) {
                              controller.invoiceTypeId.value = value['_id'];
                              controller.invoiceType.text = value['name'];
                              controller.isInvoiceModified.value = true;
                            },
                            onOpen: () {
                              return controller.getInvoiceTypes();
                            },
                            onDelete: () {
                              controller.invoiceTypeId.value = '';
                              controller.invoiceType.clear();
                              controller.isInvoiceModified.value = true;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: myTextFormFieldWithBorder(
                            controller: controller.referenceNumber,
                            isEnabled: false,
                            labelText: 'Reference NO.',
                            onChanged: (_) {
                              controller.isInvoiceModified.value = true;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: myTextFormFieldWithBorder(
                            focusNode: controller.focusNodePayementHeader2,
                            nextFocusNode: controller.focusNodePayementHeader3,
                            isDate: true,
                            suffixIcon: IconButton(
                              focusNode: FocusNode(skipTraversal: true),
                              onPressed: () {
                                controller.isInvoiceModified.value = true;
                                selectDateContext(
                                  context,
                                  controller.transactionDate,
                                );
                              },
                              icon: const Icon(Icons.date_range),
                            ),
                            controller: controller.transactionDate,
                            onFieldSubmitted: (_) {
                              normalizeDate(
                                controller.transactionDate.text,
                                controller.transactionDate,
                              );
                            },
                            onChanged: (_) {
                              controller.isInvoiceModified.value = true;
                            },
                            labelText: 'Transaction Date',
                          ),
                        ),
                        const Expanded(flex: 5, child: SizedBox()),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          flex: 3,
                          child: myTextFormFieldWithBorder(
                            focusNode: controller.focusNodePayementHeader3,
                            nextFocusNode: controller.focusNodePayementHeader4,
                            onEditingComplete: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(controller.focusNode5);
                            },
                            textInputAction: TextInputAction.next,
                            labelText: 'Invoice Number',
                            controller: controller.invoiceNumber,
                            onChanged: (_) {
                              controller.isInvoiceModified.value = true;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: myTextFormFieldWithBorder(
                            focusNode: controller.focusNodePayementHeader4,
                            nextFocusNode: controller.focusNodePayementHeader5,

                            onChanged: (_) {
                              controller.isInvoiceModified.value = true;
                            },
                            isDate: true,
                            suffixIcon: IconButton(
                              focusNode: FocusNode(skipTraversal: true),
                              onPressed: () {
                                controller.isInvoiceModified.value = true;
                                selectDateContext(
                                  context,
                                  controller.invoiceDate,
                                );
                              },
                              icon: const Icon(Icons.date_range),
                            ),
                            controller: controller.invoiceDate,
                            onFieldSubmitted: (_) {
                              normalizeDate(
                                controller.invoiceDate.text,
                                controller.invoiceDate,
                              );
                            },
                            labelText: 'Invoice Date',
                          ),
                        ),
                        const SizedBox(),
                        const Expanded(flex: 7, child: SizedBox()),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: MenuWithValues(
                            focusNode: controller.focusNodePayementHeader5,
                            nextFocusNode: controller.focusNodePayementHeader6,
                            labelText: 'Vendor',
                            headerLqabel: 'Vendors',
                            dialogWidth: constraints.maxWidth / 2,
                            controller: controller.vendor,
                            displayKeys: const ['entity_name'],
                            displaySelectedKeys: const ['entity_name'],
                            onSelected: (value) {
                              controller.isInvoiceModified.value = true;
                              controller.vendorId.value = value['_id'];
                              controller.vendor.text = value['entity_name'];
                            },
                            onOpen: () {
                              return controller.getAllVendors();
                            },
                            onDelete: () {
                              controller.vendorId.value = '';
                              controller.vendor.clear();
                              controller.isInvoiceModified.value = true;
                            },
                          ),
                        ),
                        addNewEntityButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                focusNode: controller.focusNodePayementHeader6,
                labelText: 'Description',
                maxLines: 7,
                controller: controller.description,
                onChanged: (_) {
                  controller.isInvoiceModified.value = true;
                },
              ),
            ),
          ],
        );
      },
    ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      color: mainColor,
                    ),
                    padding: const EdgeInsets.all(16),
                    width: constraints.maxWidth,
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(
                          'Entity Information',
                          style: fontStyleForScreenNameUsedInButtons,
                        ),
                        const Spacer(),
                        closeIcon(),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: EntityInformations(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
    icon: const Icon(Icons.add),
  );
}
