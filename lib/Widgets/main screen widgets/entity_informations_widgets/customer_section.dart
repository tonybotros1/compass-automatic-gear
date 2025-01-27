import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';

Widget customerDetails(
    {required EntityInformationsController controller, constraints}) {
  return AnimatedContainer(
    height: 400,
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 300),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              myTextFormField2(
                isnumber: true,
                icon: Icon(
                  Icons.credit_card,
                  color: Colors.grey,
                ),
                obscureText: false,
                controller: controller.creditLimit,
                labelText: 'Credit Limit',
                hintText: 'Enter Credit Limit',
                validate: true,
              ),
              SizedBox(
                height: 20,
              ),
              GetX<EntityInformationsController>(builder: (controller) {
                return dropDownValues(
                  icon: Icon(
                    Icons.receipt_long,
                    color: Colors.grey,
                  ),
                  textController: controller.salesMAn.value,
                  onSelected: (suggestion) {
                    controller.salesMAn.value.text =
                        '${suggestion['name']}';
                    controller.salesManMap.entries.where((entry) {
                      return entry.value['name'] ==
                          suggestion['name'].toString();
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
                  menus: controller.salesManMap.isNotEmpty
                      ? controller.salesManMap
                      : {},
                  validate: false,
                  controller: controller,
                );
              }),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
                style: nextButtonStyle,
                onPressed: () {
                  controller.goToNextMenu();
                },
                child: const Text('Next')))
      ],
    ),
  );
}
