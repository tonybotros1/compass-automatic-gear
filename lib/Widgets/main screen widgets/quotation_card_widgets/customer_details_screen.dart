import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget customerDetailsSection() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<QuotationCardController>(builder: (controller) {
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
                        items:
                            isCustomersLoading ? {} : controller.allCustomers,
                        onChanged: (key, value) {
                          controller.customerName.text = value['entity_name'];
                          controller.onSelectForCustomers(key);

                          controller.customerId.value = key;
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
                                borderRadius: BorderRadius.circular(5)),
                            insetPadding: const EdgeInsets.all(8),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
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
                                  const Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: EntityInformations()))
                                ],
                              );
                            }),
                          ));
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FocusTraversalOrder(
                  order: const NumericFocusOrder(2),
                  child: myTextFormFieldWithBorder(
                    controller: controller.customerEntityName,
                    labelText: 'Contact Name',
                    hintText: 'Enter Contact Name',
                  ),
                )),
                const Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FocusTraversalOrder(
                  order: const NumericFocusOrder(3),
                  child: myTextFormFieldWithBorder(
                    controller: controller.customerEntityPhoneNumber,
                    labelText: 'Contact Number',
                    hintText: 'Enter Contact Number',
                  ),
                )),
                const Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: myTextFormFieldWithBorder(
                  controller: controller.customerEntityEmail,
                  labelText: 'Contact Email',
                  hintText: 'Enter Contact Email',
                )),
                const Expanded(child: SizedBox())
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                    child: FocusTraversalOrder(
                  order: const NumericFocusOrder(4),
                  child: myTextFormFieldWithBorder(
                    isEnabled: false,
                    isnumber: true,
                    controller: controller.customerCreditNumber,
                    labelText: 'Credit Limit',
                    hintText: 'Enter Credit Limit',
                  ),
                )),
                Expanded(
                    child: FocusTraversalOrder(
                  order: const NumericFocusOrder(5),
                  child: myTextFormFieldWithBorder(
                    isEnabled: false,
                    isnumber: true,
                    controller: controller.customerOutstanding,
                    labelText: 'Outstanding',
                    hintText: 'Enter Outstanding',
                  ),
                )),
                const Expanded(flex: 2, child: SizedBox())
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FocusTraversalOrder(
                    order: const NumericFocusOrder(6),
                    child: Focus(
                      child: CustomDropdown(
                        showedSelectedName: 'name',
                        textcontroller: controller.customerSaleMan.value,
                        hintText: 'Sales Man',
                        items: isSalesManLoading ? {} : controller.salesManMap,
                        onChanged: (key, value) {
                          controller.customerSaleMan.value = value['name'];
                          controller.customerSaleManId.value = key;
                        },
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.customerBranch.text,
                    hintText: 'Branch',
                    items: isBranchesLoading ? {} : controller.allBranches,
                    onChanged: (key, value) {
                      controller.customerBranch.text = value['name'];
                      controller.customerBranchId.value = key;
                    },
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox())
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomDropdown(
                    showedResult: (key, value) {
                      return Text(controller.getdataName(
                          value['country_id'], controller.allCountries,
                          title: 'currency_code'));
                    },
                    textcontroller: controller.customerCurrency.value.text,
                    hintText: 'Currency',
                    items: isCurrenciesLoading ? {} : controller.allCurrencies,
                    itemBuilder: (context, key, value) {
                      return Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Text(controller.getdataName(
                              value['country_id'], controller.allCountries,
                              title: 'currency_code')));
                    },
                    onChanged: (key, value) {
                      controller.customerCurrency.text = controller.getdataName(
                        value['country_id'],
                        controller.allCountries,
                        title: 'currency_code',
                      );
                      controller.customerCurrencyId.value = key;
                      controller.customerCurrencyRate.text =
                          (value['rate'] ?? '1').toString();
                    },
                  ),
                ),
                Expanded(
                    child: myTextFormFieldWithBorder(
                  isDouble: true,
                  controller: controller.customerCurrencyRate,
                  labelText: 'Rate',
                  hintText: 'Enter Rate',
                )),
                const Expanded(flex: 2, child: SizedBox())
              ],
            ),
          ],
        ),
      );
    }),
  );
}
