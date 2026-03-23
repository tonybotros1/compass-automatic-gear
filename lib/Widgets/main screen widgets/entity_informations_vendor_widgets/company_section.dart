import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_vendor_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';

Container companySectionForVendors() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: containerDecor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<EntityInformationsVendorController>(
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

        const SizedBox(height: 15),
        GetBuilder<EntityInformationsVendorController>(
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


// Container(
                      //   height: 35,
                      //   width: 160,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(4),
                      //     border: Border.all(color: Colors.grey),
                      //     color: Colors.white,
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: CupertinoCheckbox(
                      //           value: controller.lpoReq.value,
                      //           onChanged: (value) {
                      //             controller.lpoReq.value = value!;
                      //           },
                      //         ),
                      //       ),
                      //       Text('LPO Required', style: textFieldFontStyle),
                      //     ],
                      //   ),
                      // ),



                  //      GetX<EntityInformationsVendorController>(
                  //   builder: (controller) {
                  //     return MenuWithValues(
                  //       labelText: 'Salesman',
                  //       headerLqabel: 'Salesmen',
                  //       dialogWidth: 600,
                  //       width: 200,
                  //       controller: controller.salesMAn.value,
                  //       displayKeys: const ['name'],
                  //       displaySelectedKeys: const ['name'],
                  //       onOpen: () {
                  //         return controller.getSalesMan();
                  //       },
                  //       onDelete: () {
                  //         controller.salesMAn.value.clear();
                  //         controller.salesManId.value = '';
                  //       },
                  //       onSelected: (value) async {
                  //         controller.salesMAn.value.text = '${value['name']}';
                  //         controller.salesManId.value = value['_id'];
                  //       },
                  //     );
                  //   },
                  // ),
                  // GetBuilder<EntityInformationsVendorController>(
                  //   builder: (controller) {
                  //     return myTextFormFieldWithBorder(
                  //       width: 160,
                  //       controller: controller.warrantyDays,
                  //       isnumber: true,
                  //       labelText: 'Warranty Days',
                  //     );
                  //   },
                  // ),