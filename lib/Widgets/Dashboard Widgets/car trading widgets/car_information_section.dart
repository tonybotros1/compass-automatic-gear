import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Controllers/Main screen controllers/car_brands_controller.dart';
import '../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../main screen widgets/car_brands_widgets/values_section_models.dart';
import '../../my_text_field.dart';

Widget carInformation({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return Scrollbar(
    controller: controller.scrollController,
    thumbVisibility: true,
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: containerDecor,
          child: SingleChildScrollView(
            controller: controller.scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth - 48),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<CarTradingDashboardController>(
                    builder: (controller) {
                      return Column(
                        spacing: 10,
                        children: [
                          myTextFormFieldWithBorder(
                            width: 150,
                            controller: controller.date.value,
                            labelText: 'Date',
                            onFieldSubmitted: (_) async {
                              normalizeDate(
                                controller.date.value.text,
                                controller.date.value,
                              );
                            },
                            onChanged: (_) {
                              controller.carModified.value = true;
                            },
                          ),
                          myTextFormFieldWithBorder(
                            width: 150,
                            labelText: 'Mileage',
                            isnumber: true,
                            controller: controller.mileage.value,
                            onChanged: (_) {
                              controller.carModified.value = true;
                            },
                          ),
                          CustomDropdown(
                            width: 150,
                            textcontroller: controller.colorOut.value.text,
                            hintText: 'Outside Color',
                            showedSelectedName: 'name',
                            onChanged: (key, value) {
                              controller.colorOut.value.text = value['name'];
                              controller.colorOutId.value = key;
                              controller.carModified.value = true;
                            },
                            onDelete: () {
                              controller.colorOut.value.clear();
                              controller.colorOutId.value = '';
                              controller.carModified.value = true;
                            },
                            onOpen: () {
                              return controller.getColors();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  GetBuilder<CarTradingDashboardController>(
                    builder: (controller) {
                      return Column(
                        spacing: 10,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 180,
                                showedSelectedName: 'name',
                                textcontroller: controller.carBrand.value.text,
                                hintText: 'Car Brand',
                                onChanged: (key, value) {
                                  controller.carModel.value.clear();
                                  controller.getModelsByCarBrand(key);
                                  controller.carBrand.value.text =
                                      value['name'];
                                  controller.carBrandId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.allModels.clear();
                                  controller.carModel.value.clear();
                                  controller.carModelId.value = '';
                                  controller.carBrand.value.clear();
                                  controller.carBrandId.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getCarBrands();
                                },
                              ),
                              // const IconButton(onPressed: null, icon: SizedBox()),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 180,
                                textcontroller:
                                    controller.carSpecification.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Specification',
                                onChanged: (key, value) {
                                  controller.carSpecification.value.text =
                                      value['name'];
                                  controller.carSpecificationId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.carSpecification.value.clear();
                                  controller.carSpecificationId.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getCarSpecefications();
                                },
                              ),
                              // valSectionInTheTable(
                              //   controller.listOfValuesController,
                              //   controller.carSpecificationsListId.value,
                              //   context,
                              //   constraints,
                              //   controller.carSpecificationsListMasteredById.value,
                              //   'New Car Specification',
                              //   'Car Specification',
                              //   valuesSection(
                              //     constraints: constraints,
                              //     context: context,
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 180,
                                textcontroller: controller.colorIn.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Inside Color',
                                onChanged: (key, value) {
                                  controller.colorIn.value.text = value['name'];
                                  controller.colorInId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.colorIn.value.clear();
                                  controller.colorInId.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getColors();
                                },
                              ),
                              // valSectionInTheTable(
                              //   controller.listOfValuesController,
                              //   controller.colorsListId.value,
                              //   context,
                              //   constraints,
                              //   controller.colorsListMasterdById.value,
                              //   'New Color',
                              //   'Colors',
                              //   valuesSection(
                              //     constraints: constraints,
                              //     context: context,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  GetX<CarTradingDashboardController>(
                    builder: (controller) {
                      bool isModelLoading = controller.allModels.isEmpty;

                      return Column(
                        spacing: 10,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 180,
                                showedSelectedName: 'name',
                                textcontroller: controller.carModel.value.text,
                                hintText: 'Car Model',
                                items: isModelLoading
                                    ? {}
                                    : controller.allModels,
                                onChanged: (key, value) {
                                  controller.carModel.value.text =
                                      value['name'];
                                  controller.carModelId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.carModel.value.clear();
                                  controller.carModelId.value = '';
                                  controller.carModified.value = true;
                                },
                              ),
                              // valSectionInTheTableForBrands(
                              //   controller.carBrandsController,
                              //   controller.carBrandId.value,
                              //   context,
                              //   constraints,
                              //   'New Model',
                              // ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 180,
                                textcontroller:
                                    controller.engineSize.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Engine Size',

                                onChanged: (key, value) {
                                  controller.engineSize.value.text =
                                      value['name'];
                                  controller.engineSizeId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.engineSize.value.clear();
                                  controller.engineSizeId.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getEngineTypes();
                                },
                              ),
                              // valSectionInTheTable(
                              //   controller.listOfValuesController,
                              //   controller.engineSizeListId.value,
                              //   context,
                              //   constraints,
                              //   controller.engineSizeListMasterdById.value,
                              //   'New Engine Size',
                              //   'Engine Size',
                              //   valuesSection(
                              //     constraints: constraints,
                              //     context: context,
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 180,
                                showedSelectedName: 'name',
                                textcontroller: controller.year.value.text,
                                hintText: 'Year',
                                onChanged: (key, value) {
                                  controller.year.value.text = value['name'];
                                  controller.yearId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.year.value.clear();
                                  controller.yearId.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getYears();
                                },
                              ),
                              // valSectionInTheTable(
                              //   controller.listOfValuesController,
                              //   controller.yearListId.value,
                              //   context,
                              //   constraints,
                              //   controller.yearListMasterdById.value,
                              //   'New Year',
                              //   'Years',
                              //   valuesSection(
                              //     constraints: constraints,
                              //     context: context,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  GetBuilder<CarTradingDashboardController>(
                    builder: (controller) {
                      return Column(
                        spacing: 10,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 200,
                                textcontroller:
                                    controller.boughtFrom.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Bought From',
                                onChanged: (key, value) {
                                  controller.boughtFrom.value.text =
                                      value['name'];
                                  controller.boughtFromId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.boughtFrom.value.clear();
                                  controller.boughtFromId.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getBuyersAndSellers();
                                },
                              ),
                              // valSectionInTheTable(
                              //   controller.listOfValuesController,
                              //   controller.buyersAndSellersListId.value,
                              //   context,
                              //   constraints,
                              //   controller.buyersAndSellersMasterdById.value,
                              //   'New Buyers and Sellers',
                              //   'Buyers and Sellers',
                              //   valuesSection(
                              //     constraints: constraints,
                              //     context: context,
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomDropdown(
                                width: 200,
                                showedSelectedName: 'name',
                                textcontroller: controller.soldTo.value.text,
                                hintText: 'Sold To',
                                onChanged: (key, value) {
                                  controller.soldTo.value.text = value['name'];
                                  controller.soldToId.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.soldTo.value.clear();
                                  controller.soldToId.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getBuyersAndSellers();
                                },
                              ),
                              // const IconButton(onPressed: null, icon: SizedBox()),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  GetBuilder<CarTradingDashboardController>(
                    builder: (controller) {
                      return Column(
                        spacing: 10,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomDropdown(
                                width: 200,
                                textcontroller:
                                    controller.boughtBy.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Bought By',
                                onChanged: (key, value) {
                                  controller.boughtBy.value.text =
                                      value['name'];
                                  controller.boughtById.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.boughtBy.value.clear();
                                  controller.boughtById.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getBuyersAndSellersBy();
                                },
                              ),
                              // valSectionInTheTable(
                              //   controller.listOfValuesController,
                              //   controller.buyersAndSellersListId.value,
                              //   context,
                              //   constraints,
                              //   controller.buyersAndSellersMasterdById.value,
                              //   'New Buyers and Sellers',
                              //   'Buyers and Sellers',
                              //   valuesSection(
                              //     constraints: constraints,
                              //     context: context,
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomDropdown(
                                width: 200,
                                showedSelectedName: 'name',
                                textcontroller: controller.soldBy.value.text,
                                hintText: 'Sold By',
                                onChanged: (key, value) {
                                  controller.soldBy.value.text = value['name'];
                                  controller.soldById.value = key;
                                  controller.carModified.value = true;
                                },
                                onDelete: () {
                                  controller.soldBy.value.clear();
                                  controller.soldById.value = '';
                                  controller.carModified.value = true;
                                },
                                onOpen: () {
                                  return controller.getBuyersAndSellersBy();
                                },
                              ),
                              // const IconButton(onPressed: null, icon: SizedBox()),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  GetBuilder<CarTradingDashboardController>(
                    builder: (controller) {
                      return myTextFormFieldWithBorder(
                        width: 580,
                        controller: controller.note,
                        labelText: 'Note',
                        maxLines: 7,
                        onChanged: (_) {
                          controller.carModified.value = true;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget valSectionInTheTable(
  ListOfValuesController controller,
  String listId,
  BuildContext context,
  BoxConstraints constraints,
  String masteredBy,
  String tooltip,
  String screenName,
  Widget screen,
) {
  return IconButton(
    tooltip: tooltip,
    onPressed: () {
      controller.searchForValues.value.clear();
      controller.valueMap.clear();
      controller.listIDToWorkWithNewValue.value = listId;
      controller.getListValues(listId, masteredBy);
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
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
                      closeButton,
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: screen,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    icon: const Icon(Icons.add),
  );
}

Widget valSectionInTheTableForBrands(
  CarBrandsController controller,
  String brandId,
  BuildContext context,
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
                          'Models',
                          style: fontStyleForScreenNameUsedInButtons,
                        ),
                        const Spacer(),
                        closeButton,
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: modelsSection(
                        constraints: constraints,
                        context: context,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        showSnackBar('Alert', 'Please select brand first');
      }
    },
    icon: const Icon(Icons.add),
  );
}
