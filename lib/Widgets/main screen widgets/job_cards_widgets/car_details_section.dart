import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../consts.dart';
import '../add_new_values_button.dart';

Widget carDetailsSection(
  JobCardController controller,
  BoxConstraints constraints,
) {
  return FocusTraversalGroup(
    policy: WidgetOrderTraversalPolicy(),
    child: Scrollbar(
      thumbVisibility: true,
      controller: controller.scrollerForCarDetails,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: containerDecor,
        width: double.infinity,
        child: GetX<JobCardController>(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropdown(
                            focusNode: controller.focusNodeForCardDetails1,
                            nextFocusNode: controller.focusNodeForCardDetails2,
                            width: 325,
                            showedSelectedName: 'name',
                            textcontroller: controller.carBrand.text,
                            hintText: 'Brand',
                            items: const {},
                            onChanged: (key, value) {
                              controller.carBrandLogo.value =
                                  value['logo'] ?? "";
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
                              controller.carBrandId.value = "";
                              controller.carModelId.value = "";
                              controller.isJobModified.value = true;
                            },
                            onOpen: () async {
                              return await controller.getCarBrands();
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                focusNode: controller.focusNodeForCardDetails2,
                                nextFocusNode:
                                    controller.focusNodeForCardDetails3,
                                width: 325,
                                showedSelectedName: 'name',
                                textcontroller: controller.carModel.text,
                                hintText: 'Model',
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
                            spacing: 10,
                            children: [
                              myTextFormFieldWithBorder(
                                focusNode: controller.focusNodeForCardDetails4,
                                width: 115,
                                controller: controller.year,
                                labelText: 'Year',
                                hintText: 'Enter Year',
                                onChanged: (_) {
                                  controller.isJobModified.value = true;
                                },
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomDropdown(
                                    focusNode:
                                        controller.focusNodeForCardDetails3,
                                    nextFocusNode:
                                        controller.focusNodeForCardDetails4,
                                    width: 200,
                                    showedSelectedName: 'name',
                                    textcontroller: controller.color.text,
                                    hintText: 'Color',
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
                                    onOpen: () async {
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
                        focusNode: controller.focusNodeForCardDetails5,
                        width: 115,
                        controller: controller.plateNumber,
                        labelText: 'Plate No.',
                        hintText: 'Enter Plate No.',
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                      myTextFormFieldWithBorder(
                        focusNode: controller.focusNodeForCardDetails6,
                        // nextFocusNode: controller.focusNodeForCardDetails7,
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
                  Row(
                    spacing: 10,
                    children: [
                      CustomDropdown(
                        focusNode: controller.focusNodeForCardDetails7,
                        nextFocusNode: controller.focusNodeForCardDetails8,
                        width: 240,
                        showedSelectedName: 'name',
                        textcontroller: controller.country.text,
                        hintText: 'Country',
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
                          controller.countryId.value = "";
                          controller.isJobModified.value = true;
                        },
                        onOpen: () {
                          return controller.getCountries();
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomDropdown(
                            focusNode: controller.focusNodeForCardDetails8,
                            nextFocusNode: controller.focusNodeForCardDetails9,
                            width: 200,
                            showedSelectedName: 'name',
                            textcontroller: controller.city.text,
                            hintText: 'City',

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
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      myTextFormFieldWithBorder(
                        focusNode: controller.focusNodeForCardDetails9,
                        width: 240,
                        controller: controller.transmissionType,
                        labelText: 'Transmission Type',
                        hintText: 'Enter Transmission Type',
                        isCapitaLetters: true,
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                      const SizedBox(width: 10),
                      CustomDropdown(
                        focusNode: controller.focusNodeForCardDetails10,
                        nextFocusNode: controller.focusNodeForCardDetails11,
                        width: 200,
                        showedSelectedName: 'name',
                        textcontroller: controller.engineType.text,
                        hintText: 'Engine Type',
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
                    focusNode: controller.focusNodeForCardDetails11,
                    width: 450,
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
                        focusNode: controller.focusNodeForCardDetails12,
                        width: 105,
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
                        focusNode: controller.focusNodeForCardDetails13,
                        width: 105,
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
                        width: 105,
                        isEnabled: false,
                        controller: controller.inOutDiff.value,
                        labelText: 'Difference',
                      ),
                      myTextFormFieldWithBorder(
                        focusNode: controller.focusNodeForCardDetails14,
                        width: 105,
                        isnumber: true,
                        controller: controller.minTestKms.value,
                        labelText: 'Testing KMs',
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
