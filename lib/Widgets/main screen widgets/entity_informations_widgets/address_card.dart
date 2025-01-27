import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import 'address_field.dart';

Widget addressCardSection(EntityInformationsController controller) {
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
                key: controller.listKeyForAddressLine,
                shrinkWrap: true,
                initialItemCount: controller.contactAddress.length,
                itemBuilder: (context, i, animation) {
                  return buildSmartField(
                      controller, controller.contactAddress[i], animation, i);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.grey,
                    onPressed: () {
                      controller.addAdressLine();
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
                Icons.home,
                color: Colors.grey,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: addressField(
                    labelTextForLine: 'Line',
                    hintTextForLine: 'Enter Your Line',
                    validateForLine: false,
                    onChangedForLine: (value) {
                      controller.contactAddress[index]['line'] = value;
                    },
                    textControllerForCity:
                        controller.citiesControllers[index].controller,
                    textControllerForCountry:
                        controller.countriesControllers[index].controller,
                    labelTextForCountry: 'Country',
                    labelTextForCity: 'City',
                    hintTextForCountry: 'Select Country',
                    hintTextForCity: 'Select City',
                    validateForcity: false,
                    validateForCountry: false,
                    countryValues: controller.allCountries,
                    cityValues:
                        controller.allCities, // need to update to on select
                    controller: controller,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['name']}'),
                      );
                    },
                    onSelectedForCity: (suggestion) {
                      controller.citiesControllers[index].controller!.text =
                          suggestion['name'];
                      controller.allCities.entries.where((entry) {
                        return entry.value['name'] ==
                            suggestion['name'].toString();
                      }).forEach((entry) {
                        controller.contactAddress[index]['city'] = entry.key;
                      });
                    },
                    onSelectedForCountry: (suggestion) {
                      controller.countriesControllers[index].controller!.text =
                          suggestion['name'];
                      controller.allCountries.entries.where((entry) {
                        return entry.value['name'] ==
                            suggestion['name'].toString();
                      }).forEach((entry) {
                        controller.contactAddress[index]['country'] = entry.key;
                      });
                    }),
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
