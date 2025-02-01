import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../dynamic_field.dart';

Widget socialCardSection(EntityInformationsController controller) {
  return Column(
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.grey,
            onPressed: () {
              controller.addSocialLine();
            },
          ),
        ],
      )
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
            SizedBox(
              width: 30,
              child: Icon(
                Icons.public,
                color: Colors.grey,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
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
                                controller.contactSocial[index]['type'] =
                                    entry.key;
                              });
                            },
                          )),
                      DynamicConfig(
                        isDropdown: false,
                        flex: 2,
                        fieldConfig: FieldConfig(
                          textController: controller.linksControllers[index].controller,
                          labelText: 'Link',
                          hintText: 'Enter Link',
                          validate: false,
                          onChanged: (value) {
                            controller.contactSocial[index]['link'] = value;
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
