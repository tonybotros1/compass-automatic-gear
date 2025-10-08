import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget customerDetailsSection() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<JobCardController>(
      builder: (controller) {
        var isCustomersLoading = controller.allCustomers.isEmpty;
        final isBranchesLoading = controller.allBranches.isEmpty;
        final isCurrenciesLoading = controller.allCurrencies.isEmpty;
        final isSalesManLoading = controller.salesManMap.isEmpty;
        return FocusTraversalGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: FocusTraversalOrder(
                      order: const NumericFocusOrder(1),
                      child: Focus(
                        child: CustomDropdown(
                          showedSelectedName: 'entity_name',
                          textcontroller: controller.customerName.text,
                          hintText: 'Customer',
                          items: isCustomersLoading
                              ? {}
                              : controller.allCustomers,
                          onChanged: (key, value) {
                            controller.customerName.text = value['entity_name'];
                            controller.onSelectForCustomers(value);
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
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.dialog(
                        barrierDismissible: false,
                        Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                                          style:
                                              fontStyleForScreenNameUsedInButtons,
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
                  ),
                ],
              ),
              FocusTraversalOrder(
                order: const NumericFocusOrder(2),
                child: myTextFormFieldWithBorder(
                  width: 250,
                  controller: controller.customerEntityName,
                  labelText: 'Contact Name',
                  hintText: 'Enter Contact Name',
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
              ),
              FocusTraversalOrder(
                order: const NumericFocusOrder(3),
                child: myTextFormFieldWithBorder(
                  width: 250,
                  controller: controller.customerEntityPhoneNumber,
                  labelText: 'Contact Number',
                  hintText: 'Enter Contact Number',
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
              ),
              myTextFormFieldWithBorder(
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
                  child: CustomDropdown(
                    width: 250,
                    showedSelectedName: 'name',
                    textcontroller: controller.customerSaleMan.value,
                    hintText: 'Salesman',
                    items: isSalesManLoading ? {} : controller.salesManMap,
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
                  ),
                ),
              ),
              CustomDropdown(
                width: 170,
                showedSelectedName: 'name',
                textcontroller: controller.customerBranch.text,
                hintText: 'Branch',
                items: isBranchesLoading ? {} : controller.allBranches,
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
              ),
              Row(
                spacing: 10,
                children: [
                  CustomDropdown(
                    width: 170,
                    textcontroller: controller.customerCurrency.value.text,
                    hintText: 'Currency',
                    items: isCurrenciesLoading ? {} : controller.allCurrencies,
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
                  ),
                  myTextFormFieldWithBorder(
                    width: 100,
                    isDouble: true,
                    controller: controller.customerCurrencyRate,
                    labelText: 'Rate',
                    hintText: 'Enter Rate',
                    onChanged: (_) {
                      controller.isJobModified.value = true;
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          'Payment Method',
                          style: textFieldLabelStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 35,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey.shade200,
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
                                activeColor: Colors.white,
                              ),
                              Text('Cash', style: textFieldFontStyle),
                              CupertinoRadio<String>(
                                value: 'Credit',
                                fillColor: mainColor,
                                activeColor: Colors.white,
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
