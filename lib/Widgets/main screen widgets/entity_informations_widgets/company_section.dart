import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';

Container companySection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: containerDecor,
    child: Column(
      children: [
        GetX<EntityInformationsController>(
          builder: (controller) {
            return myTextFormFieldWithBorder(
              isEnabled: controller.isCompanySelected.isTrue,
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
                  child: CustomDropdown(
                    enabled: controller.isCompanySelected.isTrue ? true : false,
                    showedSelectedName: 'name',
                    textcontroller: controller.industry.value.text,
                    hintText: 'Industries',
                    onChanged: (key, value) {
                      controller.industry.value.text = '${value['name']}';
                      controller.industryId.value = key;
                    },
                    onDelete: () {
                      controller.industry.value.clear();
                      controller.industryId.value = '';
                    },
                    onOpen: () {
                      return controller.getIndustries();
                    },
                  ),
                ),
                Expanded(
                  child: myTextFormFieldWithBorder(
                    isEnabled: controller.isCompanySelected.isTrue,
                    labelText: 'Tax Registration Number',
                    controller: controller.trn,
                  ),
                ),
                Expanded(
                  child: CustomDropdown(
                    enabled: controller.isCompanySelected.isTrue,
                    showedSelectedName: 'name',
                    textcontroller: controller.entityType.value.text,
                    hintText: 'Entity Type',
                    onChanged: (key, value) {
                      controller.entityType.value.text = '${value['name']}';
                      controller.entityTypeId.value = key;
                    },
                    onDelete: () {
                      controller.entityType.value.clear();
                      controller.entityTypeId.value = '';
                    },
                    onOpen: () {
                      return controller.getEntityType();
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
