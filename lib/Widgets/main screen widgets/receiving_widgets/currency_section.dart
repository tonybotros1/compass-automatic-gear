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
              child: GetBuilder<ReceivingController>(
                builder: (controller) {
                  return CustomDropdown(
                    textcontroller: controller.currency.value.text,
                    hintText: 'Currency',
                    showedSelectedName: 'currency_code',
                    onChanged: (key, value) {
                      controller.currency.value.text = value['currency_code'];
                      controller.currencyId.value = key;
                      controller.rate.value.text = (value['rate'] ?? '1')
                          .toString();
                      controller.isReceivingModified.value = true;
                    },
                    onDelete: () {
                      controller.currency.value.clear();
                      controller.currencyId.value = '';
                      controller.rate.value.clear();
                      controller.isReceivingModified.value = true;
                    },
                    onOpen: () {
                      return controller.getCurrencies();
                    },
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                addNewValueToScreenButtonDialog(
                  screenName: '💴 Currencies',
                  widget: const Currency(),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            labelText: 'Rate',
            controller: controller.rate.value,
            isDouble: true,
            onChanged: (_) {
              controller.isReceivingModified.value = true;
            },
          ),
        ),
      ],
    ),
  );
}
