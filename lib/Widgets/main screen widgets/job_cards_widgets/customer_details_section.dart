import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/branches.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/currency.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/sales_man.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';
import '../add_new_values_button.dart';

Widget customerDetailsSection(
  JobCardController controller,
  BoxConstraints constraints,
) {
  return Scrollbar(
    thumbVisibility: true,
    controller: controller.scrollerForCustomer,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      width: double.infinity,
      child: GetX<JobCardController>(
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
                      MenuWithValues(
                        focusNode: controller.focusNodeForCustomerDetails1,
                        nextFocusNode: controller.focusNodeForCustomerDetails2,
                        labelText: 'Customer',
                        headerLqabel: 'Customers',
                        dialogWidth: constraints.maxWidth / 2,
                        width: Get.width / 3.7,
                        controller: controller.customerName,
                        displayKeys: const ['entity_name'],
                        flexList: const [1, 1],
                        displaySelectedKeys: const ['entity_name'],
                        onOpen: () {
                          return controller.getAllCustomers();
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
                          controller.isJobModified.value = true;
                        },
                        onSelected: (value) {
                          controller.customerName.text = value['entity_name'];
                          controller.onSelectForCustomers(value['_id'], value);
                          controller.customerId.value = value['_id'];
                          controller.isJobModified.value = true;
                          controller.jobWarrentyDays.value.text =
                              value.containsKey('warranty_days')
                              ? value['warranty_days'].toString()
                              : '0';
                        },
                      ),

                      ExcludeFocus(
                        child: newValueButton(
                          constraints,
                          'Add New Customer',
                          'Entity Information',
                          const EntityInformations(),
                        ),
                      ),
                    ],
                  ),
                  myTextFormFieldWithBorder(
                    focusNode: controller.focusNodeForCustomerDetails2,
                    onFieldSubmitted: (_) =>
                        controller.focusNodeForCustomerDetails3.requestFocus(),
                    width: 250,
                    controller: controller.customerEntityName,
                    labelText: 'Contact Name',
                    onChanged: (_) {
                      controller.isJobModified.value = true;
                    },
                  ),
                  myTextFormFieldWithBorder(
                    focusNode: controller.focusNodeForCustomerDetails3,
                    onFieldSubmitted: (_) =>
                        controller.focusNodeForCustomerDetails4.requestFocus(),
                    width: 250,
                    controller: controller.customerEntityPhoneNumber,
                    labelText: 'Contact Number',
                    onChanged: (_) {
                      controller.isJobModified.value = true;
                    },
                  ),
                  myTextFormFieldWithBorder(
                    focusNode: controller.focusNodeForCustomerDetails4,
                    onFieldSubmitted: (_) =>
                        controller.focusNodeForCustomerDetails5.requestFocus(),
                    width: 250,
                    controller: controller.customerEntityEmail,
                    labelText: 'Contact Email',
                    onChanged: (_) {
                      controller.isJobModified.value = true;
                    },
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
                          controller.isJobModified.value = true;
                        },
                      ),
                      myTextFormFieldWithBorder(
                        width: 120,
                        isEnabled: false,
                        isnumber: true,
                        controller: controller.customerOutstanding,
                        labelText: 'Outstanding',
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MenuWithValues(
                            focusNode: controller.focusNodeForCustomerDetails5,
                            nextFocusNode:
                                controller.focusNodeForCustomerDetails6,
                            labelText: 'Salesman',
                            headerLqabel: 'Salesman',
                            dialogWidth: constraints.maxWidth / 3,
                            width: 320,
                            controller: controller.customerSaleMan,
                            displayKeys: const ['name'],
                            flexList: const [1],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getSalesMan();
                            },
                            onDelete: () {
                              controller.customerSaleMan.clear();
                              controller.customerSaleManId.value = "";
                              controller.isJobModified.value = true;
                            },
                            onSelected: (value) {
                              controller.customerSaleMan.text = value['name'];
                              controller.customerSaleManId.value = value['_id'];
                              controller.isJobModified.value = true;
                            },
                          ),
                          ExcludeFocus(
                            child: newValueButton(
                              constraints,
                              'Add New Salesman',
                              'Salesman',
                              const SalesMan(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MenuWithValues(
                        focusNode: controller.focusNodeForCustomerDetails6,
                        nextFocusNode: controller.focusNodeForCustomerDetails7,
                        labelText: 'Branch',
                        headerLqabel: 'Branches',
                        dialogWidth: constraints.maxWidth / 3,
                        width: 320,
                        controller: controller.customerBranch,
                        displayKeys: const ['name'],
                        flexList: const [1],
                        displaySelectedKeys: const ['name'],
                        onOpen: () {
                          return controller.getBranches();
                        },
                        onDelete: () {
                          controller.customerBranch.clear();
                          controller.customerBranchId.value = "";
                          controller.isJobModified.value = true;
                        },
                        onSelected: (value) {
                          controller.customerBranch.text = value['name'];
                          controller.customerBranchId.value = value['_id'];
                          controller.isJobModified.value = true;
                        },
                      ),

                      ExcludeFocus(
                        child: newValueButton(
                          constraints,
                          'Add New Branch',
                          'Branches',
                          const Branches(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MenuWithValues(
                        focusNode: controller.focusNodeForCustomerDetails7,
                        nextFocusNode: controller.focusNodeForCustomerDetails8,
                        labelText: 'Currency',
                        headerLqabel: 'Currencies',
                        dialogWidth: constraints.maxWidth / 3,
                        width: 170,
                        controller: controller.customerCurrency,
                        displayKeys: const ['currency_code'],
                        flexList: const [1],
                        displaySelectedKeys: const ['currency_code'],
                        onOpen: () {
                          return controller.getCurrencies();
                        },
                        onDelete: () {
                          controller.customerCurrency.clear();
                          controller.customerCurrencyId.value = "";
                          controller.customerCurrencyRate.clear();
                          controller.isJobModified.value = true;
                        },
                        onSelected: (value) {
                          controller.customerCurrency.text =
                              value['currency_code'];
                          controller.customerCurrencyId.value = value['_id'];
                          controller.customerCurrencyRate.text =
                              (value['rate'] ?? '1').toString();
                          controller.isJobModified.value = true;
                        },
                      ),

                      ExcludeFocus(
                        child: newValueButton(
                          constraints,
                          'Add New Currency',
                          'Currencies',
                          const Currency(),
                        ),
                      ),
                      const SizedBox(width: 10),

                      myTextFormFieldWithBorder(
                        focusNode: controller.focusNodeForCustomerDetails8,
                        width: 100,
                        isDouble: true,
                        controller: controller.customerCurrencyRate,
                        labelText: 'Rate',
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                      const SizedBox(width: 10),
                      ExcludeFocus(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                'Payment Type',
                                style: textFieldLabelStyle,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 35,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                              ),
                              child: RadioGroup<String>(
                                groupValue: controller.payType.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectCashOrCredit(value);
                                  }
                                },
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    CupertinoRadio<String>(
                                      value: 'Cash',
                                      fillColor: mainColor,
                                      activeColor: Colors.grey.shade300,
                                      inactiveColor: Colors.grey.shade300,
                                    ),
                                    Text('Cash', style: textFieldFontStyle),
                                    CupertinoRadio<String>(
                                      value: 'Credit',
                                      fillColor: mainColor,
                                      activeColor: Colors.grey.shade300,
                                      inactiveColor: Colors.grey.shade300,
                                    ),
                                    Text('Credit', style: textFieldFontStyle),
                                  ],
                                ),
                              ),
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
        },
      ),
    ),
  );
}
