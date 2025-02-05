import 'package:datahubai/Models/dynamic_field_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Container companySection() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    decoration:containerDecor,
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
        SizedBox(
          height: 15,
        ),
        GetX<EntityInformationsController>(builder: (controller) {
          return dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                listValues: controller.industryMap.values
                    .map((value) => value['name'].toString())
                    .toList(),
                textController: controller.industry.value,
                labelText: 'Industries',
                hintText: 'Select Industries',
                menuValues: controller.isCompanySelected.isTrue
                    ? controller.industryMap.isNotEmpty
                        ? controller.industryMap
                        : {}
                    : {},
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.industry.value.text = '${suggestion['name']}';
                  controller.industryMap.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach((entry) {
                    controller.industryId.value = entry.key;
                  });
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
                listValues: controller.entityTypeMap.values
                    .map((value) => value['name'].toString())
                    .toList(),
                textController: controller.entityType.value,
                labelText: 'Entity Type',
                hintText: 'Select Entity Type',
                menuValues: controller.isCompanySelected.isTrue
                    ? controller.entityTypeMap.isNotEmpty
                        ? controller.entityTypeMap
                        : {}
                    : {},
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.entityType.value.text = '${suggestion['name']}';
                  controller.entityTypeMap.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach((entry) {
                    controller.entityTypeId.value = entry.key;
                  });
                },
              ),
            ),
          ]);
        }),
      ],
    ),
  );
}
