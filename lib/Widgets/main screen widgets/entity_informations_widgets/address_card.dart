import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/entity information/entity_information_model.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';

Widget addressCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(lable: Text('Address Details', style: fontStyle1)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: containerDecor,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary', style: fontStyle2),
            AnimatedList(
              key: controller.listKeyForAddressLine,
              shrinkWrap: true,
              initialItemCount: controller.contactAddress.length,
              itemBuilder: (context, i, animation) {
                return buildSmartField(
                  controller,
                  controller.contactAddress[i],
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
                    controller.addAdressLine();
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
  EntityAddress item,
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
                  groupValue: controller.addressPrimary[index].isPrimary,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      controller.selectPrimaryAddressField(index, newValue);
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
                      flex: 2,
                      child: myTextFormFieldWithBorder(
                        controller:
                            controller.linesControllers[index].controller,
                        labelText: 'Line',
                        onChanged: (value) {
                          controller.contactAddress[index].line = value.trim();
                        },
                      ),
                    ),
                    Expanded(
                      child: MenuWithValues(
                        labelText: 'Country',
                        headerLqabel: 'Countries',
                        dialogWidth: 600,
                        controller:
                            controller.countriesControllers[index].controller!,
                        displayKeys: const ['name'],
                        displaySelectedKeys: const ['name'],
                        onOpen: () {
                          return controller.getCountries();
                        },
                        onDelete: () {
                          controller.countriesControllers[index].controller!
                              .clear();
                          controller.citiesControllers[index].controller!
                              .clear();
                          controller.contactAddress[index].countryId = '';
                          controller.contactAddress[index].country = '';
                          controller.contactAddress[index].city = '';
                          controller.contactAddress[index].cityId = '';
                        },
                        onSelected: (value) async {
                          controller
                                  .countriesControllers[index]
                                  .controller!
                                  .text =
                              value['name'];
                          controller.citiesControllers[index].controller!
                              .clear();
                          controller.contactAddress[index].countryId =
                              value['_id'];
                          controller.contactAddress[index].country =
                              value['name'];
                        },
                      ),
                    ),
                    Expanded(
                      child: MenuWithValues(
                        labelText: 'City',
                        headerLqabel: 'Cities',
                        dialogWidth: 600,
                        controller:
                            controller.citiesControllers[index].controller!,
                        displayKeys: const ['name'],
                        displaySelectedKeys: const ['name'],
                        onOpen: () {
                          return controller.getCitiesByCountryID(
                            controller.contactAddress[index].countryId,
                          );
                        },
                        onDelete: () {
                          controller.citiesControllers[index].controller!
                              .clear();
                          controller.contactAddress[index].cityId = '';
                          controller.contactAddress[index].city = '';
                        },
                        onSelected: (value) async {
                          controller.citiesControllers[index].controller!.text =
                              value['name'];
                          controller.contactAddress[index].cityId =
                              value['_id'];
                          controller.contactAddress[index].city = value['name'];
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
            child: controller.contactAddress.length > 1
                ? IconButton(
                    key: ValueKey('remove_$index'),
                    onPressed: () {
                      removeAdressFieldWithAnimation(index, controller);
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
void removeAdressFieldWithAnimation(
  int index,
  EntityInformationsController controller,
) {
  final removedItem = controller.contactAddress[index];
  controller.removeAddressField(index);
  controller.listKeyForAddressLine.currentState?.removeItem(index, (
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
