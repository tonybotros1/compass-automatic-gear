import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../consts.dart';
import '../add_new_values_button.dart';

Widget carDetailsSection(
  QuotationCardController controller,
  BoxConstraints constraints,
) {
  return Scrollbar(
    thumbVisibility: true,
    controller: controller.scrollerForCarDetails,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      width: double.infinity,
      child: GetX<QuotationCardController>(
        builder: (controller) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: controller.scrollerForCarDetails,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            CustomDropdown(
                              width: 325,
                              showedSelectedName: 'name',
                              textcontroller: controller.carBrand.text,
                              hintText: 'Brand',
                              onChanged: (key, value) {
                                controller.carBrandLogo.value =
                                    value['logo'] ?? '';
                                controller.carBrand.text = value['name'];
                                controller.getModelsByCarBrand(key);
                                controller.carBrandId.value = key;
                                controller.isQuotationModified.value = true;
                              },
                              onDelete: () {
                                controller.carBrandLogo.value = '';
                                controller.carBrand.clear();
                                controller.carModel.clear();
                                controller.carBrandId.value = '';
                                controller.isQuotationModified.value = true;
                                controller.isQuotationModified.value = true;
                              },
                              onOpen: () {
                                return controller.getCarBrands();
                              },
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomDropdown(
                              width: 325,
                              showedSelectedName: 'name',
                              textcontroller: controller.carModel.text,
                              hintText: 'Model',

                              onChanged: (key, value) {
                                controller.carModel.text = value['name'];
                                controller.carModelId.value = key;
                                controller.isQuotationModified.value = true;
                              },
                              onDelete: () {
                                controller.carModel.clear();
                                controller.carModelId.value = '';
                                controller.isQuotationModified.value = true;
                                controller.isQuotationModified.value = true;
                              },
                              onOpen: () {
                                return controller.getModelsByCarBrand(
                                  controller.carBrandId.value,
                                );
                              },
                            ),
                            valSectionInTheTableForBrands(
                              controller.carBrandsController,
                              controller.carBrandId.value,
                              constraints,
                              'New Model',
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            myTextFormFieldWithBorder(
                              width: 115,
                              controller: controller.year,
                              labelText: 'Year',
                              hintText: 'Enter Year',
                              onChanged: (_) {
                                controller.isQuotationModified.value = true;
                              },
                            ),
                            const SizedBox(width: 10),
                            CustomDropdown(
                              width: 200,
                              showedSelectedName: 'name',
                              textcontroller: controller.color.text,
                              hintText: 'Color',
                              onChanged: (key, value) {
                                controller.color.text = value['name'];
                                controller.colorId.value = key;
                                controller.isQuotationModified.value = true;
                              },
                              onDelete: () {
                                controller.color.clear();
                                controller.colorId.value = '';
                                controller.isQuotationModified.value = true;
                              },
                              onOpen: () {
                                return controller.getColors();
                              },
                            ),
                            valSectionInTheTable(
                              controller.listOfValuesController,
                              constraints,
                              'COLORS',
                              'New Color',
                              'Colors',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: carLogo(controller.carBrandLogo.value),
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
                        controller.isQuotationModified.value = true;
                      },
                    ),
                    myTextFormFieldWithBorder(
                      width: 115,
                      controller: controller.plateCode,
                      labelText: 'Code',
                      hintText: 'Enter Plate Code',
                      isCapitaLetters: true,
                      onChanged: (_) {
                        controller.isQuotationModified.value = true;
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomDropdown(
                      width: 240,
                      showedSelectedName: 'name',
                      textcontroller: controller.country.text,
                      hintText: 'Country',
                      onChanged: (key, value) {
                        controller.country.text = value['name'];
                        controller.city.clear();
                        // controller.getCitiesByCountryID(key);
                        controller.countryId.value = key;
                        controller.isQuotationModified.value = true;
                      },
                      onDelete: () {
                        controller.country.clear();
                        controller.city.clear();
                        // controller.allCities.clear();
                        controller.countryId.value = '';
                        controller.isQuotationModified.value = true;
                      },
                      onOpen: () {
                        return controller.getCountries();
                      },
                    ),
                    const SizedBox(width: 10),
                    CustomDropdown(
                      width: 200,
                      showedSelectedName: 'name',
                      textcontroller: controller.city.text,
                      hintText: 'City',
                      // items: controller.allCities.isEmpty
                      //     ? {}
                      //     : controller.allCities,
                      onChanged: (key, value) {
                        controller.country.text = value['name'];
                        controller.city.clear();
                        controller.city.text = value['name'];
                        controller.cityId.value = key;
                        controller.isQuotationModified.value = true;
                      },
                      onDelete: () {
                        controller.country.clear();
                        controller.city.clear();
                        controller.city.clear();
                        controller.cityId.value = '';
                        controller.isQuotationModified.value = true;
                      },
                      onOpen: () {
                        return controller.getCitiesByCountryID(
                          controller.countryId.value,
                        );
                      },
                    ),
                    valSectionInTheTableForCountries(
                      controller.countriesController,
                      controller.countryId.value,
                      constraints,
                      'New City',
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    myTextFormFieldWithBorder(
                      width: 240,
                      controller: controller.transmissionType,
                      labelText: 'Transmission Type',
                      hintText: 'Enter Transmission Type',
                      isCapitaLetters: true,
                      onChanged: (_) {
                        controller.isQuotationModified.value = true;
                      },
                    ),
                    const SizedBox(width: 10),
                    CustomDropdown(
                      width: 200,
                      showedSelectedName: 'name',
                      textcontroller: controller.engineType.text,
                      hintText: 'Engine Type',
                      onChanged: (key, value) {
                        controller.engineType.text = value['name'];
                        controller.engineTypeId.value = key;
                        controller.isQuotationModified.value = true;
                      },
                      onDelete: () {
                        controller.engineType.clear();
                        controller.engineTypeId.value = '';
                        controller.isQuotationModified.value = true;
                      },
                      onOpen: () {
                        return controller.getEngineTypes();
                      },
                    ),
                    valSectionInTheTable(
                      controller.listOfValuesController,
                      constraints,
                      'ENGINE_TYPES',
                      'New Engine Type',
                      'Engine Type',
                    ),
                  ],
                ),
                myTextFormFieldWithBorder(
                  width: 450,
                  controller: controller.vin,
                  labelText: 'VIN',
                  hintText: 'Enter VIN',
                  isCapitaLetters: true,
                  onChanged: (_) {
                    controller.isQuotationModified.value = true;
                  },
                ),
                myTextFormFieldWithBorder(
                  width: 115,
                  isnumber: true,
                  controller: controller.mileageIn.value,
                  labelText: 'Mileage In',
                  hintText: 'Enter Mileage In',
                  onChanged: (_) {
                    controller.isQuotationModified.value = true;
                  },
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
