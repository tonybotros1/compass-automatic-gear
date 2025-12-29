import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/entity information/entity_information_model.dart';
import '../../../consts.dart';

Widget contactsCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(lable: Text('Contacts Details', style: fontStyle1)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: containerDecor,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary', style: fontStyle2),
            AnimatedList(
              key: controller.listKeyForPhoneLine,
              shrinkWrap: true,
              initialItemCount: controller.contactPhone.length,
              itemBuilder: (context, i, animation) {
                return buildSmartField(
                  controller,
                  controller.contactPhone[i],
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
                    controller.addPhoneLine();
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
  EntityPhone item,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: GetBuilder<EntityInformationsController>(
              builder: (controller) {
                return RadioGroup<bool>(
                  groupValue: controller.phonePrimary[index].isPrimary,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      controller.selectPrimaryPhonesField(index, newValue);
                    }
                  },
                  child: CupertinoRadio<bool>(
                    value: true,
                    fillColor: mainColor,
                    activeColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GetX<EntityInformationsController>(
              builder: (controller) {
                return Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        showedSelectedName: 'name',
                        textcontroller: controller
                            .phoneTypesControllers[index]
                            .controller!
                            .text,
                        hintText: 'Type',
                        onChanged: (key, value) {
                          controller
                                  .phoneTypesControllers[index]
                                  .controller!
                                  .text =
                              value['name'];
                          controller.contactPhone[index].type = value['name'];
                          controller.contactPhone[index].typeId = key;
                        },
                        onDelete: () {
                          controller.phoneTypesControllers[index].controller!
                              .clear();
                          controller.contactPhone[index].type = '';
                          controller.contactPhone[index].typeId = '';
                        },
                        onOpen: () {
                          return controller.getPhoneTypes();
                        },
                      ),
                    ),
                    Expanded(
                      child: myTextFormFieldWithBorder(
                        controller: controller
                            .phoneNumbersControllers[index]
                            .controller,
                        labelText: 'Phone',
                        onChanged: (value) {
                          controller.contactPhone[index].number = value.trim();
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: myTextFormFieldWithBorder(
                        controller:
                            controller.emailsControllers[index].controller,
                        labelText: 'Email',
                        onChanged: (value) {
                          controller.contactPhone[index].email = value.trim();
                        },
                      ),
                    ),
                    Expanded(
                      child: myTextFormFieldWithBorder(
                        controller:
                            controller.namesControllers[index].controller,
                        labelText: 'Name',
                        onChanged: (value) {
                          controller.contactPhone[index].name = value.trim();
                        },
                      ),
                    ),
                    Expanded(
                      child: myTextFormFieldWithBorder(
                        controller:
                            controller.jobTitlesControllers[index].controller,
                        labelText: 'Job Title',
                        onChanged: (value) {
                          controller.contactPhone[index].jobTitle = value
                              .trim();
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
            child: controller.contactPhone.length > 1
                ? IconButton(
                    key: ValueKey('remove_$index'),
                    onPressed: () {
                      removePhoneFieldWithAnimation(index, controller);
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

// =====================================================
void removePhoneFieldWithAnimation(
  int index,
  EntityInformationsController controller,
) {
  final removedItem = controller.contactPhone[index];
  controller.removePhoneField(index);
  controller.listKeyForPhoneLine.currentState?.removeItem(index, (
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
