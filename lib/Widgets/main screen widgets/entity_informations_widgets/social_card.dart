import 'package:datahubai/Models/entity_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Widget socialCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(
        lable: Text(
          'Social Details',
          style: fontStyle1,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: containerDecor,
        child: Column(
          children: [
            AnimatedList(
              key: controller.listKeyForSocialLine,
              shrinkWrap: true,
              initialItemCount: controller.contactSocial.length,
              itemBuilder: (context, i, animation) {
                return buildSmartField(
                    controller, controller.contactSocial[i], animation, i);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.addSocialLine();
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
   EntitySocial item, Animation<double> animation, int index,
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
                    final isSocialTypeLoading =
                        controller.typeOfSocialsMap.isEmpty;
                    return dynamicFields(dynamicConfigs: [
                      DynamicConfig(
                          isDropdown: true,
                          flex: 1,
                          dropdownConfig: DropdownConfig(
                            listValues: controller.typeOfSocialsMap.values
                                .map((value) => value['name'].toString())
                                .toList(),
                            textController: controller
                                .socialTypesControllers[index].controller,
                            labelText: isSocialTypeLoading ? 'Loading' : 'Type',
                            hintText: 'Select Social Type',
                            menuValues: isSocialTypeLoading
                                ? {}
                                : controller.typeOfSocialsMap,
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text('${suggestion['name']}'),
                              );
                            },
                            onSelected: (suggestion) {
                              controller.socialTypesControllers[index]
                                  .controller!.text = suggestion['name'];
                              controller.typeOfSocialsMap.entries
                                  .where((entry) {
                                return entry.value['name'] ==
                                    suggestion['name'].toString();
                              }).forEach((entry) {
                                controller.contactSocial[index].type =
                                    entry.key;
                              });
                            },
                          )),
                      DynamicConfig(
                        isDropdown: false,
                        flex: 2,
                        fieldConfig: FieldConfig(
                          textController:
                              controller.linksControllers[index].controller,
                          labelText: 'Link',
                          hintText: 'Enter Link',
                          validate: false,
                          onChanged: (value) {
                            controller.contactSocial[index].link = value;
                          },
                        ),
                      ),
                    ]);
                  })),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: controller.contactSocial.length > 1
                  ? IconButton(
                      key: ValueKey('remove_$index'),
                      onPressed: () {
                        removeSocialFieldWithAnimation(index, controller);
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
void removeSocialFieldWithAnimation(
    int index, EntityInformationsController controller) {
  final removedItem = controller.contactSocial[index];
  controller.removeSocialField(index);
  controller.listKeyForSocialLine.currentState?.removeItem(
    index,
    (context, animation) {
      return buildSmartField(controller, removedItem, animation, index,
          isRemoving: true);
    },
    duration: const Duration(milliseconds: 300),
  );
}
// =====================================================
