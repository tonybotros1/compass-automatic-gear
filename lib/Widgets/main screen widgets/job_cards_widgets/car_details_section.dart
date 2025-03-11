import 'package:flutter/material.dart';
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
          var isTechLoading = controller.allTechnicians.isEmpty;
          final isCountriesLoading = controller.allCountries.isEmpty;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle),
                child: controller.carBrandLogo.value.isNotEmpty
                    ? Image.network(
                        controller.carBrandLogo.value,
                        width: 40,
                      )
                    : SizedBox(),
              ),
              Expanded(
                child: dynamicFields(dynamicConfigs: [
                  DynamicConfig(
                    isDropdown: true,
                    flex: 1,
                    dropdownConfig: DropdownConfig(
                      showedSelectedName: 'name',
                      textController: controller.technician.text,
                      hintText: isTechLoading ? 'Loading...' : 'Technician',
                      menuValues:
                          isTechLoading ? {} : controller.allTechnicians,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text('${value['name']}'),
                        );
                      },
                      onSelected: (key, value) {
                        controller.technicianId.value = key;
                      },
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 1,
                    dropdownConfig: DropdownConfig(
                      showedSelectedName: 'name',
                      textController: controller.carBrand.text,
                      hintText: isBrandsLoading ? 'Loading...' : 'Brand',
                      menuValues: isBrandsLoading ? {} : controller.allBrands,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text('${value['name']}'),
                        );
                      },
                      onSelected: (key, value) {
                        controller.carBrandLogo.value = value['logo'];
                        controller.carBrand.text = value['name'];
                        controller.carModel.clear();
                        controller.getModelsByCarBrand(key);
                        controller.carBrandId.value = key;
                      },
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 2,
                    dropdownConfig: DropdownConfig(
                      showedSelectedName: 'name',
                      textController: controller.carModel.text,
                      hintText: 'Model',
                      menuValues: controller.allModels.isEmpty
                          ? {}
                          : controller.allModels,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text('${value['name']}'),
                        );
                      },
                      onSelected: (key, value) {
                        controller.carModel.text = value['name'];
                        controller.carModelId.value = key;
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
                      textController: controller.plateCode,
                      labelText: 'Code',
                      hintText: 'Enter Plate Code',
                      validate: false,
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 2,
                    dropdownConfig: DropdownConfig(
                      showedSelectedName: 'name',
                      textController: controller.country.text,
                      hintText: isCountriesLoading ? 'Loading...' : 'Country',
                      menuValues:
                          isCountriesLoading ? {} : controller.allCountries,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text('${value['name']}'),
                        );
                      },
                      onSelected: (key, value) {
                        controller.country.text = value['name'];
                        controller.city.clear();
                        // controller.onSelectForCountryAndCity(entry.key);
                        controller.getCitiesByCountryID(key);
                        controller.countryId.value = key;
                      },
                    ),
                  ),
                  DynamicConfig(
                    isDropdown: true,
                    flex: 1,
                    dropdownConfig: DropdownConfig(
                      showedSelectedName: 'name',
                      textController: controller.city.text,
                      hintText: 'City',
                      menuValues: controller.allCities.isEmpty
                          ? {}
                          : controller.allCities,
                      itemBuilder: (context, key, value) {
                        return ListTile(
                          title: Text('${value['name']}'),
                        );
                      },
                      onSelected: (key, value) {
                        controller.city.text = value['name'];
                        controller.cityId.value = key;
                      },
                    ),
                  ),
                ]),
              ),
            ],
          );
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
              flex: 2,
              dropdownConfig: DropdownConfig(
                showedSelectedName: 'name',
                textController: controller.color.text,
                hintText: isColorsLoading ? 'Loading...' : 'Color',
                menuValues: isColorsLoading ? {} : controller.allColors,
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text('${value['name']}'),
                  );
                },
                onSelected: (key, value) {
                  controller.color.text = value['name'];
                  controller.colorId.value = key;
                },
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 2,
              fieldConfig: FieldConfig(
                textController: controller.transmissionType,
                labelText: 'Transmission Type',
                hintText: 'Enter Transmission Type',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 2,
              dropdownConfig: DropdownConfig(
                showedSelectedName: 'name',
                textController: controller.engineType.text,
                hintText: isColorsLoading ? 'Loading...' : 'Engine Type',
                menuValues: isColorsLoading ? {} : controller.allEngineType,
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text('${value['name']}'),
                  );
                },
                onSelected: (key, value) {
                  controller.engineType.text = value['name'];
                  controller.engineTypeId.value = key;
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
