import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_vendor_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import 'image_section.dart';

Container vendorSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: containerDecor,
    child: Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetBuilder<EntityInformationsVendorController>(
                builder: (controller) {
                  return myTextFormFieldWithBorder(
                    width: double.infinity,
                    obscureText: false,
                    controller: controller.entityName,
                    labelText: 'Name',
                    validate: true,
                  );
                },
              ),
              GetBuilder<EntityInformationsVendorController>(
                builder: (controller) {
                  return myTextFormFieldWithBorder(
                    width: double.infinity,
                    controller: controller.groupName,
                    labelText: 'Group Name',
                  );
                },
              ),
            ],
          ),
        ),
        GetBuilder<EntityInformationsVendorController>(
          builder: (controller) {
            return imageSection(controller);
          },
        ),
      ],
    ),
  );
}
