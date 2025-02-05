import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Widget carDetailsSection() {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: containerDecor,
    child: Column(
      children: [
        GetX<JobCardController>(builder: (controller) {
          var isBrandsLoading = controller.allBrands.isEmpty;
          final isCountriesLoading = controller.allCountries.isEmpty;

          return dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                listValues: controller.allBrands.values
                    .map((value) => value['name'].toString())
                    .toList(),
                textController: controller.carBrand,
                labelText: isBrandsLoading ? 'Loading...' : 'Brand',
                hintText: 'Select Brand',
                menuValues: isBrandsLoading ? {} : controller.allBrands,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.carBrand.text = suggestion['name'];
                  controller.allBrands.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach(
                    (entry) {
                      controller.carModel.clear();
                      controller.onSelectForBrandsAndModels(entry.key);

                      controller.carBrandId.value = entry.key;
                    },
                  );
                },
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 2,
              dropdownConfig: DropdownConfig(
                listValues: controller.filterdModelsByBrands.values
                    .map((value) => value['name'].toString())
                    .toList(),
                suggestionsController: SuggestionsController(),
                onTap: SuggestionsController().refresh,
                textController: controller.carModel,
                labelText: 'Model',
                hintText: 'Select Model',
                menuValues: controller.filterdModelsByBrands.isEmpty
                    ? {}
                    : controller.filterdModelsByBrands,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.carModel.text = suggestion['name'];
                  controller.filterdModelsByBrands.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach(
                    (entry) {
                      controller.carModelId.value = entry.key;
                    },
                  );
                },
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                textController: controller.plateNumber,
                labelText: 'Plate No.',
                hintText: 'Enter Plate No.',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                textController: controller.carCode,
                labelText: 'Code',
                hintText: 'Enter Plate Code',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 2,
              dropdownConfig: DropdownConfig(
                listValues: controller.allCountries.values
                    .map((value) => value['name'].toString())
                    .toList(),
                textController: controller.country,
                labelText: isCountriesLoading ? 'Loading...' : 'Country',
                hintText: 'Select Country',
                menuValues: isCountriesLoading ? {} : controller.allCountries,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.country.text = suggestion['name'];
                  controller.allCountries.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach(
                    (entry) {
                      controller.city.clear();
                      controller.onSelectForCountryAndCity(entry.key);

                      controller.countryId.value = entry.key;
                    },
                  );
                },
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                listValues: controller.filterdCitiesByCountry.values
                    .map((value) => value['name'].toString())
                    .toList(),
                suggestionsController: SuggestionsController(),
                onTap: SuggestionsController().refresh,
                textController: controller.city,
                labelText: 'City',
                hintText: 'Select City',
                menuValues: controller.filterdCitiesByCountry.isEmpty
                    ? {}
                    : controller.filterdCitiesByCountry,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.city.text = suggestion['name'];
                  controller.filterdCitiesByCountry.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach((entry) {
                    controller.cityId.value = entry.key;
                  });
                },
              ),
            ),
          ]);
        }),
        SizedBox(
          height: 20,
        ),
        GetX<JobCardController>(builder: (controller) {
          final isColorsLoading = controller.allColors.isEmpty;

          return dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                textController: controller.year,
                labelText: 'Year',
                hintText: 'Enter Year',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                listValues: controller.allColors.values
                    .map((value) => value['name'].toString())
                    .toList(),
                textController: controller.color,
                labelText: isColorsLoading ? 'Loading...' : 'Color',
                hintText: 'Select Color',
                menuValues: isColorsLoading ? {} : controller.allColors,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.color.text = suggestion['name'];
                  controller.allColors.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach(
                    (entry) {
                      controller.colorId.value = entry.key;
                    },
                  );
                },
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 2,
              fieldConfig: FieldConfig(
                textController: controller.vin,
                labelText: 'Vehicle Identification No.',
                hintText: 'Enter VIN',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                  isnumber: true,
                  textController: controller.mileageIn.value,
                  labelText: 'Mileage In',
                  hintText: 'Enter Mileage In',
                  validate: false,
                  onChanged: (value) {
                    if (controller.mileageIn.value.text.isNotEmpty) {
                      controller.inOutDiffCalculating();
                    } else {
                      controller.mileageIn.value.text = '0';
                      controller.inOutDiffCalculating();
                    }
                  }),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                  isnumber: true,
                  textController: controller.mileageOut.value,
                  labelText: 'Mileage Out',
                  hintText: 'Enter Mileage Out',
                  validate: false,
                  onChanged: (value) {
                    if (controller.mileageOut.value.text.isNotEmpty) {
                      controller.inOutDiffCalculating();
                    } else {
                      controller.mileageOut.value.text = '0';
                      controller.inOutDiffCalculating();
                    }
                  }),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                isEnabled: false,
                textController: controller.inOutDiff.value,
                labelText: 'In Out Diff',
                validate: false,
              ),
            ),
          ]);
        }),
      ],
    ),
  );
}
