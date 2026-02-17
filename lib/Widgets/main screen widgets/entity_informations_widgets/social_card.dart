import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/entity information/entity_information_model.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';

Widget socialCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(lable: Text('Social Details', style: fontStyle1)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: containerDecor,
        child: Column(
          spacing: 10,
          children: [
            AnimatedList(
              key: controller.listKeyForSocialLine,
              shrinkWrap: true,
              initialItemCount: controller.contactSocial.length,
              itemBuilder: (context, i, animation) {
                return buildSmartField(
                  controller,
                  controller.contactSocial[i],
                  animation,
                  i,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.addSocialLine();
                  },
                  label: const Text(
                    'More...',
                    style: TextStyle(color: Colors.blue),
                  ),
                  icon: const Icon(
                    size: 25,
                    Icons.add_circle_outline,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildSmartField(
  EntityInformationsController controller,
  EntitySocial item,
  Animation<double> animation,
  int index, {
  bool isRemoving = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: SizeTransition(
      sizeFactor: animation,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: GetX<EntityInformationsController>(
              builder: (controller) {
                return Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: MenuWithValues(
                        labelText: 'Type',
                        headerLqabel: 'Types',
                        dialogWidth: 600,
                        controller: controller
                            .socialTypesControllers[index]
                            .controller!,
                        displayKeys: const ['name'],
                        displaySelectedKeys: const ['name'],
                        onOpen: () {
                          return controller.getTypeOfSocial();
                        },
                        onDelete: () {
                          controller.socialTypesControllers[index].controller!
                              .clear();
                          controller.contactSocial[index].typeId = '';
                          controller.contactSocial[index].type = '';
                        },
                        onSelected: (value) async {
                          controller
                                  .socialTypesControllers[index]
                                  .controller!
                                  .text =
                              value['name'];
                          controller.contactSocial[index].typeId = value['_id'];
                          controller.contactSocial[index].type = value['name'];
                        },
                      ),
                      //  CustomDropdown(
                      //   showedSelectedName: 'name',
                      //   textcontroller: controller
                      //       .socialTypesControllers[index]
                      //       .controller!
                      //       .text,
                      //   hintText: 'Type',
                      //   onChanged: (key, value) {
                      // controller
                      //         .socialTypesControllers[index]
                      //         .controller!
                      // .text =
                      //         value['name'];
                      //     controller.contactSocial[index].typeId = key;
                      //     controller.contactSocial[index].type = value['name'];
                      //   },
                      //   onDelete: () {
                      //     controller.socialTypesControllers[index].controller!
                      //         .clear();
                      //     controller.contactSocial[index].typeId = '';
                      //     controller.contactSocial[index].type = '';
                      //   },
                      //   onOpen: () {
                      //     return controller.getTypeOfSocial();
                      //   },
                      // ),
                    ),
                    Expanded(
                      flex: 2,
                      child: myTextFormFieldWithBorder(
                        controller:
                            controller.linksControllers[index].controller,
                        labelText: 'Link',
                        onChanged: (value) {
                          controller.contactSocial[index].link = value.trim();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
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
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    ),
  );
}

//  dynamicFields(
//                   dynamicConfigs: [
//                     DynamicConfig(
//                       isDropdown: true,
//                       flex: 1,
//                       dropdownConfig: DropdownConfig(
//                         showedSelectedName: 'name',
//                         textController: controller
//                             .socialTypesControllers[index]
//                             .controller!
//                             .text,
//                         hintText: 'Type',
//                         menuValues: isSocialTypeLoading
//                             ? {}
//                             : controller.typeOfSocialsMap,
//                         onSelected: (key, value) {
//                           controller
//                                   .socialTypesControllers[index]
//                                   .controller!
//                                   .text =
//                               value['name'];
//                           controller.contactSocial[index].typeId = key;
//                           controller.contactSocial[index].type = value['name'];
//                         },
//                         onDelete: () {
//                           controller.socialTypesControllers[index].controller!
//                               .clear();
//                           controller.contactSocial[index].typeId = '';
//                           controller.contactSocial[index].type = '';
//                         },
//                       ),
//                     ),
//                     DynamicConfig(
//                       isDropdown: false,
//                       flex: 2,
//                       fieldConfig: FieldConfig(
//                         textController:
//                             controller.linksControllers[index].controller,
//                         labelText: 'Link',
//                         hintText: 'Enter Link',
//                         validate: false,
//                         onChanged: (value) {
//                           controller.contactSocial[index].link = value.trim();
//                         },
//                       ),
//                     ),
//                   ],
//                 );

// =====================================================
void removeSocialFieldWithAnimation(
  int index,
  EntityInformationsController controller,
) {
  final removedItem = controller.contactSocial[index];
  controller.removeSocialField(index);
  controller.listKeyForSocialLine.currentState?.removeItem(index, (
    context,
    animation,
  ) {
    return buildSmartField(
      controller,
      removedItem,
      animation,
      index,
      isRemoving: true,
    );
  }, duration: const Duration(milliseconds: 300));
}

// =====================================================
