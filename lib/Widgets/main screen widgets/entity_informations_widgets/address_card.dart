import 'package:datahubai/Models/entity_model.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/dynamic_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';

Widget addressCardSection(EntityInformationsController controller) {
  return Column(
    children: [
      labelContainer(
        lable: Text(
          'Address Details',
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
   EntityAddress item, Animation<double> animation, int index,
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
                  groupValue: controller.addressPrimary[index].isPrimary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectPrimaryAddressField(index, value);
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
                            controller.contactAddress[index].line = value;
                          },
                        ),
                      ),
                      DynamicConfig(
                        isDropdown: true,
                        flex: 1,
                        dropdownConfig: DropdownConfig(
                          showedSelectedName: 'name',
                          textController:
                              controller.countriesControllers[index].controller!.text,
                    
                             
                          hintText:  isCountriesLoading ? 'Loading...' : 'Country',
                          menuValues:
                              isCountriesLoading ? {} : controller.allCountries,
                          itemBuilder: (context,key, value) {
                            return ListTile(
                              title: Text('${value['name']}'),
                            );
                          },
                          onSelected: (key,value) {
                            controller.countriesControllers[index].controller!
                                .text = value['name'];
                                controller.citiesControllers[index].controller!
                                    .clear();
                                controller.getCitiesByCountryID(key,index);

                                controller.contactAddress[index].country =
                                    key;
                           
                          },
                        ),
                      ),
                      DynamicConfig(
                        isDropdown: true,
                        flex: 1,
                        dropdownConfig: DropdownConfig(
                       showedSelectedName: 'name',
                          textController:
                              controller.citiesControllers[index].controller!.text,
                          hintText: 'City',
                          menuValues: controller.allCities[index].isEmpty
                              ? {}
                              : controller.allCities[index],
                          itemBuilder: (context,key, value) {
                            return ListTile(
                              title: Text('${value['name']}'),
                            );
                          },
                          onSelected: (key,value) {
                            controller.citiesControllers[index].controller!
                                .text = value['name'];
                                controller.contactAddress[index].city =
                                  key;
                            
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
