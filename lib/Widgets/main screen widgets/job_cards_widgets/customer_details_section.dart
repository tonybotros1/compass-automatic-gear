import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Widget customerDetailsSection() {
  return GetX<JobCardController>(builder: (controller) {
    var isCustomersLoading = controller.allCustomers.isEmpty;
    final isBranchesLoading = controller.allBranches.isEmpty;
    final isCurrenciesLoading = controller.allCurrencies.isEmpty;
    final isSalesManLoading = controller.salesManMap.isEmpty;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: containerDecor,
      child: Column(
        children: [
          dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: true,
              flex: 3,
              dropdownConfig: DropdownConfig(
                showedSelectedName: 'entity_name',
                textController: controller.customerName.text,
                hintText: isCustomersLoading ? 'Loading...' : 'Customer',
                menuValues: isCustomersLoading ? {} : controller.allCustomers,
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text('${value['entity_name']}'),
                  );
                },
                onSelected: (key, value) {
                  controller.customerName.text = value['entity_name'];
                  controller.onSelectForCustomers(key);

                  controller.customerId.value = key;
                },
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 2,
              fieldConfig: FieldConfig(
                textController: controller.customerEntityName,
                labelText: 'Contact Name',
                hintText: 'Enter Contact Name',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 2,
              fieldConfig: FieldConfig(
                textController: controller.customerEntityPhoneNumber,
                labelText: 'Contact Number',
                hintText: 'Enter Contact Number',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 2,
              fieldConfig: FieldConfig(
                textController: controller.customerEntityEmail,
                labelText: 'Contact Email',
                hintText: 'Enter Contact Email',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                isnumber: true,
                textController: controller.customerCreditNumber,
                labelText: 'Credit Limit',
                hintText: 'Enter Credit Limit',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                isnumber: true,
                textController: controller.customerOutstanding,
                labelText: 'Outstanding',
                hintText: 'Enter Outstanding',
                validate: false,
              ),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: dynamicFields(dynamicConfigs: [
                  DynamicConfig(
                    isDropdown: true,
                    flex: 2,
                    dropdownConfig: DropdownConfig(
                      showedSelectedName: 'name',
                      textController: controller.customerSaleMan.value,
                      hintText: isSalesManLoading ? 'Loading...' : 'Sales Man',
                      menuValues:
                          isSalesManLoading ? {} : controller.salesManMap,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text('${value['name']}'),
                        );
                      },
                      onSelected: (key, value) {
                        controller.customerSaleMan.value = value['name'];
                        controller.customerSaleManId.value = key;
                      },
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 1,
                    dropdownConfig: DropdownConfig(
                      showedSelectedName: 'name',
                      textController: controller.customerBranch.text,
                      hintText: isBranchesLoading ? 'Loading...' : 'Branch',
                      menuValues:
                          isBranchesLoading ? {} : controller.allBranches,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text('${value['name']}'),
                        );
                      },
                      onSelected: (key, value) {
                        controller.customerBranch.text = value['name'];
                        controller.customerBranchId.value = key;
                      },
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 1,
                    dropdownConfig: DropdownConfig(
                      showedResult: (key, value) {
                        return Text(controller.getdataName(
                            value['country_id'], controller.allCountries,
                            title: 'currency_code'));
                      },
                      textController: controller.customerCurrency.value.text,
                      hintText: isCurrenciesLoading ? 'Loading...' : 'Currency',
                      menuValues:
                          isCurrenciesLoading ? {} : controller.allCurrencies,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text(controller.getdataName(
                              value['country_id'], controller.allCountries,
                              title: 'currency_code')),
                        );
                      },
                      onSelected: (key, value) {
                        controller.customerCurrency.text =
                            controller.getdataName(
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
                  DynamicConfig(
                    isDropdown: false,
                    flex: 1,
                    fieldConfig: FieldConfig(
                      isDouble: true,
                      textController: controller.customerCurrencyRate,
                      labelText: 'Rate',
                      hintText: 'Enter Rate',
                      validate: false,
                    ),
                  ),
                ]),
              ),
              SizedBox(
                width: 5,
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
                    height: textFieldHeight,
                    padding: EdgeInsets.only(left: 10, right: 10),
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
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              'Cash',
                              style: textFieldFontStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            CupertinoRadio<bool>(
                              value: true,
                              groupValue: controller.isCreditSelected.value,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.selectCashOrCredit(
                                      'credit', value);
                                }
                              },
                            ),
                            SizedBox(
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
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  });
}
