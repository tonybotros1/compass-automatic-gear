import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
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
                        MenuWithValues(
                          labelText: 'Brand',
                          headerLqabel: 'Brands',
                          dialogWidth: constraints.maxWidth / 3,
                          width: 325,
                          controller: controller.carBrand,
                          displayKeys: const ['name'],
                          displaySelectedKeys: const ['name'],
                          onSelected: (value) {
                            controller.carBrandLogo.value = value['logo'] ?? '';
                            controller.carBrand.text = value['name'];
                            controller.getModelsByCarBrand(value['_id']);
                            controller.carBrandId.value = value['_id'];
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MenuWithValues(
                              labelText: 'Model',
                              headerLqabel: 'Models',
                              dialogWidth: constraints.maxWidth / 3,
                              width: 325,
                              controller: controller.carModel,
                              displayKeys: const ['name'],
                              displaySelectedKeys: const ['name'],
                              onSelected: (value) {
                                controller.carModel.text = value['name'];
                                controller.carModelId.value = value['_id'];
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
                              onChanged: (_) {
                                controller.isQuotationModified.value = true;
                              },
                            ),
                            const SizedBox(width: 10),
                            MenuWithValues(
                              labelText: 'Color',
                              headerLqabel: 'Colors',
                              dialogWidth: constraints.maxWidth / 3,
                              width: 200,
                              controller: controller.color,
                              displayKeys: const ['name'],
                              displaySelectedKeys: const ['name'],
                              onSelected: (value) {
                                controller.color.text = value['name'];
                                controller.colorId.value = value['_id'];
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
                      onChanged: (_) {
                        controller.isQuotationModified.value = true;
                      },
                    ),
                    myTextFormFieldWithBorder(
                      width: 115,
                      controller: controller.plateCode,
                      labelText: 'Code',
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
                    MenuWithValues(
                      labelText: 'Country',
                      headerLqabel: 'Countries',
                      dialogWidth: constraints.maxWidth / 3,
                      width: 240,
                      controller: controller.country,
                      displayKeys: const ['name'],
                      displaySelectedKeys: const ['name'],
                      onSelected: (value) {
                        controller.country.text = value['name'];
                        controller.city.clear();
                        controller.cityId.value = '';
                        controller.countryId.value = value['_id'];
                        controller.isQuotationModified.value = true;
                      },
                      onDelete: () {
                        controller.country.clear();
                        controller.city.clear();
                        controller.cityId.value = '';
                        controller.countryId.value = '';
                        controller.isQuotationModified.value = true;
                      },
                      onOpen: () {
                        return controller.getCountries();
                      },
                    ),

                    const SizedBox(width: 10),
                    MenuWithValues(
                      labelText: 'City',
                      headerLqabel: 'Cities',
                      dialogWidth: constraints.maxWidth / 3,
                      width: 200,
                      controller: controller.city,
                      displayKeys: const ['name'],
                      displaySelectedKeys: const ['name'],
                      onSelected: (value) {
                        controller.city.text = value['name'];
                        controller.cityId.value = value['_id'];
                        controller.isQuotationModified.value = true;
                      },
                      onDelete: () {
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
                      isCapitaLetters: true,
                      onChanged: (_) {
                        controller.isQuotationModified.value = true;
                      },
                    ),
                    const SizedBox(width: 10),
                    MenuWithValues(
                      labelText: 'Engine Type',
                      headerLqabel: 'Engine Types',
                      dialogWidth: constraints.maxWidth / 3,
                      width: 200,
                      controller: controller.engineType,
                      displayKeys: const ['name'],
                      displaySelectedKeys: const ['name'],
                      onSelected: (value) {
                        controller.engineType.text = value['name'];
                        controller.engineTypeId.value = value['_id'];
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
