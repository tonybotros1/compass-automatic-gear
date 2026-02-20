import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
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
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MenuWithValues(
                            focusNode: controller.focusNodeForCardDetails1,
                            nextFocusNode: controller.focusNodeForCardDetails2,
                            headerLqabel: 'Car Brands',
                            dialogWidth: constraints.maxWidth / 4,
                            width: 325,
                            labelText: 'Brand',
                            controller: controller.carBrand,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getCarBrands();
                            },
                            onDelete: () {
                              controller.carBrandLogo.value = "";
                              controller.carBrand.clear();
                              controller.carModel.clear();
                              controller.carBrandId.value = "";
                              controller.carModelId.value = "";
                              controller.isJobModified.value = true;
                            },
                            onSelected: (value) {
                              controller.carBrandLogo.value =
                                  value['logo'] ?? "";
                              controller.carBrand.text = value['name'] ?? "";
                              controller.carModel.clear();
                              controller.getModelsByCarBrand(value['_id']);
                              controller.carBrandId.value = value['_id'];
                              controller.isJobModified.value = true;
                            },
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MenuWithValues(
                                focusNode: controller.focusNodeForCardDetails2,
                                nextFocusNode:
                                    controller.focusNodeForCardDetails3,
                                headerLqabel: 'Car Models',
                                dialogWidth: constraints.maxWidth / 4,
                                width: 325,
                                labelText: 'Model',
                                controller: controller.carModel,
                                displayKeys: const ['name'],
                                displaySelectedKeys: const ['name'],
                                onOpen: () {
                                  return controller.getModelsByCarBrand(
                                    controller.carBrandId.value,
                                  );
                                },
                                onDelete: () {
                                  controller.carModel.clear();
                                  controller.carModelId.value = "";
                                  controller.isJobModified.value = true;
                                },
                                onSelected: (value) {
                                  controller.carModel.text = value['name'];
                                  controller.carModelId.value = value['_id'];
                                  controller.isJobModified.value = true;
                                },
                              ),

                              ExcludeFocus(
                                child: valSectionInTheTableForBrands(
                                  controller.carBrandsController,
                                  controller.carBrandId.value,
                                  constraints,
                                  'New Model',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              myTextFormFieldWithBorder(
                                focusNode: controller.focusNodeForCardDetails3,

                                onFieldSubmitted: (_) {
                                  controller.focusNodeForCardDetails4
                                      .requestFocus();
                                },
                                width: 115,
                                controller: controller.year,
                                labelText: 'Year',
                                onChanged: (_) {
                                  controller.isJobModified.value = true;
                                },
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MenuWithValues(
                                    focusNode:
                                        controller.focusNodeForCardDetails4,
                                    nextFocusNode:
                                        controller.focusNodeForCardDetails5,

                                    headerLqabel: 'Colors',
                                    dialogWidth: constraints.maxWidth / 4,
                                    width: 200,
                                    labelText: 'Color',
                                    controller: controller.color,
                                    displayKeys: const ['name'],
                                    displaySelectedKeys: const ['name'],
                                    onOpen: () {
                                      return controller.getColors();
                                    },
                                    onDelete: () {
                                      controller.color.clear();
                                      controller.colorId.value = "";
                                      controller.isJobModified.value = true;
                                    },
                                    onSelected: (value) {
                                      controller.color.text = value['name'];
                                      controller.colorId.value = value['_id'];
                                      controller.isJobModified.value = true;
                                    },
                                  ),

                                  ExcludeFocus(
                                    child: valSectionInTheTable(
                                      controller.listOfValuesController,
                                      constraints,
                                      'COLORS',
                                      'New Color',
                                      'Colors',
                                    ),
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
                        onFieldSubmitted: (_) =>
                            controller.focusNodeForCardDetails6.requestFocus(),
                        width: 115,
                        controller: controller.plateNumber,
                        labelText: 'Plate No.',
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                      myTextFormFieldWithBorder(
                        focusNode: controller.focusNodeForCardDetails6,
                        onFieldSubmitted: (_) =>
                            controller.focusNodeForCardDetails7.requestFocus(),
                        width: 115,
                        isCapitaLetters: true,
                        controller: controller.plateCode,
                        labelText: 'Code',
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      MenuWithValues(
                        focusNode: controller.focusNodeForCardDetails7,
                        nextFocusNode: controller.focusNodeForCardDetails8,

                        headerLqabel: 'Countries',
                        dialogWidth: constraints.maxWidth / 4,
                        width: 240,
                        labelText: 'Country',
                        controller: controller.country,
                        displayKeys: const ['name'],
                        displaySelectedKeys: const ['name'],
                        onOpen: () {
                          return controller.getCountries();
                        },
                        onDelete: () {
                          controller.country.clear();
                          controller.city.clear();
                          controller.countryId.value = "";
                          controller.isJobModified.value = true;
                        },
                        onSelected: (value) {
                          controller.country.text = value['name'] ?? "";
                          controller.city.clear();
                          controller.getCitiesByCountryID(value['_id']);
                          controller.countryId.value = value['_id'];
                          controller.isJobModified.value = true;
                        },
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MenuWithValues(
                            focusNode: controller.focusNodeForCardDetails8,
                            nextFocusNode: controller.focusNodeForCardDetails9,

                            headerLqabel: 'Cities',
                            dialogWidth: constraints.maxWidth / 4,
                            width: 200,
                            labelText: 'City',
                            controller: controller.city,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getCitiesByCountryID(
                                controller.countryId.value,
                              );
                            },
                            onDelete: () {
                              controller.city.clear();
                              controller.cityId.value = "";
                              controller.isJobModified.value = true;
                            },
                            onSelected: (value) {
                              controller.city.text = value['name'] ?? "";
                              controller.cityId.value = value['_id'];
                              controller.isJobModified.value = true;
                            },
                          ),

                          ExcludeFocus(
                            child: valSectionInTheTableForCountries(
                              controller.countriesController,
                              controller.countryId.value,
                              constraints,
                              'New City',
                            ),
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
                        onFieldSubmitted: (_) =>
                            controller.focusNodeForCardDetails10.requestFocus(),
                        width: 240,
                        controller: controller.transmissionType,
                        labelText: 'Transmission Type',
                        isCapitaLetters: true,
                        onChanged: (_) {
                          controller.isJobModified.value = true;
                        },
                      ),
                      const SizedBox(width: 10),
                      MenuWithValues(
                        focusNode: controller.focusNodeForCardDetails10,
                        nextFocusNode: controller.focusNodeForCardDetails11,
                        headerLqabel: 'Engine Types',
                        dialogWidth: constraints.maxWidth / 4,
                        width: 200,
                        labelText: 'Engine Type',
                        controller: controller.engineType,
                        displayKeys: const ['name'],
                        displaySelectedKeys: const ['name'],
                        onOpen: () {
                          return controller.getEngineTypes();
                        },
                        onDelete: () {
                          controller.engineType.clear();
                          controller.engineTypeId.value = "";
                          controller.isJobModified.value = true;
                        },
                        onSelected: (value) {
                          controller.engineType.text = value['name'] ?? "";
                          controller.engineTypeId.value = value['_id'];
                          controller.isJobModified.value = true;
                        },
                      ),

                      ExcludeFocus(
                        child: valSectionInTheTable(
                          controller.listOfValuesController,
                          constraints,
                          'ENGINE_TYPES',
                          'New Engine Type',
                          'Engine Type',
                        ),
                      ),
                    ],
                  ),
                  myTextFormFieldWithBorder(
                    focusNode: controller.focusNodeForCardDetails11,
                    onFieldSubmitted: (_) =>
                        controller.focusNodeForCardDetails12.requestFocus(),
                    width: 450,
                    controller: controller.vin,
                    labelText: 'VIN',
                    isCapitaLetters: true,
                    onChanged: (_) {
                      controller.isJobModified.value = true;
                    },
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      myTextFormFieldWithBorder(
                        focusNode: controller.focusNodeForCardDetails12,
                        onFieldSubmitted: (_) =>
                            controller.focusNodeForCardDetails13.requestFocus(),
                        width: 105,
                        isnumber: true,
                        controller: controller.mileageIn.value,
                        labelText: 'Mileage In',
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
                        onFieldSubmitted: (_) =>
                            controller.focusNodeForCardDetails14.requestFocus(),
                        width: 105,
                        isnumber: true,
                        controller: controller.mileageOut.value,
                        labelText: 'Mileage Out',
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
                        onFieldSubmitted: (_) => controller
                            .focusNodeForCustomerDetails1
                            .requestFocus(),
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
