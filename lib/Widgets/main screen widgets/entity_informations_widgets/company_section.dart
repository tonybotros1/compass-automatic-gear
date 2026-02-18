import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';

Container companySection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: containerDecor,
    child: Column(
      children: [
        GetX<EntityInformationsController>(
          builder: (controller) {
            return myTextFormFieldWithBorder(
              controller: controller.groupName,
              labelText: 'Group Name',
            );
          },
        ),
        const SizedBox(height: 15),
        GetX<EntityInformationsController>(
          builder: (controller) {
            return Row(
              spacing: 10,
              children: [
                Expanded(
                  child: MenuWithValues(
                    labelText: 'Industry',
                    headerLqabel: 'Industries',
                    dialogWidth: 600,
                    controller: controller.industry.value,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onOpen: () {
                      return controller.getIndustries();
                    },
                    onDelete: () {
                      controller.industry.value.clear();
                      controller.industryId.value = '';
                    },
                    onSelected: (value) async {
                      controller.industry.value.text = '${value['name']}';
                      controller.industryId.value = value['_id'];
                    },
                  ),
                ),
                Expanded(
                  child: myTextFormFieldWithBorder(
                    labelText: 'Tax Registration Number',
                    controller: controller.trn,
                  ),
                ),
                Expanded(
                  child: MenuWithValues(
                    labelText: 'Entity Type',
                    headerLqabel: 'Entity Types',
                    dialogWidth: 600,
                    controller: controller.entityType.value,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onOpen: () {
                      return controller.getEntityType();
                    },
                    onDelete: () {
                      controller.entityType.value.clear();
                      controller.entityTypeId.value = '';
                    },
                    onSelected: (value) async {
                      controller.entityType.value.text = '${value['name']}';
                      controller.entityTypeId.value = value['_id'];
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
