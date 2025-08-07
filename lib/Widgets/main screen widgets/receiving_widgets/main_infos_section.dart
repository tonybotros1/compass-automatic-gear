import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

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
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            labelText: 'Number',
            isEnabled: false,
            controller: controller.receivingNumber.value,
          ),
        ),
        SizedBox(
          width: 150,
          child: myTextFormFieldWithBorder(
            onFieldSubmitted: (_) async {
              await normalizeDate(
                controller.date.value.text,
                controller.date.value,
              );
              // if (nor) {
              //   controller.searchEngine();
              // }
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
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GetX<ReceivingController>(
              builder: (controller) {
                bool isAllBranchesLoading = controller.allBranches.isEmpty;
                return SizedBox(
                  width: 300,
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    hintText: 'Branch',
                    items: isAllBranchesLoading ? {} : controller.allBranches,
                    onChanged: (key, value) {
                      controller.branchId.value = key;
                      controller.branch.value.text = value['name'];
                    },
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                addNewValueToScreenButtonDialog(
                  screenName: '🌿 Branches',
                  widget: Branches(),
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        SizedBox(
          width: 300,
          child: myTextFormFieldWithBorder(
            labelText: 'Reference Number',
            controller: controller.referenceNumber.value,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Expanded(
              child: GetX<ReceivingController>(
                builder: (controller) {
                  bool isAllVendorsLoading = controller.allVendors.isEmpty;
                  return CustomDropdown(
                    hintText: 'Vendor',
                    showedSelectedName: 'entity_name',
                    items: isAllVendorsLoading ? {} : controller.allVendors,
                    onChanged: (key, value) {
                      controller.vendor.value.text = value['entity_name'];
                      controller.vendorId.value = key;
                    },
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                addNewValueToScreenButtonDialog(
                  screenName: '📞 Entity Information',
                  widget: EntityInformations(),
                );
              },
              icon: Icon(Icons.add),
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
