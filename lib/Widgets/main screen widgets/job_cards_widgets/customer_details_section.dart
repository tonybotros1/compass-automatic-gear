import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/branches.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/currency.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/sales_man.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';
import '../add_new_values_button.dart';

Widget customerDetailsSection(BoxConstraints constraints) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<JobCardController>(
      builder: (controller) {
        // var isCustomersLoading = controller.allCustomers.isEmpty;
        // final isBranchesLoading = controller.allBranches.isEmpty;
        // final isCurrenciesLoading = controller.allCurrencies.isEmpty;
        // final isSalesManLoading = controller.salesManMap.isEmpty;
        return FocusTraversalGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Focus(
                      child: CustomDropdown(
                        focusNode: controller.focusNodeForCustomerDetails1,
                        nextFocusNode: controller.focusNodeForCustomerDetails2,
                        showedSelectedName: 'entity_name',
                        textcontroller: controller.customerName.text,
                        hintText: 'Customer',
                        onChanged: (key, value) {
                          controller.customerName.text = value['entity_name'];
                          controller.onSelectForCustomers(key, value);
                          controller.customerId.value = key;
                          controller.isJobModified.value = true;
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
                          controller.isJobModified.value = true;
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
              myTextFormFieldWithBorder(
                focusNode: controller.focusNodeForCustomerDetails2,
                width: 250,
                controller: controller.customerEntityName,
                labelText: 'Contact Name',
                hintText: 'Enter Contact Name',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
              myTextFormFieldWithBorder(
                focusNode: controller.focusNodeForCustomerDetails3,
                width: 250,
                controller: controller.customerEntityPhoneNumber,
                labelText: 'Contact Number',
                hintText: 'Enter Contact Number',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
              myTextFormFieldWithBorder(
                focusNode: controller.focusNodeForCustomerDetails4,
                width: 250,
                controller: controller.customerEntityEmail,
                labelText: 'Contact Email',
                hintText: 'Enter Contact Email',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
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
                        controller.isJobModified.value = true;
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
                        controller.isJobModified.value = true;
                      },
                    ),
                  ),
                ],
              ),
              FocusTraversalOrder(
                order: const NumericFocusOrder(6),
                child: Focus(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomDropdown(
                        focusNode: controller.focusNodeForCustomerDetails5,
                        nextFocusNode: controller.focusNodeForCustomerDetails6,

                        width: 250,
                        showedSelectedName: 'name',
                        textcontroller: controller.customerSaleMan.value,
                        hintText: 'Salesman',
                        onChanged: (key, value) {
                          controller.customerSaleMan.value = value['name'];
                          controller.customerSaleManId.value = key;
                          controller.isJobModified.value = true;
                        },
                        onDelete: () {
                          controller.customerSaleMan.value = "";
                          controller.customerSaleManId.value = "";
                          controller.isJobModified.value = true;
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
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomDropdown(
                    focusNode: controller.focusNodeForCustomerDetails6,
                    nextFocusNode: controller.focusNodeForCustomerDetails7,
                    width: 170,
                    showedSelectedName: 'name',
                    textcontroller: controller.customerBranch.text,
                    hintText: 'Branch',
                    onChanged: (key, value) {
                      controller.customerBranch.text = value['name'];
                      controller.customerBranchId.value = key;
                      controller.isJobModified.value = true;
                    },
                    onDelete: () {
                      controller.customerBranch.clear();
                      controller.customerBranchId.value = "";
                      controller.isJobModified.value = true;
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
                    focusNode: controller.focusNodeForCustomerDetails7,
                    nextFocusNode: controller.focusNodeForCustomerDetails8,

                    width: 170,
                    textcontroller: controller.customerCurrency.value.text,
                    hintText: 'Currency',
                    showedSelectedName: 'currency_code',
                    onChanged: (key, value) {
                      controller.customerCurrency.text = value['currency_code'];
                      controller.customerCurrencyId.value = key;
                      controller.customerCurrencyRate.text =
                          (value['rate'] ?? '1').toString();
                      controller.isJobModified.value = true;
                    },
                    onDelete: () {
                      controller.customerCurrency.clear();
                      controller.customerCurrencyId.value = "";
                      controller.customerCurrencyRate.clear();
                      controller.isJobModified.value = true;
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
                    focusNode: controller.focusNodeForCustomerDetails8,
                    width: 100,
                    isDouble: true,
                    controller: controller.customerCurrencyRate,
                    labelText: 'Rate',
                    hintText: 'Enter Rate',
                    onChanged: (_) {
                      controller.isJobModified.value = true;
                    },
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text('Payment Type', style: textFieldLabelStyle),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
