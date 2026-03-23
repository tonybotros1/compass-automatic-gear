import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            GetBuilder<EntityInformationsController>(
              builder: (controller) {
                return myTextFormFieldWithBorder(
                  width: 150,
                  isDouble: true,
                  obscureText: false,
                  controller: controller.creditLimit,
                  labelText: 'Credit Limit',
                  validate: true,
                );
              },
            ),
            Expanded(
              child: GetX<EntityInformationsController>(
                builder: (controller) {
                  return MenuWithValues(
                    labelText: 'Salesman',
                    headerLqabel: 'Salesmen',
                    dialogWidth: 600,
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
            ),
            GetBuilder<EntityInformationsController>(
              builder: (controller) {
                return myTextFormFieldWithBorder(
                  width: 145,
                  controller: controller.warrantyDays,
                  isnumber: true,
                  labelText: 'Warranty Days',
                );
              },
            ),
            GetBuilder<EntityInformationsController>(
              builder: (controller) {
                return Container(
                  height: 35,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoCheckbox(
                          value: controller.lpoReq.value,
                          onChanged: (value) {
                            controller.lpoReq.value = value!;
                          },
                        ),
                      ),
                      Text('LPO Required', style: textFieldFontStyle),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        GetBuilder<EntityInformationsController>(
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
