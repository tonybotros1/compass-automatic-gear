import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import 'smart_field.dart';

Widget socialCardSection(EntityInformationsController controller) {
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
                Icons.public,
                color: Colors.grey,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: smartField(
                    onChangedForThirdSection: (value) {
                      controller.contactSocial[index]['name'] = value;
                    },
                    textControllerForDropMenu:
                        controller.socialTypesControllers[index].controller,
                    labelTextForDropMenu: 'Type',
                    hintTextForDeopMenu: 'Select Social Type',
                    menuValues: controller.typeOfSocialsMap.isEmpty
                        ? {}
                        : controller.typeOfSocialsMap,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['name']}'),
                      );
                    },
                    onSelected: (suggestion) {
                      controller.socialTypesControllers[index].controller!
                          .text = suggestion['name'];
                      controller.typeOfSocialsMap.entries.where((entry) {
                        return entry.value['name'] ==
                            suggestion['name'].toString();
                      }).forEach((entry) {
                        controller.contactSocial[index]['type'] = entry.key;
                      });
                    },
                    labelTextForThirdSection: 'Link',
                    hintTextForThirdSection: 'Enter Link',
                    validateForThirdSection: false,
                    validateForTypeSection: false),
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
