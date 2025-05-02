import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          CustomDropdown(
            showedSelectedName: 'entity_name',
            textcontroller: controller.customerName.text,
            hintText: 'Customer',
            items: isCustomersLoading ? {} : controller.allCustomers,
            onChanged: (key, value) {
              controller.customerName.text = value['entity_name'];
              controller.onSelectForCustomers(key);

              controller.customerId.value = key;
            },
          ),
          Row(
            children: [
              Expanded(
                  child: myTextFormFieldWithBorder(
                controller: controller.customerEntityName,
                labelText: 'Contact Name',
                hintText: 'Enter Contact Name',
              )),
              Expanded(child: SizedBox())
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: myTextFormFieldWithBorder(
                controller: controller.customerEntityPhoneNumber,
                labelText: 'Contact Number',
                hintText: 'Enter Contact Number',
              )),
              Expanded(child: SizedBox())
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
              Expanded(child: SizedBox())
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  child: myTextFormFieldWithBorder(
                isnumber: true,
                controller: controller.customerCreditNumber,
                labelText: 'Credit Limit',
                hintText: 'Enter Credit Limit',
              )),
              Expanded(
                  child: myTextFormFieldWithBorder(
                isnumber: true,
                controller: controller.customerOutstanding,
                labelText: 'Outstanding',
                hintText: 'Enter Outstanding',
              )),
              Expanded(flex: 2, child: SizedBox())
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
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
              Expanded(child: SizedBox())
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
              Expanded(flex: 2, child: SizedBox())
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
              Expanded(flex: 2, child: SizedBox())
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  'Payment',
                  style: textFieldLabelStyle,
                ),
              ),
              Container(
                width: 160,
                height: textFieldHeight,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CupertinoRadio<bool>(
                          value: true,
                          groupValue: controller.isCashSelected.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectCashOrCredit('cash', value);
                            }
                          },
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          'Cash',
                          style: textFieldFontStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        CupertinoRadio<bool>(
                          value: true,
                          groupValue: controller.isCreditSelected.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectCashOrCredit('credit', value);
                            }
                          },
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          'Credit',
                          style: textFieldFontStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }),
  );
}
