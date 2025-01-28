import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';
import 'address_card.dart';
import 'contacts_card.dart';

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
    width: constraints.maxWidth / 2,
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
                controller.salesMAn.value.text = '${suggestion['name']}';
                controller.salesManMap.entries.where((entry) {
                  return entry.value['name'] == suggestion['name'].toString();
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
                          controller.selectCompantOrIndividual('company', value!);
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
              labelText: 'Type Of Business',
              hintText: 'Select Type Of Business',
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
          SizedBox(height: 15,),
          contactsCardSection(controller),
        ],
      ),
    ),
  );
}

//  buildLeftSideMenu(),
//         SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: const Color(0xffEAE2C6),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child:
//                 GetBuilder<EntityInformationsController>(builder: (controller) {
//               return controller.buildRightContent(
//                   controller.selectedMenu.value, controller, constraints);
//             }),
//           ),
//         )

GetBuilder<EntityInformationsController> buildLeftSideMenu() {
  return GetBuilder<EntityInformationsController>(builder: (controller) {
    return Container(
      width: 220,
      height: 400,
      padding: const EdgeInsets.fromLTRB(35, 30, 0, 30),
      decoration: BoxDecoration(
        color: Color(0xffEAE2C6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: ListView.builder(
          controller: controller.scrollController,
          shrinkWrap: true,
          itemCount: controller.visibleMenus.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                controller.selectFromLeftMenu(i);
              },
              child: Row(
                children: [
                  Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: controller.visibleMenus[i].isPressed == false
                          ? Colors.grey.shade700
                          : Color(0xff2973B2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 2,
                      height: controller.visibleMenus[i].isPressed == true
                          ? 100
                          : 70,
                      color: controller.visibleMenus[i].isPressed == false
                          ? Colors.white54
                          : Color(0xff2973B2),
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: controller.visibleMenus[i].isPressed == false
                          ? Colors.grey.shade700
                          : Color(0xff2973B2),
                      fontSize: controller.visibleMenus[i].isPressed == true
                          ? 18
                          : 16, // Font size change
                      fontWeight: controller.visibleMenus[i].isPressed == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    child: FittedBox(
                        child: Text(controller.visibleMenus[i].title)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  });
}
