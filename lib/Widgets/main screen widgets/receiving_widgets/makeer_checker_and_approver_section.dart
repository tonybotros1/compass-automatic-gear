import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main screen widgets/add_new_values_button.dart';
import '../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../menu_dialog.dart';

Widget makerCheckerAndApproverSection(
  BuildContext context,
  ReceivingController controller,
  BoxConstraints constraints,
) {
  return FocusTraversalGroup(
    policy: WidgetOrderTraversalPolicy(),
    child: Container(
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
                    child: MenuWithValues(
                      focusNode:  controller.focusNode8,
                      labelText: 'Approved By',
                      headerLqabel: 'Approved By',
                      dialogWidth: constraints.maxWidth / 2,
                      controller: controller.approvedBy.value,
                      displayKeys: const ['name'],
                      displaySelectedKeys: const ['name'],
                      onOpen: () {
                        return controller.getISSUERECEIVEPEOPLE();
                      },
                      onDelete: () {
                        controller.approvedBy.value.clear();
                        controller.approvedById.value = '';
                        controller.isReceivingModified.value = true;
                      },
                      onSelected: (value) {
                        controller.isReceivingModified.value = true;
                        controller.approvedBy.value.text = value['name'];
                        controller.approvedById.value = value['_id'];
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
                    child: MenuWithValues(
                      labelText: 'Ordered By',
                      headerLqabel: 'Ordered By',
                      dialogWidth: constraints.maxWidth / 2,
                      controller: controller.orderedBy.value,
                      displayKeys: const ['name'],
                      displaySelectedKeys: const ['name'],
                      onOpen: () {
                        return controller.getISSUERECEIVEPEOPLE();
                      },
                      onDelete: () {
                        controller.orderedBy.value.clear();
                        controller.orderedById.value = '';
                        controller.isReceivingModified.value = true;
                      },
                      onSelected: (value) {
                        controller.orderedBy.value.text = value['name'];
                        controller.orderedById.value = value['_id'];
                        controller.isReceivingModified.value = true;
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
                    child: MenuWithValues(
                      labelText: 'Purchased By',
                      headerLqabel: 'Purchased By',
                      dialogWidth: constraints.maxWidth / 2,
                      controller: controller.purchasedBy.value,
                      displayKeys: const ['name'],
                      displaySelectedKeys: const ['name'],
                      onOpen: () {
                        return controller.getISSUERECEIVEPEOPLE();
                      },
                      onDelete: () {
                        controller.purchasedBy.value.clear();
                        controller.purchasedById.value = '';
                        controller.isReceivingModified.value = true;
                      },
                      onSelected: (value) {
                        controller.purchasedBy.value.text = value['name'];
                        controller.purchasedById.value = value['_id'];
                        controller.isReceivingModified.value = true;
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
    ),
  );
}
