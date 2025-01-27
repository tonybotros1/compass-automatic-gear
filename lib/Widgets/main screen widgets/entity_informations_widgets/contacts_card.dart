import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import 'smart_field.dart';

Widget contactsCardSection(EntityInformationsController controller) {
  return AnimatedContainer(
    height: 400,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: ListView(
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.grey,
                    onPressed: () {
                      controller.addPhoneLine();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
                style: nextButtonStyle,
                onPressed: () {
                  controller.goToNextMenu();
                },
                child: const Text('Next')))
      ],
    ),
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
                Icons.phone,
                color: Colors.grey,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: smartField(
                    showFirstField: true,
                    showSecondField: true,
                    onChangedForSecondSection: (value) {
                      controller.contactPhone[index]['email'] = value;
                    },
                    onChangedForThirdSection: (value) {
                      controller.contactPhone[index]['name'] = value;
                    },
                    onChangedForFirstSection: (value) {
                      controller.contactPhone[index]['number'] = value;
                    },
                    textControllerForDropMenu:
                        controller.phoneTypesControllers[index].controller,
                    labelTextForDropMenu: 'Type',
                    hintTextForDeopMenu: 'Select Phone Type',
                    menuValues: controller.phoneTypesMap.isEmpty
                        ? {}
                        : controller.phoneTypesMap,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['name']}'),
                      );
                    },
                    onSelected: (suggestion) {
                      controller.phoneTypesControllers[index].controller!.text =
                          suggestion['name'];
                      controller.phoneTypesMap.entries.where((entry) {
                        return entry.value['name'] ==
                            suggestion['name'].toString();
                      }).forEach((entry) {
                        controller.contactPhone[index]['type'] = entry.key;
                      });
                    },
                    labelTextForFirstSection: 'Phone Number',
                    hintTextForFirstSection: 'Enter Phone Number',
                    validateForFirstSection: false,
                    labelTextForThirdSection: 'Name',
                    hintTextForThirdSection: 'Enter Name',
                    validateForThirdSection: false,
                    labelTextForSecondSection: 'Email',
                    hintTextForSecondSection: 'Enter Email',
                    validateForSecondSection: false,
                    validateForTypeSection: false),
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
