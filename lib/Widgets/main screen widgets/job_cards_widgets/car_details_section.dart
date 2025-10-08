import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../consts.dart';

Widget carDetailsSection() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<JobCardController>(
      builder: (controller) {
        var isBrandsLoading = controller.allBrands.isEmpty;
        final isCountriesLoading = controller.allCountries.isEmpty;
        final isColorsLoading = controller.allColors.isEmpty;
        final isEngineTypeLoading = controller.allEngineType.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 10,
              children: [
                CustomDropdown(
                  width: 240,
                  showedSelectedName: 'name',
                  textcontroller: controller.carBrand.text,
                  hintText: 'Brand',
                  items: isBrandsLoading ? {} : controller.allBrands,
                  onChanged: (key, value) {
                    controller.carBrandLogo.value = value['logo'] ?? "";
                    controller.carBrand.text = value['name'] ?? "";
                    controller.carModel.clear();
                    controller.getModelsByCarBrand(key);
                    controller.carBrandId.value = key;
                    controller.isJobModified.value = true;
                  },
                  onDelete: () {
                    controller.carBrandLogo.value = "";
                    controller.carBrand.clear();
                    controller.carModel.clear();
                    controller.allModels.clear();
                    controller.carBrandId.value = "";
                    controller.carModelId.value = "";
                    controller.isJobModified.value = true;
                  },
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: carLogo(controller.carBrandLogo.value),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                CustomDropdown(
                  width: 240,
                  showedSelectedName: 'name',
                  textcontroller: controller.carModel.text,
                  hintText: 'Model',
                  items: controller.allModels.isEmpty
                      ? {}
                      : controller.allModels,
                  onChanged: (key, value) {
                    controller.carModel.text = value['name'];
                    controller.carModelId.value = key;
                    controller.isJobModified.value = true;
                  },
                  onDelete: () {
                    controller.carModel.clear();
                    controller.carModelId.value = "";
                    controller.isJobModified.value = true;
                  },
                ),
                CustomDropdown(
                  width: 120,
                  showedSelectedName: 'name',
                  textcontroller: controller.color.text,
                  hintText: 'Color',
                  items: isColorsLoading ? {} : controller.allColors,
                  onChanged: (key, value) {
                    controller.color.text = value['name'];
                    controller.colorId.value = key;
                    controller.isJobModified.value = true;
                  },
                  onDelete: () {
                    controller.color.clear();
                    controller.colorId.value = "";
                    controller.isJobModified.value = true;
                  },
                ),
                myTextFormFieldWithBorder(
                  width: 120,
                  controller: controller.year,
                  labelText: 'Year',
                  hintText: 'Enter Year',
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  width: 115,
                  controller: controller.plateNumber,
                  labelText: 'Plate No.',
                  hintText: 'Enter Plate No.',
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
                myTextFormFieldWithBorder(
                  width: 115,
                  isCapitaLetters: true,
                  controller: controller.plateCode,
                  labelText: 'Code',
                  hintText: 'Enter Plate Code',
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
              ],
            ),
            CustomDropdown(
              width: 240,
              showedSelectedName: 'name',
              textcontroller: controller.country.text,
              hintText: 'Country',
              items: isCountriesLoading ? {} : controller.allCountries,
              onChanged: (key, value) {
                controller.country.text = value['name'] ?? "";
                controller.city.clear();
                controller.getCitiesByCountryID(key);
                controller.countryId.value = key;
                controller.isJobModified.value = true;
              },
              onDelete: () {
                controller.country.clear();
                controller.city.clear();
                controller.allCities.clear();
                controller.countryId.value = "";
                controller.isJobModified.value = true;
              },
            ),
            CustomDropdown(
              width: 240,
              showedSelectedName: 'name',
              textcontroller: controller.city.text,
              hintText: 'City',
              items: controller.allCities.isEmpty ? {} : controller.allCities,
              onChanged: (key, value) {
                controller.city.text = value['name'] ?? "";
                controller.cityId.value = key;
                controller.isJobModified.value = true;
              },
              onDelete: () {
                controller.city.clear();
                controller.cityId.value = "";
                controller.isJobModified.value = true;
              },
            ),
            Row(
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  width: 200,
                  controller: controller.transmissionType,
                  labelText: 'Transmission Type',
                  hintText: 'Enter Transmission Type',
                  isCapitaLetters: true,
                  onChanged: (_) {
                    controller.isJobModified.value = true;
                  },
                ),
                CustomDropdown(
                  width: 200,
                  showedSelectedName: 'name',
                  textcontroller: controller.engineType.text,
                  hintText: 'Engine Type',
                  items: isEngineTypeLoading ? {} : controller.allEngineType,
                  onChanged: (key, value) {
                    controller.engineType.text = value['name'] ?? "";
                    controller.engineTypeId.value = key;
                    controller.isJobModified.value = true;
                  },
                  onDelete: () {
                    controller.engineType.clear();
                    controller.engineTypeId.value = "";
                    controller.isJobModified.value = true;
                  },
                ),
              ],
            ),
            myTextFormFieldWithBorder(
              width: 240,
              controller: controller.vin,
              labelText: 'VIN',
              isCapitaLetters: true,
              hintText: 'Enter VIN',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            Row(
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  width: 115,
                  isnumber: true,
                  controller: controller.mileageIn.value,
                  labelText: 'Mileage In',
                  hintText: 'Enter Mileage In',
                  onChanged: (value) {
                    if (controller.mileageIn.value.text.isNotEmpty) {
                      controller.inOutDiffCalculating();
                    } else {
                      controller.mileageIn.value.text = '0';
                      controller.inOutDiffCalculating();
                    }
                    controller.isJobModified.value = true;
                  },
                ),
                myTextFormFieldWithBorder(
                  width: 115,
                  isnumber: true,
                  controller: controller.mileageOut.value,
                  labelText: 'Mileage Out',
                  hintText: 'Enter Mileage Out',
                  onChanged: (value) {
                    if (controller.mileageOut.value.text.isNotEmpty) {
                      controller.inOutDiffCalculating();
                    } else {
                      controller.mileageOut.value.text = '0';
                      controller.inOutDiffCalculating();
                    }
                    controller.isJobModified.value = true;
                  },
                ),
                myTextFormFieldWithBorder(
                  width: 115,
                  isEnabled: false,
                  controller: controller.inOutDiff.value,
                  labelText: 'In Out Diff',
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
