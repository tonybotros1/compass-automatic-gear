import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';

Container customerSection() {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5)),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: GetX<EntityInformationsController>(builder: (controller) {
                return myTextFormFieldWithBorder(
                  isEnabled: controller.isCustomerSelected.isTrue,
                  isnumber: true,
                  obscureText: false,
                  controller: controller.creditLimit,
                  labelText: 'Credit Limit',
                  hintText: 'Enter Credit Limit',
                  validate: true,
                );
              }),
            ),
            Expanded(flex: 3, child: SizedBox())
          ],
        ),
        SizedBox(
          height: 15,
        ),
        GetX<EntityInformationsController>(builder: (controller) {
          return dropDownValues(
            textController: controller.salesMAn.value,
            onSelected: (suggestion) {
              controller.salesMAn.value.text = '${suggestion['name']}';
              controller.salesManMap.entries.where((entry) {
                return entry.value['name'] == suggestion['name'].toString();
              }).forEach((entry) {
                controller.salesManId.value = entry.key;
              });
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text('${suggestion['name']}'),
              );
            },
            labelText: 'Sales Man',
            hintText: 'Select Sale Man',
            menus: controller.isCustomerSelected.isTrue
                ? controller.salesManMap.isNotEmpty
                    ? controller.salesManMap
                    : {}
                : {},
            validate: false,
            controller: controller,
          );
        }),
      ],
    ),
  );
}
