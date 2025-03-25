import 'package:datahubai/Widgets/main%20screen%20widgets/entity_informations_widgets/social_card.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import 'address_card.dart';
import 'company_section.dart';
import 'contacts_card.dart';
import 'customer_section.dart';

Widget addNewEntityOrEdit({
  required BoxConstraints constraints,
  required EntityInformationsController controller,
}) {
  return SizedBox(
   
    child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          labelContainer(
            lable: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GetX<EntityInformationsController>(builder: (controller) {
                      return CupertinoCheckbox(
                          checkColor: mainColor,
                          activeColor: Colors.white,
                          value: controller.isCustomerSelected.value,
                          onChanged: (value) {
                            controller.selectCustomer(value!);
                          });
                    }),
                    Text(
                      'Customer',
                      style: fontStyle1,
                    )
                  ],
                ),
                Row(
                  children: [
                    GetX<EntityInformationsController>(builder: (controller) {
                      return CupertinoCheckbox(
                          checkColor: mainColor,
                          activeColor: Colors.white,
                          value: controller.isVendorSelected.value,
                          onChanged: (value) {
                            controller.selectVendor(value!);
                          });
                    }),
                    Text(
                      'Vendor',
                      style: fontStyle1,
                    )
                  ],
                )
              ],
            ),
          ),
          customerSection(),
          const SizedBox(
            height: 10,
          ),
          labelContainer(
            lable: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 4,
                ),
                Row(
                  spacing: 10,
                  children: [
                    GetX<EntityInformationsController>(builder: (controller) {
                      return CupertinoRadio<bool>(
                        fillColor: mainColor,
                        activeColor: Colors.white,
                        value: true,
                        groupValue: controller.isCompanySelected.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectCompanyOrIndividual(
                                'company', value);
                          }
                        },
                      );
                    }),
                    Text(
                      'Company',
                      style: fontStyle1,
                    )
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    GetX<EntityInformationsController>(builder: (controller) {
                      return CupertinoRadio<bool>(
                        fillColor: mainColor,
                        activeColor: Colors.white,
                        value: true,
                        groupValue: controller.isIndividualSelected.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectCompanyOrIndividual(
                                'individual', value);
                          }
                        },
                      );
                    }),
                    Text(
                      'Individual',
                      style: fontStyle1,
                    )
                  ],
                )
              ],
            ),
          ),
          companySection(),
          const SizedBox(
            height: 15,
          ),
          addressCardSection(controller),
          const SizedBox(
            height: 15,
          ),
          contactsCardSection(controller),
          const SizedBox(
            height: 15,
          ),
          socialCardSection(controller),
        ],
      ),
    ),
  );
}
