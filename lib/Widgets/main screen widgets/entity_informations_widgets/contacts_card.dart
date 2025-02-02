import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Widget contactsCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(lable: 'Contacts Details'),
      SizedBox(
        height: 3,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
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
    Map<String, dynamic> item, Animation<double> animation, int index,
    {bool isRemoving = false}) {
  return SizeTransition(
    sizeFactor: animation,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
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
                            textController: controller
                                .phoneTypesControllers[index].controller,
                            labelText:
                                isphoneTypesLoading ? 'Loading...' : 'Type',
                            hintText: 'Select Phone Type',
                            menuValues: isphoneTypesLoading
                                ? {}
                                : controller.phoneTypesMap,
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text('${suggestion['name']}'),
                              );
                            },
                            onSelected: (suggestion) {
                              controller.phoneTypesControllers[index]
                                  .controller!.text = suggestion['name'];
                              controller.phoneTypesMap.entries.where((entry) {
                                return entry.value['name'] ==
                                    suggestion['name'].toString();
                              }).forEach((entry) {
                                controller.contactPhone[index]['type'] =
                                    entry.key;
                              });
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
                          controller.contactPhone[index]['number'] = value;
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
                          controller.contactPhone[index]['email'] = value;
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
                          controller.contactPhone[index]['name'] = value;
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
                          controller.contactPhone[index]['tob_title'] = value;
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
