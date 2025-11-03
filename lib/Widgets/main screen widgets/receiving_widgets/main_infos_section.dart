import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Screens/Main screens/System Administrator/Setup/branches.dart';
import '../../../Screens/Main screens/System Administrator/Setup/entity_informations.dart';
import '../../../consts.dart';
import 'add_new_value_for_screen_button.dart';

Container mainInfosSection(
  BuildContext context,
  ReceivingController controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    // height: null,
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
              width: 150,
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.date.value.text,
                  controller.date.value,
                );
              },
              controller: controller.date.value,
              labelText: 'Date',
              suffixIcon: IconButton(
                onPressed: () {
                  selectDateContext(context, controller.date.value);
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
                return CustomDropdown(
                  width: 310,
                  textcontroller: controller.branch.value.text,
                  showedSelectedName: 'name',
                  hintText: 'Branch',
                  onChanged: (key, value) {
                    controller.branchId.value = key;
                    controller.branch.value.text = value['name'];
                  },
                  onDelete: () {
                    controller.branchId.value = '';
                    controller.branch.value.clear();
                  },
                  onOpen: () {
                    return controller.getAllBranches();
                  },
                );
              },
            ),
            IconButton(
              onPressed: () {
                addNewValueToScreenButtonDialog(
                  screenName: '🌿 Branches',
                  widget: const Branches(),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          width: 310,
          labelText: 'Reference Number',
          controller: controller.referenceNumber.value,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Expanded(
              child: GetX<ReceivingController>(
                builder: (controller) {
                  bool isAllVendorsLoading = controller.allVendors.isEmpty;
                  return CustomDropdown(
                    textcontroller: controller.vendor.value.text,
                    hintText: 'Vendor',
                    showedSelectedName: 'entity_name',
                    items: isAllVendorsLoading ? {} : controller.allVendors,
                    onChanged: (key, value) {
                      controller.vendor.value.text = value['entity_name'];
                      controller.vendorId.value = key;
                    },
                    onDelete: () {
                      controller.vendor.value.clear();
                      controller.vendorId.value = '';
                    },
                    onOpen: () {
                      return controller.getAllVendors();
                    },
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                addNewValueToScreenButtonDialog(
                  screenName: '📞 Entity Information',
                  widget: const EntityInformations(),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          labelText: 'Note',
          maxLines: 5,
          controller: controller.note.value,
        ),
      ],
    ),
  );
}
