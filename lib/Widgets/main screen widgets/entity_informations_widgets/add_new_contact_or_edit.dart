import 'package:datahubai/Widgets/main%20screen%20widgets/entity_informations_widgets/social_card.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';
import 'address_card.dart';
import 'contacts_card.dart';
import 'image_section.dart';

Widget addNewEntityOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required EntityInformationsController controller,
  TextEditingController? name,
  TextEditingController? groupName,
  TextEditingController? typrOfBusiness,
  bool? canEdit,
}) {
  return SizedBox(
    height: constraints.maxHeight,
    width: constraints.maxWidth / 1.5,
    child: SingleChildScrollView(
      child: Column(
        children: [
          myTextFormField2(
            icon: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            obscureText: false,
            controller: controller.contactName,
            labelText: 'Name',
            hintText: 'Enter Entity Name',
            validate: true,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    GetX<EntityInformationsController>(builder: (controller) {
                      return myTextFormField2(
                        isEnabled: controller.isCustomerSelected.isTrue,
                        isnumber: true,
                        icon: Icon(
                          Icons.credit_card,
                          color: Colors.grey,
                        ),
                        obscureText: false,
                        controller: controller.creditLimit,
                        labelText: 'Credit Limit',
                        hintText: 'Enter Credit Limit',
                        validate: true,
                      );
                    }),
                    SizedBox(
                      height: 15,
                    ),
                    GetX<EntityInformationsController>(builder: (controller) {
                      return dropDownValues(
                        icon: Icon(
                          Icons.receipt_long,
                          color: Colors.grey,
                        ),
                        textController: controller.salesMAn.value,
                        onSelected: (suggestion) {
                          controller.salesMAn.value.text =
                              '${suggestion['name']}';
                          controller.salesManMap.entries.where((entry) {
                            return entry.value['name'] ==
                                suggestion['name'].toString();
                          }).forEach((entry) {
                            controller.salesManId.value = entry.key;
                          });
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text('${suggestion['name']}'),
                          );
                        },
                        labelText: 'Sales Man',
                        hintText: 'Select Sale Man',
                        menus: controller.isCustomerSelected.isTrue
                            ? controller.salesManMap.isNotEmpty
                                ? controller.salesManMap
                                : {}
                            : {},
                        validate: false,
                        controller: controller,
                      );
                    }),
                  ],
                ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  GetX<EntityInformationsController>(builder: (controller) {
                    return CupertinoCheckbox(
                        value: controller.isCompanySelected.value,
                        onChanged: (value) {
                          controller.selectCompantOrIndividual(
                              'company', value!);
                        });
                  }),
                  Text(
                    'Company',
                    style: regTextStyle,
                  )
                ],
              ),
              Row(
                children: [
                  GetX<EntityInformationsController>(builder: (controller) {
                    return CupertinoCheckbox(
                        value: controller.isIndividualSelected.value,
                        onChanged: (value) {
                          controller.selectCompantOrIndividual(
                              'individual', value!);
                        });
                  }),
                  Text(
                    'Individual',
                    style: regTextStyle,
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GetX<EntityInformationsController>(builder: (controller) {
            return myTextFormField2(
              isEnabled: controller.isCompanySelected.isTrue,
              icon: Icon(
                Icons.apartment,
                color: Colors.grey,
              ),
              obscureText: false,
              controller: controller.groupName,
              labelText: 'Group Name',
              hintText: 'Enter Group Name',
              validate: true,
            );
          }),
          SizedBox(
            height: 15,
          ),
          GetX<EntityInformationsController>(builder: (controller) {
            return dropDownValues(
              icon: Icon(
                Icons.receipt_long,
                color: Colors.grey,
              ),
              textController: controller.typrOfBusiness.value,
              onSelected: (suggestion) {
                controller.typrOfBusiness.value.text = '${suggestion['name']}';
                controller.typeOfBusinessMap.entries.where((entry) {
                  return entry.value['name'] == suggestion['name'].toString();
                }).forEach((entry) {
                  controller.typrOfBusinessId.value = entry.key;
                });
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text('${suggestion['name']}'),
                );
              },
              labelText: 'Industries',
              hintText: 'Select Industries',
              menus: controller.isCompanySelected.isTrue
                  ? controller.typeOfBusinessMap.isNotEmpty
                      ? controller.typeOfBusinessMap
                      : {}
                  : {},
              validate: false,
              controller: controller,
            );
          }),
          SizedBox(
            height: 15,
          ),
          GetX<EntityInformationsController>(builder: (controller) {
            return myTextFormField2(
              isEnabled: controller.isCompanySelected.isTrue,
              icon: Icon(
                Icons.currency_exchange,
                color: Colors.grey,
              ),
              obscureText: false,
              controller: controller.trn,
              labelText: 'Tax Registration Number',
              hintText: 'Enter TRN',
              validate: true,
            );
          }),
          SizedBox(
            height: 15,
          ),
          GetX<EntityInformationsController>(builder: (controller) {
            return dropDownValues(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.grey,
              ),
              textController: controller.entityType.value,
              onSelected: (suggestion) {
                controller.entityType.value.text = '${suggestion['name']}';
                controller.entityTypeMap.entries.where((entry) {
                  return entry.value['name'] == suggestion['name'].toString();
                }).forEach((entry) {
                  controller.entityTypeId.value = entry.key;
                });
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text('${suggestion['name']}'),
                );
              },
              labelText: 'Entity Type',
              hintText: 'Select Entity Type',
              menus: controller.isCompanySelected.isTrue
                  ? controller.entityTypeMap.isNotEmpty
                      ? controller.entityTypeMap
                      : {}
                  : {},
              validate: false,
              controller: controller,
            );
          }),
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