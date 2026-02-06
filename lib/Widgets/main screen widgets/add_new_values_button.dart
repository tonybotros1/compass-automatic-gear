import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Main screen controllers/car_brands_controller.dart';
import '../../Controllers/Main screen controllers/countries_controller.dart';
import '../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../consts.dart';
import 'car_brands_widgets/values_section_models.dart';
import 'countries_widgets/values_section_cities.dart';
import 'lists_widgets/values_section_in_list_of_values.dart';

Widget valSectionInTheTable(
  ListOfValuesController controller,
  BoxConstraints constraints,
  String code,
  String tooltip,

  String screenName, {
  bool isEnabled = true,
}) {
  return IconButton(
    tooltip: tooltip,
    onPressed: isEnabled == false
        ? null
        : () async {
            Map jsonData = await helper.getListDetails(code);
            String listId = jsonData['_id'];
            String masteredBy = jsonData['mastered_by'];
            controller.valueMap.clear();
            controller.searchForValues.value.clear();
            controller.filterValues();
            controller.listIDToWorkWithNewValue.value = listId;
            controller.getListValues(listId, masteredBy);
            Get.dialog(
              barrierDismissible: false,
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth / 2,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          color: mainColor,
                        ),
                        child: Row(
                          children: [
                            Text(
                              screenName,
                              style: fontStyleForScreenNameUsedInButtons,
                            ),
                            const Spacer(),
                            closeIcon(),
                          ],
                        ),
                      ),
                      Expanded(child: valuesSection(context: Get.context!)),
                    ],
                  ),
                ),
              ),
            );
          },
    icon: const Icon(Icons.add_card),
  );
}

Widget newValueButton(
  BoxConstraints constraints,
  String tooltip,
  String screenName,
  Widget screen,
) {
  return IconButton(
    tooltip: tooltip,
    onPressed: () async {
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: mainColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        screenName,
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      closeIcon(),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: screen,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    icon: const Icon(Icons.add_card),
  );
}

Widget valSectionInTheTableForBrands(
  CarBrandsController controller,
  String brandId,
  BoxConstraints constraints,
  String tooltip,
) {
  return IconButton(
    tooltip: tooltip,
    onPressed: () {
      if (brandId != '') {
        controller.searchForModels.value.clear();
        controller.getModelsValues(brandId);
        controller.brandIdToWorkWith.value = brandId;
        Get.dialog(
          barrierDismissible: false,
          Dialog(
            insetPadding: const EdgeInsets.all(25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth / 2.5,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: mainColor,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          'Models',
                          style: fontStyleForScreenNameUsedInButtons,
                        ),
                        const Spacer(),
                        closeIcon(),
                      ],
                    ),
                  ),
                  Expanded(child: modelsSection(context: Get.context!)),
                ],
              ),
            ),
          ),
        );
      } else {
        alertMessage(
          context: Get.context!,
          content: 'Please select brand first',
        );
      }
    },
    icon: const Icon(Icons.add_card),
  );
}

Widget valSectionInTheTableForCountries(
  CountriesController controller,
  String countryId,
  BoxConstraints constraints,
  String tooltip,
) {
  return IconButton(
    tooltip: tooltip,
    onPressed: () {
      if (countryId != '') {
        controller.searchForCities.value.clear();
        controller.getCitiesValues(countryId);
        controller.countryIdToWorkWith.value = countryId;
        Get.dialog(
          barrierDismissible: false,
          Dialog(
            insetPadding: const EdgeInsets.all(25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: mainColor,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          'Cities',
                          style: fontStyleForScreenNameUsedInButtons,
                        ),
                        const Spacer(),
                        closeIcon(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: citiesSection(
                      constraints: constraints,
                      context: Get.context!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        alertMessage(
          context: Get.context!,
          content: 'Please select country first',
        );
      }
    },
    icon: const Icon(Icons.add_card),
  );
}
