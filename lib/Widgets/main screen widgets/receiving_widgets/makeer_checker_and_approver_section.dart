import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../Trade screen widgets/car_information_section.dart';
import '../lists_widgets/values_section_in_list_of_values.dart';

Container makerCheckerAndApproverSection(
  BuildContext context,
  ReceivingController controller,
  BoxConstraints constraints,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<ReceivingController>(
      builder: (controller) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomDropdown(
                    textcontroller: controller.approvedBy.value.text,
                    showedSelectedName: 'name',
                    hintText: 'Approved By',
                    onChanged: (key, value) {
                      controller.approvedBy.value.text = value['name'];
                      controller.approvedById.value = key;
                    },
                    onDelete: () {
                      controller.approvedBy.value.clear();
                      controller.approvedById.value = '';
                    },
                    onOpen: () {
                      return controller.getApprovedBy();
                    },
                  ),
                ),
                valSectionInTheTable(
                  controller.listOfValuesController,
                  controller.approvedByListId.value,
                  context,
                  constraints,
                  controller.approvedByMasterId.value,
                  'New Approved By',
                  '✅ Approved By',
                  valuesSection(constraints: constraints, context: context),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomDropdown(
                    textcontroller: controller.orderedBy.value.text,

                    showedSelectedName: 'name',
                    hintText: 'Ordered By',
                    onChanged: (key, value) {
                      controller.orderedBy.value.text = value['name'];
                      controller.orderedById.value = key;
                    },
                    onDelete: () {
                      controller.orderedBy.value.clear();
                      controller.orderedById.value = '';
                    },
                    onOpen: () {
                      return controller.getOrderedBy();
                    },
                  ),
                ),
                valSectionInTheTable(
                  controller.listOfValuesController,
                  controller.orderedByListId.value,
                  context,
                  constraints,
                  controller.orderedByMasterId.value,
                  'New Ordered By',
                  '📜 Ordered By',
                  valuesSection(constraints: constraints, context: context),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.purchasedBy.value.text,

                    hintText: 'Purchased By',

                    onChanged: (key, value) {
                      controller.purchasedBy.value.text = value['name'];
                      controller.purchasedById.value = key;
                    },
                    onDelete: () {
                      controller.purchasedBy.value.clear();
                      controller.purchasedById.value = '';
                    },
                    onOpen: () {
                      return controller.getPurchasedBy();
                    },
                  ),
                ),
                valSectionInTheTable(
                  controller.listOfValuesController,
                  controller.purchasedByListId.value,
                  context,
                  constraints,
                  controller.purchasedByMasterId.value,
                  'New Purchased By',
                  '💵 Purchased By',
                  valuesSection(constraints: constraints, context: context),
                 
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
