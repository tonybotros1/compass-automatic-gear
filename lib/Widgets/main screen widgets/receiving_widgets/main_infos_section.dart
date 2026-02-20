import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Screens/Main screens/System Administrator/Setup/branches.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import 'add_new_value_for_screen_button.dart';

Widget mainInfosSection(
  BuildContext context,
  ReceivingController controller,
  BoxConstraints constraints,
) {
  return FocusTraversalGroup(
    policy: WidgetOrderTraversalPolicy(),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      height: 430,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              myTextFormFieldWithBorder(
                width: 150,
                labelText: 'Number',
                isEnabled: false,
                controller: controller.receivingNumber.value,
              ),
              myTextFormFieldWithBorder(
                focusNode: controller.focusNode1,
                nextFocusNode: controller.focusNode2,
                previousFocusNode: controller.focusNode14,
                width: 150,
                onFieldSubmitted: (_) async {
                  controller.isReceivingModified.value = true;
                  normalizeDate(
                    controller.date.value.text,
                    controller.date.value,
                  );
                  // controller.focusNode2.requestFocus();
                },
                controller: controller.date.value,
                labelText: 'Date',
                suffixIcon: IconButton(
                  onPressed: () {
                    selectDateContext(context, controller.date.value);
                    controller.isReceivingModified.value = true;
                  },
                  icon: const Icon(Icons.date_range),
                ),
                isDate: true,
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GetBuilder<ReceivingController>(
                builder: (controller) {
                  return MenuWithValues(
                    focusNode: controller.focusNode2,
                    nextFocusNode: controller.focusNode3,
                    previousFocusNode: controller.focusNode1,
                    labelText: 'Branch',
                    headerLqabel: 'Branches',
                    dialogWidth: constraints.maxWidth / 3,
                    width: 310,
                    controller: controller.branch.value,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    onOpen: () {
                      return controller.getAllBranches();
                    },
                    onDelete: () {
                      controller.isReceivingModified.value = true;
                      controller.branchId.value = '';
                      controller.branch.value.clear();
                    },
                    onSelected: (value) {
                      controller.isReceivingModified.value = true;
                      controller.branchId.value = value['_id'];
                      controller.branch.value.text = value['name'];
                    },
                  );
                },
              ),
              ExcludeFocus(
                child: IconButton(
                  onPressed: () {
                    addNewValueToScreenButtonDialog(
                      screenName: '🌿 Branches',
                      widget: const Branches(),
                    );
                  },
                  icon: const Icon(Icons.add_card),
                ),
              ),
            ],
          ),
          myTextFormFieldWithBorder(
            focusNode: controller.focusNode3,
            nextFocusNode: controller.focusNode4,
            previousFocusNode: controller.focusNode2,
            width: 310,
            labelText: 'Reference Number',
            controller: controller.referenceNumber.value,
            onChanged: (_) {
              controller.isReceivingModified.value = true;
            },
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Expanded(
                child: GetX<ReceivingController>(
                  builder: (controller) {
                    return MenuWithValues(
                      focusNode: controller.focusNode4,
                      nextFocusNode: controller.focusNode5,
                      previousFocusNode: controller.focusNode3,
                      labelText: 'Vendor',
                      headerLqabel: 'Vendors',
                      dialogWidth: constraints.maxWidth / 2,
                      width: 300,
                      controller: controller.vendor.value,
                      displayKeys: const ['entity_name'],
                      displaySelectedKeys: const ['entity_name'],
                      onOpen: () {
                        return controller.getAllVendors();
                      },
                      onDelete: () {
                        controller.vendor.value.clear();
                        controller.vendorId.value = '';
                        controller.isReceivingModified.value = true;
                      },
                      onSelected: (value) {
                        controller.isReceivingModified.value = true;
                        controller.vendor.value.text = value['entity_name'];
                        controller.vendorId.value = value['_id'];
                      },
                    );
                  },
                ),
              ),
              ExcludeFocus(
                child: IconButton(
                  onPressed: () {
                    addNewValueToScreenButtonDialog(
                      screenName: '📞 Entity Information',
                      widget: const EntityInformations(),
                    );
                  },
                  icon: const Icon(Icons.add_card),
                ),
              ),
            ],
          ),
          myTextFormFieldWithBorder(
            focusNode: controller.focusNode5,
            nextFocusNode: controller.focusNode6,
            previousFocusNode: controller.focusNode4,
            labelText: 'Note',
            maxLines: 5,
            controller: controller.note.value,
            onChanged: (_) {
              controller.isReceivingModified.value = true;
            },
          ),
        ],
      ),
    ),
  );
}
