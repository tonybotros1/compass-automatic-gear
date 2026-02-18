import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/branches.dart';
import '../../../Screens/Main screens/System Administrator/Setup/currency.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../Screens/Main screens/System Administrator/Setup/sales_man.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
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
      child: FocusTraversalGroup(
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
                  MenuWithValues(
                    labelText: 'Customer',
                    headerLqabel: 'Customers',
                    dialogWidth: constraints.maxWidth / 3,
                    width: constraints.maxWidth / 3.7,
                    controller: controller.customerName,
                    displayKeys: const ['entity_name'],
                    displaySelectedKeys: const ['entity_name'],
                    onSelected: (value) {
                      controller.customerName.text = value['entity_name'];
                      controller.onSelectForCustomers(value);
                      controller.customerId.value = value['_id'];
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
                      controller.customerSaleMan.clear();
                      controller.customerId.value = "";
                      controller.isQuotationModified.value = true;
                    },
                    onOpen: () {
                      return controller.getAllCustomers();
                    },
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
                  myTextFormFieldWithBorder(
                    width: 250,
                    controller: controller.customerEntityName,
                    labelText: 'Contact Name',
                    onChanged: (_) {
                      controller.isQuotationModified.value = true;
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  myTextFormFieldWithBorder(
                    width: 250,
                    controller: controller.customerEntityPhoneNumber,
                    labelText: 'Contact Number',
                    onChanged: (_) {
                      controller.isQuotationModified.value = true;
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  myTextFormFieldWithBorder(
                    width: 250,
                    controller: controller.customerEntityEmail,
                    labelText: 'Contact Email',
                    onChanged: (_) {
                      controller.isQuotationModified.value = true;
                    },
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  myTextFormFieldWithBorder(
                    width: 120,
                    isEnabled: false,
                    isnumber: true,
                    controller: controller.customerCreditNumber,
                    labelText: 'Credit Limit',
                    onChanged: (_) {
                      controller.isQuotationModified.value = true;
                    },
                  ),
                  myTextFormFieldWithBorder(
                    width: 120,
                    isEnabled: false,
                    isnumber: true,
                    controller: controller.customerOutstanding,
                    labelText: 'Outstanding',
                    onChanged: (_) {
                      controller.isQuotationModified.value = true;
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MenuWithValues(
                    labelText: 'Salesman',
                    headerLqabel: 'Salesmen',
                    dialogWidth: constraints.maxWidth / 3,
                    width: 250,
                    controller: controller.customerSaleMan,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onSelected: (value) {
                      controller.customerSaleMan.value = value['name'];
                      controller.customerSaleManId.value = value['_id'];
                      controller.isQuotationModified.value = true;
                    },
                    onDelete: () {
                      controller.customerSaleMan.clear();
                      controller.customerSaleManId.value = '';
                      controller.isQuotationModified.value = true;
                    },
                    onOpen: () {
                      return controller.getSalesMan();
                    },
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
                  MenuWithValues(
                    labelText: 'Branch',
                    headerLqabel: 'Branches',
                    dialogWidth: constraints.maxWidth / 3,
                    width: 250,
                    controller: controller.customerBranch,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onSelected: (value) {
                      controller.customerBranch.text = value['name'];
                      controller.customerBranchId.value = value['_id'];
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
                  MenuWithValues(
                    labelText: 'Currency',
                    headerLqabel: 'Currencies',
                    dialogWidth: constraints.maxWidth / 3,
                    width: 170,
                    controller: controller.customerCurrency,
                    displayKeys: const ['currency_code'],
                    displaySelectedKeys: const ['currency_code'],
                    onSelected: (value) {
                      controller.customerCurrency.text = value['currency_code'];
                      controller.customerCurrencyId.value = value['_id'];
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
                    onChanged: (_) {
                      controller.isQuotationModified.value = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
