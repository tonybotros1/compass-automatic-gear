import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
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
              GetX<EntityInformationsController>(
                builder: (controller) {
                  return Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      myTextFormFieldWithBorder(
                        width: 360,
                        obscureText: false,
                        controller: controller.entityName,
                        labelText: 'Name',
                        validate: true,
                      ),
                      Container(
                        height: 35,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            CupertinoCheckbox(
                              value: controller.lpoReq.value,
                              onChanged: (value) {
                                controller.lpoReq.value = value!;
                              },
                            ),
                            Text('LPO Required', style: textFieldFontStyle),
                          ],
                        ),
                      ),
                    ],
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
                        validate: true,
                      );
                    },
                  ),
                  GetX<EntityInformationsController>(
                    builder: (controller) {
                      return MenuWithValues(
                        labelText: 'Salesman',
                        headerLqabel: 'Salesmen',
                        dialogWidth: 600,
                        width: 200,
                        controller: controller.salesMAn.value,
                        displayKeys: const ['name'],
                        displaySelectedKeys: const ['name'],
                        onOpen: () {
                          return controller.getSalesMan();
                        },
                        onDelete: () {
                          controller.salesMAn.value.clear();
                          controller.salesManId.value = '';
                        },
                        onSelected: (value) async {
                          controller.salesMAn.value.text = '${value['name']}';
                          controller.salesManId.value = value['_id'];
                        },
                      );
                    },
                  ),
                  GetBuilder<EntityInformationsController>(
                    builder: (controller) {
                      return myTextFormFieldWithBorder(
                        width: 160,
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
