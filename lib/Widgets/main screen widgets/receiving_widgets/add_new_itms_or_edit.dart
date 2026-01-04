import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/inventory_items.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'add_new_value_for_screen_button.dart';
import 'showing_available_items.dart';

Widget addNewitemsOrEdit({
  required ReceivingController controller,
  required BoxConstraints constraints,
}) {
  return SingleChildScrollView(
    child: SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: myTextFormFieldWithBorder(
                  readOnly: true,
                  labelText: 'Item Code',
                  controller: controller.itemCode.value,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.more_horiz_outlined),
                    onPressed: () {
                      controller.allInventeryItems.clear();
                      showingAvailableItemsDialog(
                        screenName: '📜 Inventory Items',
                        constraints: constraints,
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Add New Value',

                onPressed: () {
                  addNewValueToScreenButtonDialog(
                    screenName: '📜 Inventery Items',
                    widget: const InventeryItems(),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          myTextFormFieldWithBorder(
            labelText: 'Item Name',
            isEnabled: false,
            controller: controller.itemName.value,
          ),

          SizedBox(
            width: 150,
            child: myTextFormFieldWithBorder(
              labelText: 'Quantity',
              controller: controller.quantity.value,
              isnumber: true,
              onChanged: (_) {},
            ),
          ),
          SizedBox(
            width: 150,
            child: myTextFormFieldWithBorder(
              labelText: 'Orginal Price',
              controller: controller.orginalPrice.value,
              isDouble: true,
              onChanged: (_) {},
            ),
          ),
          SizedBox(
            width: 150,
            child: myTextFormFieldWithBorder(
              labelText: 'Discount',
              controller: controller.discount.value,
              isDouble: true,
              onChanged: (_) {},
            ),
          ),
          SizedBox(
            width: 150,
            child: myTextFormFieldWithBorder(
              labelText: 'VAT',
              controller: controller.vat.value,
              isDouble: true,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    ),
  );
}
