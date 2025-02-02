import 'package:datahubai/Widgets/main%20screen%20widgets/entity_informations_widgets/social_card.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../my_text_field.dart';
import 'address_card.dart';
import 'company_section.dart';
import 'contacts_card.dart';
import 'customer_section.dart';
import 'image_section.dart';

Widget addNewEntityOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required EntityInformationsController controller,
  TextEditingController? name,
  TextEditingController? groupName,
  TextEditingController? typrOfBusiness,
}) {
  return SizedBox(
    height: constraints.maxHeight,
    width: constraints.maxWidth / 1.1,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          myTextFormFieldWithBorder(
            obscureText: false,
            controller: controller.entityName,
            labelText: 'Name',
            hintText: 'Enter Entity Name',
            validate: true,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GetX<EntityInformationsController>(builder: (controller) {
                      return CupertinoCheckbox(
                          value: controller.isCustomerSelected.value,
                          onChanged: (value) {
                            controller.selectCustomer(value!);
                          });
                    }),
                    Text(
                      'Customer',
                      style: regTextStyle,
                    )
                  ],
                ),
                Row(
                  children: [
                    GetX<EntityInformationsController>(builder: (controller) {
                      return CupertinoCheckbox(
                          value: controller.isVendorSelected.value,
                          onChanged: (value) {
                            controller.selectVendor(value!);
                          });
                    }),
                    Text(
                      'Vendor',
                      style: regTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: customerSection(),
              ),
              SizedBox(
                width: 50,
              ),
              GetBuilder<EntityInformationsController>(builder: (controller) {
                return imageSection(controller);
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: GetX<EntityInformationsController>(
                          builder: (controller) {
                        return CupertinoRadio<bool>(
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
                    ),
                    Text(
                      'Company',
                      style: regTextStyle,
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: GetX<EntityInformationsController>(
                          builder: (controller) {
                        return CupertinoRadio<bool>(
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
                    ),
                    Text(
                      'Individual',
                      style: regTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          companySection(),
          SizedBox(
            height: 15,
          ),
          addressCardSection(controller),
          SizedBox(
            height: 15,
          ),
          contactsCardSection(controller),
          SizedBox(
            height: 15,
          ),
          socialCardSection(controller),
        ],
      ),
    ),
  );
}
