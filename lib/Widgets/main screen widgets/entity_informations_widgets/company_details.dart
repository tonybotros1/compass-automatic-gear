
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';

Widget companyDetails(
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
                icon: Icon(
                  Icons.apartment,
                  color: Colors.grey,
                ),
                obscureText: false,
                controller: controller.groupName,
                labelText: 'Group Name',
                hintText: 'Enter Group Name',
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
                  textController: controller.typrOfBusiness.value,
                  onSelected: (suggestion) {
                    controller.typrOfBusiness.value.text =
                        '${suggestion['name']}';
                    controller.typeOfBusinessMap.entries.where((entry) {
                      return entry.value['name'] ==
                          suggestion['name'].toString();
                    }).forEach((entry) {
                      controller.typrOfBusinessId.value = entry.key;
                    });
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text('${suggestion['name']}'),
                    );
                  },
                  labelText: 'Type Of Business',
                  hintText: 'Select Type Of Business',
                  menus: controller.typeOfBusinessMap.isNotEmpty
                      ? controller.typeOfBusinessMap
                      : {},
                  validate: false,
                  controller: controller,
                );
              }),
              SizedBox(
                height: 20,
              ),
              myTextFormField2(
                icon: Icon(
                  Icons.currency_exchange,
                  color: Colors.grey,
                ),
                obscureText: false,
                controller: controller.trn,
                labelText: 'Transaction Reference Number',
                hintText: 'Enter TRN',
                validate: true,
              ),
              SizedBox(
                height: 20,
              ),
              GetX<EntityInformationsController>(builder: (controller) {
                return dropDownValues(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.grey,
                  ),
                  textController: controller.entityType.value,
                  onSelected: (suggestion) {
                    controller.entityType.value.text = '${suggestion['name']}';
                    controller.entityTypeMap.entries.where((entry) {
                      return entry.value['name'] ==
                          suggestion['name'].toString();
                    }).forEach((entry) {
                      controller.entityTypeId.value = entry.key;
                    });
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text('${suggestion['name']}'),
                    );
                  },
                  labelText: 'Entity Type',
                  hintText: 'Select Entity Type',
                  menus: controller.entityTypeMap.isNotEmpty
                      ? controller.entityTypeMap
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
                onPressed: () {},
                child: const Text('Next')))
      ],
    ),
  );
}