import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:datahubai/Screens/Main%20screens/System%20Administrator/Setup/inventery_items.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'add_new_value_for_screen_button.dart';
import 'showing_available_items.dart';

Widget addNewitemsOrEdit({required ReceivingController controller,required BoxConstraints constraints}) {
  return SingleChildScrollView(
    child: SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 10,
              children: [
                SizedBox(
                  width: 150,
                  child: myTextFormFieldWithBorder(
                    labelText: 'Item Code',
                    controller: controller.itemCode.value,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: myTextFormFieldWithBorder(
                    labelText: 'Item Name',
                    isEnabled: false,
                    controller: controller.itemName.value,
                  ),
                ),
                IconButton(
                  tooltip: 'Selecet Value',
                  onPressed: () {
                    controller.searchForInventeryItems.clear();
                    controller.getAllInventeryItems();
                    showingAvailableItemsDialog(screenName: '📜 Inventery Items',constraints: constraints);
                  },
                  icon: Icon(Icons.more_vert_rounded, color: mainColor),
                ),
                IconButton(
                  tooltip: 'Add New Value',

                  onPressed: () {
                    addNewValueToScreenButtonDialog(
                      screenName: '📜 Inventery Items',
                      widget: InventeryItems(),
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
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

