import 'package:datahubai/Models/dynamic_field_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Container companySection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: containerDecor,
    child: Column(
      children: [
        GetX<EntityInformationsController>(
          builder: (controller) {
            return dynamicFields(
              dynamicConfigs: [
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
              ],
            );
          },
        ),
        const SizedBox(height: 15),
        GetX<EntityInformationsController>(
          builder: (controller) {
            return dynamicFields(
              dynamicConfigs: [
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
                    onSelected: (key, value) {
                      controller.industry.value.text = '${value['name']}';
                      controller.industryId.value = key;
                    },
                    onDelete: () {
                      controller.industry.value.clear();
                      controller.industryId.value = '';
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
                    onSelected: (key, value) {
                      controller.entityType.value.text = '${value['name']}';
                      controller.entityTypeId.value = key;
                    },
                    onDelete: () {
                      controller.entityType.value.clear();
                      controller.entityTypeId.value = '';
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}
