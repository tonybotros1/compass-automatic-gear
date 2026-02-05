import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main screen widgets/add_new_values_button.dart';
import '../../../Controllers/Main screen controllers/receiving_controller.dart';

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
                      controller.isReceivingModified.value = true;
                      controller.approvedBy.value.text = value['name'];
                      controller.approvedById.value = key;
                    },
                    onDelete: () {
                      controller.approvedBy.value.clear();
                      controller.approvedById.value = '';
                      controller.isReceivingModified.value = true;
                    },
                    onOpen: () {
                      return controller.getISSUERECEIVEPEOPLE();
                    },
                  ),
                ),
                valSectionInTheTable(
                  controller.listOfValuesController,
                  constraints,
                  'ISSUE_RECEIVE_PEOPLE',
                  'New Value',
                  'People',
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
                      controller.isReceivingModified.value = true;
                    },
                    onDelete: () {
                      controller.orderedBy.value.clear();
                      controller.orderedById.value = '';
                      controller.isReceivingModified.value = true;
                    },
                    onOpen: () {
                      return controller.getISSUERECEIVEPEOPLE();
                    },
                  ),
                ),
                valSectionInTheTable(
                  controller.listOfValuesController,
                  constraints,
                  'ISSUE_RECEIVE_PEOPLE',
                  'New Value',
                  'People',
                ),
                // IconButton(
                //   onPressed: () {
                //     addNewValueToScreenButtonDialog(
                //       screenName: '🌿 Employees',
                //       widget: const Employees(),
                //     );
                //   },
                //   icon: const Icon(Icons.add),
                // ),
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
                      controller.isReceivingModified.value = true;
                    },
                    onDelete: () {
                      controller.purchasedBy.value.clear();
                      controller.purchasedById.value = '';
                      controller.isReceivingModified.value = true;
                    },
                    onOpen: () {
                      return controller.getISSUERECEIVEPEOPLE();
                    },
                  ),
                ),
                valSectionInTheTable(
                  controller.listOfValuesController,
                  constraints,
                  'ISSUE_RECEIVE_PEOPLE',
                  'New Value',
                  'People',
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
