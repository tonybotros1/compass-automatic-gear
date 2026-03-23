import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_vendor_controller.dart';
import 'address_card.dart';
import 'company_section.dart';
import 'contacts_card.dart';
import 'customer_section.dart';
import 'social_card.dart';

Widget addNewVendorEntityOrEdit({
  required EntityInformationsVendorController controller,
}) {
  const double minColumnWidth = 630.0; // Minimum width for one column
  const double horizontalPadding = 20.0; // Estimate for padding/spacing
  const double minContentWidth = (minColumnWidth * 2) + horizontalPadding;
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          thumbVisibility: true,
          controller: controller.horizontalController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: controller.horizontalController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minContentWidth,
                maxWidth: constraints.maxWidth > minContentWidth
                    ? constraints.maxWidth
                    : minContentWidth,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      Container(
                        width: constraints.maxWidth / 2 > minColumnWidth
                            ? constraints.maxWidth / 2 -
                                  horizontalPadding / 2 +
                                  10
                            : minColumnWidth,
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text(
                                'Main Information',
                                style: fontStyle1,
                              ),
                            ),
                            vendorSection(),
                          ],
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth / 2 > minColumnWidth
                            ? constraints.maxWidth / 2 - horizontalPadding / 2
                            : minColumnWidth,
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 4),
                                  GetX<EntityInformationsVendorController>(
                                    builder: (controller) {
                                      return RadioGroup<bool>(
                                        groupValue:
                                            controller.isCompanySelected.value,
                                        onChanged: (bool? newValue) {
                                          if (newValue != null) {
                                            if (newValue) {
                                              controller
                                                  .selectCompanyOrIndividual(
                                                    'company',
                                                    true,
                                                  );
                                            } else {
                                              controller
                                                  .selectCompanyOrIndividual(
                                                    'individual',
                                                    false,
                                                  );
                                            }
                                          }
                                        },
                                        child: Row(
                                          spacing: 20,
                                          children: [
                                            Row(
                                              spacing: 10,
                                              children: [
                                                CupertinoRadio<bool>(
                                                  value: true,
                                                  fillColor: mainColor,
                                                  activeColor: Colors.white,
                                                ),
                                                Text(
                                                  'Company',
                                                  style: fontStyle1,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              spacing: 10,
                                              children: [
                                                CupertinoRadio<bool>(
                                                  value: false,
                                                  fillColor: mainColor,
                                                  activeColor: Colors.white,
                                                ),
                                                Text(
                                                  'Individual',
                                                  style: fontStyle1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            companySectionForVendors(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  addressCardForVendorsSection(controller),
                  const SizedBox(height: 15),
                  contactsCardForVendorsSection(controller),
                  const SizedBox(height: 15),
                  socialCardForVendorsSection(controller),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
