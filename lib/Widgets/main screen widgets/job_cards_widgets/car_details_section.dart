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
    child: GetX<JobCardController>(builder: (controller) {
      var isBrandsLoading = controller.allBrands.isEmpty;
      final isCountriesLoading = controller.allCountries.isEmpty;
      final isColorsLoading = controller.allColors.isEmpty;
      final isEngineTypeLoading = controller.allEngineType.isEmpty;

      return Column(
        spacing: 10,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10,
            children: [
              Expanded(
                  flex: 2,
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.carBrand.text,
                    hintText: 'Brand',
                    items: isBrandsLoading ? {} : controller.allBrands,
                    onChanged: (key, value) {
                      controller.carBrandLogo.value = value['logo'];
                      controller.carBrand.text = value['name'];
                      controller.carModel.clear();
                      controller.getModelsByCarBrand(key);
                      controller.carBrandId.value = key;
                    },
                  )),
              Expanded(
                  child: Container(
                alignment: Alignment.centerLeft,
                child: carLogo(controller.carBrandLogo.value),
              )),
              Expanded(child: SizedBox()),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  flex: 2,
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.carModel.text,
                    hintText: 'Model',
                    items: controller.allModels.isEmpty
                        ? {}
                        : controller.allModels,
                    onChanged: (key, value) {
                      controller.carModel.text = value['name'];
                      controller.carModelId.value = key;
                    },
                  )),
              Expanded(
                  child: CustomDropdown(
                showedSelectedName: 'name',
                textcontroller: controller.color.text,
                hintText: 'Color',
                items: isColorsLoading ? {} : controller.allColors,
                onChanged: (key, value) {
                  controller.color.text = value['name'];
                  controller.colorId.value = key;
                },
              )),
              Expanded(
                  child: myTextFormFieldWithBorder(
                controller: controller.year,
                labelText: 'Year',
                hintText: 'Enter Year',
              )),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  child: myTextFormFieldWithBorder(
                controller: controller.plateNumber,
                labelText: 'Plate No.',
                hintText: 'Enter Plate No.',
              )),
              Expanded(
                  child: myTextFormFieldWithBorder(
                isCapitaLetters: true,
                controller: controller.plateCode,
                labelText: 'Code',
                hintText: 'Enter Plate Code',
              )),
              Expanded(flex: 2, child: SizedBox())
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: CustomDropdown(
                showedSelectedName: 'name',
                textcontroller: controller.country.text,
                hintText: 'Country',
                items: isCountriesLoading ? {} : controller.allCountries,
                onChanged: (key, value) {
                  controller.country.text = value['name'];
                  controller.city.clear();
                  // controller.onSelectForCountryAndCity(entry.key);
                  controller.getCitiesByCountryID(key);
                  controller.countryId.value = key;
                },
              )),
              Expanded(child: SizedBox())
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: CustomDropdown(
                showedSelectedName: 'name',
                textcontroller: controller.city.text,
                hintText: 'City',
                items: controller.allCities.isEmpty ? {} : controller.allCities,
                onChanged: (key, value) {
                  controller.country.text = value['name'];
                  controller.city.clear();
                  controller.city.text = value['name'];
                  controller.cityId.value = key;
                },
              )),
              Expanded(child: SizedBox())
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  child: myTextFormFieldWithBorder(
                controller: controller.transmissionType,
                labelText: 'Transmission Type',
                hintText: 'Enter Transmission Type',
                isCapitaLetters: true,
              )),
              Expanded(
                  child: CustomDropdown(
                showedSelectedName: 'name',
                textcontroller: controller.engineType.text,
                hintText: 'Engine Type',
                items: isEngineTypeLoading ? {} : controller.allEngineType,
                onChanged: (key, value) {
                  controller.engineType.text = value['name'];
                  controller.engineTypeId.value = key;
                },
              )),
              Expanded(child: SizedBox())
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  child: myTextFormFieldWithBorder(
                controller: controller.vin,
                labelText: 'VIN',
                isCapitaLetters: true,
                hintText: 'Enter VIN',
              )),
              Expanded(child: SizedBox())
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                  child: myTextFormFieldWithBorder(
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
                      })),
              Expanded(
                  child: myTextFormFieldWithBorder(
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
                      })),
              Expanded(
                  child: myTextFormFieldWithBorder(
                isEnabled: false,
                controller: controller.inOutDiff.value,
                labelText: 'In Out Diff',
              )),
              Expanded(child: SizedBox())
            ],
          ),
        ],
      );
    }),
  );
}
