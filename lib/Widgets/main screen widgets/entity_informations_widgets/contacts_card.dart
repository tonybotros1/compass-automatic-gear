import 'package:datahubai/Models/entity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Widget contactsCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(
        lable: Text(
          'Contacts Details',
          style: fontStyle1,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: containerDecor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Primary',
              style: fontStyle2,
            ),
            AnimatedList(
              key: controller.listKeyForPhoneLine,
              shrinkWrap: true,
              initialItemCount: controller.contactPhone.length,
              itemBuilder: (context, i, animation) {
                return buildSmartField(
                    controller, controller.contactPhone[i], animation, i);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.addPhoneLine();
                  },
                  label: Text(
                    'More...',
                    style: TextStyle(color: Colors.blue),
                  ),
                  icon: Icon(
                    size: 25,
                    Icons.add_circle_outline,
                    color: Colors.blue,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ],
  );
}

Widget buildSmartField(EntityInformationsController controller,
    EntityPhone item, Animation<double> animation, int index,
    {bool isRemoving = false}) {
  return SizeTransition(
    sizeFactor: animation,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GetBuilder<EntityInformationsController>(
                  builder: (controller) {
                return CupertinoRadio<bool>(
                  value: true,
                  groupValue: controller.phonePrimary[index].isPrimary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectPrimaryPhonesField(index, value);
                    }
                  },
                );
              }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child:
                    GetX<EntityInformationsController>(builder: (controller) {
                  final isphoneTypesLoading = controller.phoneTypesMap.isEmpty;

                  return dynamicFields(dynamicConfigs: [
                    DynamicConfig(
                        isDropdown: true,
                        flex: 1,
                        dropdownConfig: DropdownConfig(
                           showedSelectedName: 'name',
                            textController: controller
                                .phoneTypesControllers[index].controller!.text,
                           
                            hintText: isphoneTypesLoading ? 'Loading...' : 'Type',
                            menuValues: isphoneTypesLoading
                                ? {}
                                : controller.phoneTypesMap,
                            itemBuilder: (context,key, value) {
                              return ListTile(
                                title: Text('${value['name']}'),
                              );
                            },
                            onSelected: (key,value) {
                              controller.phoneTypesControllers[index]
                                  .controller!.text = value['name'];
                                   controller.contactPhone[index].type =
                                    key;
                            
                            })),
                    DynamicConfig(
                      isDropdown: false,
                      flex: 1,
                      fieldConfig: FieldConfig(
                        textController: controller
                            .phoneNumbersControllers[index].controller,
                        labelText: 'Phone',
                        hintText: 'Enter Phone',
                        validate: false,
                        onChanged: (value) {
                          controller.contactPhone[index].number = value;
                        },
                      ),
                    ),
                    DynamicConfig(
                      isDropdown: false,
                      flex: 2,
                      fieldConfig: FieldConfig(
                        textController:
                            controller.emailsControllers[index].controller,
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        validate: false,
                        onChanged: (value) {
                          controller.contactPhone[index].email = value;
                        },
                      ),
                    ),
                    DynamicConfig(
                      isDropdown: false,
                      flex: 1,
                      fieldConfig: FieldConfig(
                        textController:
                            controller.namesControllers[index].controller,
                        labelText: 'Name',
                        hintText: 'Enter Name',
                        validate: false,
                        onChanged: (value) {
                          controller.contactPhone[index].name = value;
                        },
                      ),
                    ),
                    DynamicConfig(
                      isDropdown: false,
                      flex: 1,
                      fieldConfig: FieldConfig(
                        textController:
                            controller.jobTitlesControllers[index].controller,
                        labelText: 'Job Title',
                        hintText: 'Enter Job Title',
                        validate: false,
                        onChanged: (value) {
                          controller.contactPhone[index].jobTitle = value;
                        },
                      ),
                    )
                  ]);
                }),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: controller.contactPhone.length > 1
                  ? IconButton(
                      key: ValueKey('remove_$index'),
                      onPressed: () {
                        removePhoneFieldWithAnimation(index, controller);
                      },
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ],
    ),
  );
}

// =====================================================
void removePhoneFieldWithAnimation(
    int index, EntityInformationsController controller) {
  final removedItem = controller.contactPhone[index];
  controller.removePhoneField(index);
  controller.listKeyForPhoneLine.currentState?.removeItem(
    index,
    (context, animation) {
      return buildSmartField(controller, removedItem, animation, index,
          isRemoving: true);
    },
    duration: const Duration(milliseconds: 300),
  );
}
// =====================================================
