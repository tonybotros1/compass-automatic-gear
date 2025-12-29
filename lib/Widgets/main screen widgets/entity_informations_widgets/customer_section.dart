import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import 'image_section.dart';

Container customerSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: containerDecor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetBuilder<EntityInformationsController>(
                builder: (controller) {
                  return myTextFormFieldWithBorder(
                    width: 520,
                    obscureText: false,
                    controller: controller.entityName,
                    labelText: 'Name',
                    hintText: 'Enter Entity Name',
                    validate: true,
                  );
                },
              ),
              Row(
                spacing: 10,
                children: [
                  GetX<EntityInformationsController>(
                    builder: (controller) {
                      return myTextFormFieldWithBorder(
                        width: 150,
                        isEnabled: controller.isCustomerSelected.isTrue,
                        isDouble: true,
                        obscureText: false,
                        controller: controller.creditLimit,
                        labelText: 'Credit Limit',
                        hintText: 'Enter Credit Limit',
                        validate: true,
                      );
                    },
                  ),
                  GetX<EntityInformationsController>(
                    builder: (controller) {
                      return CustomDropdown(
                        enabled: controller.isCustomerSelected.isTrue,
                        width: 200,
                        hintText: 'Salesman',
                        textcontroller: controller.salesMAn.value.text,
                        showedSelectedName: 'name',
                        onChanged: (key, value) {
                          controller.salesMAn.value.text = '${value['name']}';
                          controller.salesManId.value = key;
                        },
                        onDelete: () {
                          controller.salesMAn.value.clear();
                          controller.salesManId.value = '';
                        },
                        onOpen: () {
                          return controller.getSalesMan();
                        },
                      );
                    },
                  ),
                  GetBuilder<EntityInformationsController>(
                    builder: (controller) {
                      return myTextFormFieldWithBorder(
                        width: 150,
                        controller: controller.warrantyDays,
                        isnumber: true,
                        labelText: 'Warranty Days',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        GetBuilder<EntityInformationsController>(
          builder: (controller) {
            return imageSection(controller);
          },
        ),
      ],
    ),
  );
}
