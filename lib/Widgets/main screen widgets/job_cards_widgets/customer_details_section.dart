import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Container customerDetailsSection() {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: containerDecor,
    child: Column(
      children: [
        GetX<JobCardController>(builder: (controller) {
          var isCustomersLoading = controller.allCustomers.isEmpty;

          return dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: true,
              flex: 3,
              dropdownConfig: DropdownConfig(
                listValues: controller.allCustomers.values
                    .map((value) => value['entity_name'].toString())
                    .toList(),
                textController: controller.customerName,
                labelText: isCustomersLoading ? 'Loading...' : 'Customer',
                hintText: 'Select Customer',
                menuValues: isCustomersLoading ? {} : controller.allCustomers,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['entity_name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.customerName.text = suggestion['entity_name'];
                  controller.allCustomers.entries.where((entry) {
                    return entry.value['entity_name'] ==
                        suggestion['entity_name'].toString();
                  }).forEach(
                    (entry) {
                      controller.onSelectForCustomers(entry.key);

                      controller.customerId.value = entry.key;
                    },
                  );
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
          ]);
        }),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: GetX<JobCardController>(builder: (controller) {
                final isBranchesLoading = controller.allBranches.isEmpty;
                final isCurrenciesLoading = controller.allCurrencies.isEmpty;
                final isSalesManLoading = controller.salesManMap.isEmpty;

                return dynamicFields(dynamicConfigs: [
                  DynamicConfig(
                    isDropdown: true,
                    flex: 2,
                    dropdownConfig: DropdownConfig(
                      listValues: controller.salesManMap.values
                          .map((value) => value['name'].toString())
                          .toList(),
                      textController: controller.customerSaleMan,
                      labelText: isSalesManLoading ? 'Loading...' : 'Sales Man',
                      hintText: 'Select Sales Man',
                      menuValues:
                          isSalesManLoading ? {} : controller.salesManMap,
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text('${suggestion['name']}'),
                        );
                      },
                      onSelected: (suggestion) {
                        controller.customerSaleMan.text = suggestion['name'];
                        controller.salesManMap.entries.where((entry) {
                          return entry.value['name'] ==
                              suggestion['name'].toString();
                        }).forEach(
                          (entry) {
                            controller.customerSaleManId.value = entry.key;
                          },
                        );
                      },
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 1,
                    dropdownConfig: DropdownConfig(
                      listValues: controller.allBranches.values
                          .map((value) => value['name'].toString())
                          .toList(),
                      textController: controller.customerBranch,
                      labelText: isBranchesLoading ? 'Loading...' : 'Branch',
                      hintText: 'Select Branch',
                      menuValues:
                          isBranchesLoading ? {} : controller.allBranches,
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text('${suggestion['name']}'),
                        );
                      },
                      onSelected: (suggestion) {
                        controller.customerBranch.text = suggestion['name'];
                        controller.allBranches.entries.where((entry) {
                          return entry.value['name'] ==
                              suggestion['name'].toString();
                        }).forEach(
                          (entry) {
                            controller.customerBranchId.value = entry.key;
                          },
                        );
                      },
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 1,
                    dropdownConfig: DropdownConfig(
                      listValues: controller.allCurrencies.values
                          .map((value) => controller.getdataName(
                              value['country_id'], controller.allCountries,
                              title: 'currency_code'))
                          .toList(),
                      textController: controller.customerCurrency,
                      labelText:
                          isCurrenciesLoading ? 'Loading...' : 'Currency',
                      hintText: 'Select Currency',
                      menuValues:
                          isCurrenciesLoading ? {} : controller.allCurrencies,
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(controller.getdataName(
                              suggestion['country_id'], controller.allCountries,
                              title: 'currency_code')),
                        );
                      },
                      onSelected: (suggestion) {
                        controller.customerCurrency.text =
                            controller.getdataName(
                          suggestion['country_id'],
                          controller.allCountries,
                          title: 'currency_code',
                        );
                        final entry =
                            controller.allCurrencies.entries.firstWhere(
                          (entry) =>
                              entry.value['country_id'] ==
                              suggestion['country_id'].toString(),
                        );

                        controller.customerCurrencyId.value = entry.key;
                        controller.customerCurrencyRate.text =
                            (entry.value['rate'] ?? '1').toString();
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
                ]);
              }),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GetX<JobCardController>(builder: (controller) {
                        return CupertinoRadio<bool>(
                          value: true,
                          groupValue: controller.isCashSelected.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectCashOrCredit('cash', value);
                            }
                          },
                        );
                      }),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        'Cash',
                        style: regTextStyle,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      GetX<JobCardController>(builder: (controller) {
                        return CupertinoRadio<bool>(
                          value: true,
                          groupValue: controller.isCreditSelected.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectCashOrCredit('credit', value);
                            }
                          },
                        );
                      }),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        'Credit',
                        style: regTextStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    ),
  );
}
