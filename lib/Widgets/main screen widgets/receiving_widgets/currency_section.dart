import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../../Screens/Main screens/System Administrator/Setup/currency.dart';
import '../../menu_dialog.dart';
import 'add_new_value_for_screen_button.dart';

Widget currencySection(
  BuildContext context,
  ReceivingController controller,
  BoxConstraints constraints,
) {
  return FocusTraversalGroup(
    policy: WidgetOrderTraversalPolicy(),
    child: Container(
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
                    return MenuWithValues(
                      focusNode: controller.focusNode6,
                      nextFocusNode: controller.focusNode7,
                      previousFocusNode: controller.focusNode5,
                      labelText: 'Currency',
                      headerLqabel: 'Currencies',
                      dialogWidth: 400,
                      controller: controller.currency.value,
                      displayKeys: const ['currency_code'],
                      displaySelectedKeys: const ['currency_code'],
                      onOpen: () {
                        return controller.getCurrencies();
                      },
                      onDelete: () {
                        controller.currency.value.clear();
                        controller.currencyId.value = '';
                        controller.rate.value.clear();
                        controller.isReceivingModified.value = true;
                      },
                      onSelected: (value) {
                        controller.currency.value.text = value['currency_code'];
                        controller.currencyId.value = value['_id'];
                        controller.rate.value.text = (value['rate'] ?? '1')
                            .toString();
                        controller.isReceivingModified.value = true;
                      },
                    );
                  },
                ),
              ),
              ExcludeFocus(
                child: IconButton(
                  onPressed: () {
                    addNewValueToScreenButtonDialog(
                      screenName: '💴 Currencies',
                      widget: const Currency(),
                    );
                  },
                  icon: const Icon(Icons.add_card),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 150,
            child: myTextFormFieldWithBorder(
              previousFocusNode: controller.focusNode6,
              focusNode: controller.focusNode7,
              nextFocusNode: controller.focusNode8,
              onFieldSubmitted: (_) {
                controller.focusNode8.requestFocus();
              },
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
    ),
  );
}
