import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/branches.dart';
import '../../../Screens/Main screens/System Administrator/Setup/currency.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../Screens/Main screens/System Administrator/Setup/sales_man.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';
import '../add_new_values_button.dart';

Widget customerDetailsSection(
  BoxConstraints constraints,
  QuotationCardController controller,
) {
  return Scrollbar(
    thumbVisibility: true,
    controller: controller.scrollerForCustomer,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      width: double.infinity,
      child: GetX<QuotationCardController>(
        builder: (controller) {
          return FocusTraversalGroup(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: controller.scrollerForCustomer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(1),
                        child: Focus(
                          child: CustomDropdown(
                            width: constraints.maxWidth / 3.7,
                            showedSelectedName: 'entity_name',
                            textcontroller: controller.customerName.text,
                            hintText: 'Customer',
                            onChanged: (key, value) {
                              controller.customerName.text =
                                  value['entity_name'];
                              controller.onSelectForCustomers(value);
                              controller.customerId.value = key;
                              controller.isQuotationModified.value = true;
                              controller.quotationWarrentyDays.value.text =
                                value.containsKey('warranty_days')
                                ? value['warranty_days'].toString()
                                : '0';
                            },
                            onDelete: () {
                              controller.customerName.clear();
                              controller.customerEntityPhoneNumber.clear();
                              controller.customerEntityName.clear();
                              controller.customerEntityEmail.clear();
                              controller.customerCreditNumber.clear();
                              controller.customerSaleManId.value = "";
                              controller.customerSaleMan.value = "";
                              controller.customerId.value = "";
                              controller.isQuotationModified.value = true;
                            },
                            onOpen: () {
                              return controller.getAllCustomers();
                            },
                          ),
                        ),
                      ),
                      newValueButton(
                        constraints,
                        'Add New Customer',
                        'Entity Information',
                        const EntityInformations(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(2),
                        child: myTextFormFieldWithBorder(
                          width: 250,
                          controller: controller.customerEntityName,
                          labelText: 'Contact Name',
                          hintText: 'Enter Contact Name',
                          onChanged: (_) {
                            controller.isQuotationModified.value = true;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(3),
                        child: myTextFormFieldWithBorder(
                          width: 250,
                          controller: controller.customerEntityPhoneNumber,
                          labelText: 'Contact Number',
                          hintText: 'Enter Contact Number',
                          onChanged: (_) {
                            controller.isQuotationModified.value = true;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      myTextFormFieldWithBorder(
                        width: 250,
                        controller: controller.customerEntityEmail,
                        labelText: 'Contact Email',
                        hintText: 'Enter Contact Email',
                        onChanged: (_) {
                          controller.isQuotationModified.value = true;
                        },
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(4),
                        child: myTextFormFieldWithBorder(
                          width: 120,
                          isEnabled: false,
                          isnumber: true,
                          controller: controller.customerCreditNumber,
                          labelText: 'Credit Limit',
                          hintText: 'Enter Credit Limit',
                          onChanged: (_) {
                            controller.isQuotationModified.value = true;
                          },
                        ),
                      ),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(5),
                        child: myTextFormFieldWithBorder(
                          width: 120,
                          isEnabled: false,
                          isnumber: true,
                          controller: controller.customerOutstanding,
                          labelText: 'Outstanding',
                          hintText: 'Enter Outstanding',
                          onChanged: (_) {
                            controller.isQuotationModified.value = true;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(6),
                        child: Focus(
                          child: CustomDropdown(
                            width: 250,
                            showedSelectedName: 'name',
                            textcontroller: controller.customerSaleMan.value,
                            hintText: 'Salesman',

                            onChanged: (key, value) {
                              controller.customerSaleMan.value = value['name'];
                              controller.customerSaleManId.value = key;
                              controller.isQuotationModified.value = true;
                            },
                            onDelete: () {
                              controller.customerSaleMan.value = '';
                              controller.customerSaleManId.value = '';
                              controller.isQuotationModified.value = true;
                            },
                            onOpen: () {
                              return controller.getSalesMan();
                            },
                          ),
                        ),
                      ),
                      newValueButton(
                        constraints,
                        'Add New Salesman',
                        'Salesman',
                        const SalesMan(),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomDropdown(
                        width: 170,
                        showedSelectedName: 'name',
                        textcontroller: controller.customerBranch.text,
                        hintText: 'Branch',
                        onChanged: (key, value) {
                          controller.customerBranch.text = value['name'];
                          controller.customerBranchId.value = key;
                          controller.isQuotationModified.value = true;
                        },
                        onDelete: () {
                          controller.customerBranch.clear();
                          controller.customerBranchId.value = '';
                          controller.isQuotationModified.value = true;
                        },
                        onOpen: () {
                          return controller.getBranches();
                        },
                      ),
                      newValueButton(
                        constraints,
                        'Add New Branch',
                        'Branches',
                        const Branches(),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomDropdown(
                        width: 170,
                        textcontroller: controller.customerCurrency.value.text,
                        hintText: 'Currency',
                        showedSelectedName: 'currency_code',
                        onChanged: (key, value) {
                          controller.customerCurrency.text =
                              value['currency_code'];
                          controller.customerCurrencyId.value = key;
                          controller.customerCurrencyRate.text =
                              (value['rate'] ?? '1').toString();
                          controller.isQuotationModified.value = true;
                        },
                        onDelete: () {
                          controller.customerCurrency.clear();
                          controller.customerCurrencyId.value = '';
                          controller.customerCurrencyRate.clear();
                          controller.isQuotationModified.value = true;
                        },
                        onOpen: () {
                          return controller.getCurrencies();
                        },
                      ),
                      newValueButton(
                        constraints,
                        'Add New Currency',
                        'Currencies',
                        const Currency(),
                      ),
                      const SizedBox(width: 10),
                      myTextFormFieldWithBorder(
                        width: 100,
                        isDouble: true,
                        controller: controller.customerCurrencyRate,
                        labelText: 'Rate',
                        hintText: 'Enter Rate',
                        onChanged: (_) {
                          controller.isQuotationModified.value = true;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
