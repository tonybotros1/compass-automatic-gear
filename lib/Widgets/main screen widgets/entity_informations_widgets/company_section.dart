import 'package:datahubai/Models/dynamic_field_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Container companySection() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    decoration: containerDecor,
    child: Column(
      children: [
        GetX<EntityInformationsController>(builder: (controller) {
          return dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                isEnabled: controller.isCompanySelected.isTrue,
                textController: controller.groupName,
                labelText: 'Group Name',
                hintText: 'Enter Group Name',
                validate: false,
              ),
            ),
          ]);
        }),
        const SizedBox(
          height: 15,
        ),
        GetX<EntityInformationsController>(builder: (controller) {
          return dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                showedSelectedName: 'name',
                textController: controller.industry.value.text,
                hintText: 'Industries',
                menuValues: controller.isCompanySelected.isTrue
                    ? controller.industryMap.isNotEmpty
                        ? controller.industryMap
                        : {}
                    : {},
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text('${value['name']}'),
                  );
                },
                onSelected: (key, value) {
                  controller.industry.value.text = '${value['name']}';
                  controller.industryId.value = key;
                },
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                isEnabled: controller.isCompanySelected.isTrue,
                textController: controller.trn,
                labelText: 'Tax Registration Number',
                hintText: 'Enter TRN',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                showedSelectedName: 'name',
                textController: controller.entityType.value.text,
                hintText: 'Entity Type',
                menuValues: controller.isCompanySelected.isTrue
                    ? controller.entityTypeMap.isNotEmpty
                        ? controller.entityTypeMap
                        : {}
                    : {},
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text('${value['name']}'),
                  );
                },
                onSelected: (key, value) {
                  controller.entityType.value.text = '${value['name']}';
                  controller.entityTypeId.value = key;
                },
              ),
            ),
          ]);
        }),
      ],
    ),
  );
}
