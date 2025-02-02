import 'package:datahubai/Widgets/main%20screen%20widgets/dynamic_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';

Widget addressCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(lable: 'Address Details'),
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
              key: controller.listKeyForAddressLine,
              shrinkWrap: true,
              initialItemCount: controller.contactAddress.length,
              itemBuilder: (context, i, animation) {
                return buildSmartField(
                    controller, controller.contactAddress[i], animation, i);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.addAdressLine();
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
                    final isCountriesLoading = controller.allCountries.isEmpty;

                    return dynamicFields(dynamicConfigs: [
                      DynamicConfig(
                        isDropdown: false,
                        flex: 2,
                        fieldConfig: FieldConfig(
                          textController:
                              controller.linesControllers[index].controller,
                          labelText: 'Line',
                          hintText: 'Enter Line',
                          validate: false,
                          onChanged: (value) {
                            controller.contactAddress[index]['line'] = value;
                          },
                        ),
                      ),
                      DynamicConfig(
                        isDropdown: true,
                        flex: 1,
                        dropdownConfig: DropdownConfig(
                          textController:
                              controller.countriesControllers[index].controller,
                          labelText:
                              isCountriesLoading ? 'Loading...' : 'Country',
                          hintText: 'Select Your Country',
                          menuValues:
                              isCountriesLoading ? {} : controller.allCountries,
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text('${suggestion['name']}'),
                            );
                          },
                          onSelected: (suggestion) {
                            controller.countriesControllers[index].controller!
                                .text = suggestion['name'];
                            controller.allCountries.entries.where((entry) {
                              return entry.value['name'] ==
                                  suggestion['name'].toString();
                            }).forEach(
                              (entry) {
                                controller.citiesControllers[index].controller!
                                    .clear();
                                controller.onSelect(entry.key);

                                controller.contactAddress[index]['country'] =
                                    entry.key;
                              },
                            );
                          },
                        ),
                      ),
                      DynamicConfig(
                        isDropdown: true,
                        flex: 1,
                        dropdownConfig: DropdownConfig(
                          suggestionsController: SuggestionsController(),
                          onTap: SuggestionsController().refresh,
                          textController:
                              controller.citiesControllers[index].controller,
                          labelText: 'City',
                          hintText: 'Select Your City',
                          menuValues: controller.filterdCitiesByCountry.isEmpty
                              ? {}
                              : controller.filterdCitiesByCountry,
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text('${suggestion['name']}'),
                            );
                          },
                          onSelected: (suggestion) {
                            controller.citiesControllers[index].controller!
                                .text = suggestion['name'];
                            controller.allCities.entries.where((entry) {
                              return entry.value['name'] ==
                                  suggestion['name'].toString();
                            }).forEach((entry) {
                              controller.contactAddress[index]['city'] =
                                  entry.key;
                            });
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
              child: controller.contactAddress.length > 1
                  ? IconButton(
                      key: ValueKey('remove_$index'),
                      onPressed: () {
                        removeAdressFieldWithAnimation(index, controller);
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
void removeAdressFieldWithAnimation(
    int index, EntityInformationsController controller) {
  final removedItem = controller.contactAddress[index];
  controller.removeAddressField(index);
  controller.listKeyForAddressLine.currentState?.removeItem(
    index,
    (context, animation) {
      return buildSmartField(controller, removedItem, animation, index,
          isRemoving: true);
    },
    duration: const Duration(milliseconds: 300),
  );
}
// =====================================================
