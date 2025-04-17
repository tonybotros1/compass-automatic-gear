import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Trading Controllers/car_trading_controller.dart';

Widget addNewItemOrEdit({
  required BuildContext context,
  required CarTradingController controller,
  required bool canEdit,
}) {
  return GetX<CarTradingController>(builder: (controller) {
    bool isItemsLoading = controller.allItems.isEmpty;
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: myTextFormFieldWithBorder(
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.selectDateContext(
                            context, controller.itemDate);
                      },
                      icon: const Icon(Icons.date_range)),
                  validate: true,
                  controller: controller.itemDate,
                  labelText: 'Date',
                  isDate: true),
            ),
            Expanded(flex: 3, child: SizedBox())
          ],
        ),
        CustomDropdown(
          validator: true,
          textcontroller: controller.item.text,
          showedSelectedName: 'name',
          hintText: 'Item',
          items: isItemsLoading ? {} : controller.allItems,
          itemBuilder: (context, key, value) {
            return ListTile(
              title: Text(value['name']),
            );
          },
          onChanged: (key, value) {
            controller.item.text = value['name'];
            controller.itemId.value = key;
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
                    validate: true,
                    controller: controller.pay,
                    labelText: 'Paid',
                    isDouble: true)),
            Expanded(flex: 3, child: SizedBox())
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
                    validate: true,
                    controller: controller.receive,
                    labelText: 'Received',
                    isDouble: true)),
            Expanded(flex: 3, child: SizedBox())
          ],
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
            controller: controller.comments.value,
            labelText: 'Comments',
            maxLines: 7),
      ],
    );
  });
}
