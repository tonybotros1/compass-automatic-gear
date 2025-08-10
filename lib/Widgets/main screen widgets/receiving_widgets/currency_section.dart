import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/currency.dart';
import 'add_new_value_for_screen_button.dart';

Container currencySection(
  BuildContext context,
  ReceivingController controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 150,
              child: GetX<ReceivingController>(
                builder: (controller) {
                  bool isCurrenciesLoading = controller.allCurrencies.isEmpty;
                  return CustomDropdown(
                    
                    showedResult: (key, value) {
                      return Text(
                        getdataName(
                          value['country_id'],
                          controller.allCountries,
                          title: 'currency_code',
                        ),
                      );
                    },
                    textcontroller: controller.currency.value.text,
                    hintText: 'Currency',
                    items: isCurrenciesLoading ? {} : controller.allCurrencies,
                    itemBuilder: (context, key, value) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Text(
                          getdataName(
                            value['country_id'],
                            controller.allCountries,
                            title: 'currency_code',
                          ),
                        ),
                      );
                    },
                    onChanged: (key, value) {
                      controller.currency.value.text = getdataName(
                        value['country_id'],
                        controller.allCountries,
                        title: 'currency_code',
                      );
                      controller.currencyId.value = key;
                      controller.rate.value.text = (value['rate'] ?? '1')
                          .toString();
                    },
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                addNewValueToScreenButtonDialog(
                  screenName: '💴 Currencies',
                  widget: Currency(),
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            labelText: 'Rate',
            controller: controller.rate.value,
            isDouble: true
          ),
        ),
      ],
    ),
  );
}
