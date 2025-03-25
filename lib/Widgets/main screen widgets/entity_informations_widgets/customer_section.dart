import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import 'image_section.dart';

Container customerSection() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Row(
      children: [
        Expanded(
          child: Column(
            children: [
              GetBuilder<EntityInformationsController>(builder: (controller) {
                return myTextFormFieldWithBorder(
                  obscureText: false,
                  controller: controller.entityName,
                  labelText: 'Name',
                  hintText: 'Enter Entity Name',
                  validate: true,
                );
              }),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GetX<EntityInformationsController>(
                        builder: (controller) {
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
                  const Expanded(flex: 3, child: SizedBox())
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GetX<EntityInformationsController>(builder: (controller) {
                return CustomDropdown(
                  hintText: 'Sales Man',
                  textcontroller: controller.salesMAn.value.text,
                  showedSelectedName: 'name',
                  items: controller.isCustomerSelected.isTrue
                      ? controller.salesManMap.isNotEmpty
                          ? controller.salesManMap
                          : {}
                      : {},
                  itemBuilder: (context, key, value) {
                    return ListTile(title: Text(value['name']));
                  },
                  onChanged: (key, value) {
                    controller.salesMAn.value.text = '${value['name']}';
                    controller.salesManId.value = key;
                  },
                );
              }),
            ],
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        GetBuilder<EntityInformationsController>(builder: (controller) {
          return imageSection(controller);
        }),
      ],
    ),
  );
}
