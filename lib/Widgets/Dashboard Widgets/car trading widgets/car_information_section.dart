import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Controllers/Main screen controllers/car_brands_controller.dart';
import '../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../main screen widgets/car_brands_widgets/values_section_models.dart';
import '../../my_text_field.dart';

Container carInformation({
  required BuildContext context,
  required BoxConstraints constraints,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: GetX<CarTradingDashboardController>(
            builder: (controller) {
              bool isColorsLoading = controller.allColors.isEmpty;
              return Column(
                spacing: 10,
                children: [
                  myTextFormFieldWithBorder(
                    controller: controller.date.value,
                    labelText: 'Date',
                    onFieldSubmitted: (_) async {
                      normalizeDate(
                        controller.date.value.text,
                        controller.date.value,
                      );
                    },
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'Mileage',
                    isnumber: true,
                    controller: controller.mileage.value,
                  ),
                  CustomDropdown(
                    width: double.infinity,
                    textcontroller: controller.colorOut.value.text,
                    hintText: 'Outside Color',
                    showedSelectedName: 'name',
                    items: isColorsLoading ? {} : controller.allColors,
                    onChanged: (key, value) {
                      controller.colorOut.value.text = value['name'];
                      controller.colorOutId.value = key;
                    },
                  ),
                ],
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: GetX<CarTradingDashboardController>(
            builder: (controller) {
              bool isColorsLoading = controller.allColors.isEmpty;
              bool isCarSpecificationsLoading =
                  controller.allCarSpecifications.isEmpty;
              bool isBrandsLoading = controller.allBrands.isEmpty;
              return Column(
                spacing: 10,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          showedSelectedName: 'name',
                          textcontroller: controller.carBrand.value.text,
                          hintText: 'Car Brand',
                          items: isBrandsLoading ? {} : controller.allBrands,
                          onChanged: (key, value) {
                            controller.carModel.value.clear();
                            controller.getModelsByCarBrand(key);
                            controller.carBrand.value.text = value['name'];
                            controller.carBrandId.value = key;
                          },
                          onDelete: () {
                            controller.allModels.clear();
                            controller.carModel.value.clear();
                            controller.carModelId.value = '';
                          },
                        ),
                      ),
                      // const IconButton(onPressed: null, icon: SizedBox()),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          textcontroller:
                              controller.carSpecification.value.text,
                          showedSelectedName: 'name',
                          hintText: 'Specification',
                          items: isCarSpecificationsLoading
                              ? {}
                              : controller.allCarSpecifications,
                          onChanged: (key, value) {
                            controller.carSpecification.value.text =
                                value['name'];
                            controller.carSpecificationId.value = key;
                          },
                        ),
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
                      Expanded(
                        child: CustomDropdown(
                          textcontroller: controller.colorIn.value.text,
                          showedSelectedName: 'name',
                          hintText: 'Inside Color',
                          items: isColorsLoading ? {} : controller.allColors,
                          onChanged: (key, value) {
                            controller.colorIn.value.text = value['name'];
                            controller.colorInId.value = key;
                          },
                        ),
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
        ),
        Expanded(
          flex: 1,
          child: GetX<CarTradingDashboardController>(
            builder: (controller) {
              bool isModelLoading = controller.allModels.isEmpty;
              bool isEngineSizeLoading = controller.allEngineSizes.isEmpty;
              bool isYearsLoading = controller.allYears.isEmpty;

              return Column(
                spacing: 10,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          showedSelectedName: 'name',
                          textcontroller: controller.carModel.value.text,
                          hintText: 'Car Model',
                          items: isModelLoading ? {} : controller.allModels,
                          onChanged: (key, value) {
                            controller.carModel.value.text = value['name'];
                            controller.carModelId.value = key;
                          },
                        ),
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
                      Expanded(
                        child: CustomDropdown(
                          textcontroller: controller.engineSize.value.text,
                          showedSelectedName: 'name',
                          hintText: 'Engine Size',
                          items: isEngineSizeLoading
                              ? {}
                              : controller.allEngineSizes,
                          onChanged: (key, value) {
                            controller.engineSize.value.text = value['name'];
                            controller.engineSizeId.value = key;
                          },
                        ),
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
                      Expanded(
                        child: CustomDropdown(
                          showedSelectedName: 'name',
                          textcontroller: controller.year.value.text,
                          hintText: 'Year',
                          items: isYearsLoading ? {} : controller.allYears,
                          onChanged: (key, value) {
                            controller.year.value.text = value['name'];
                            controller.yearId.value = key;
                          },
                        ),
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
        ),
        Expanded(
          flex: 1,
          child: GetX<CarTradingDashboardController>(
            builder: (controller) {
              bool isBuyersAndSellersLoading =
                  controller.allBuyersAndSellers.isEmpty;

              return Column(
                spacing: 10,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          textcontroller: controller.boughtFrom.value.text,
                          showedSelectedName: 'name',
                          hintText: 'Bought From',
                          items: isBuyersAndSellersLoading
                              ? {}
                              : controller.allBuyersAndSellers,
                          onChanged: (key, value) {
                            controller.boughtFrom.value.text = value['name'];
                            controller.boughtFromId.value = key;
                          },
                        ),
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
                      Expanded(
                        child: CustomDropdown(
                          showedSelectedName: 'name',
                          textcontroller: controller.soldTo.value.text,
                          hintText: 'Sold To',
                          items: isBuyersAndSellersLoading
                              ? {}
                              : controller.allBuyersAndSellers,
                          onChanged: (key, value) {
                            controller.soldTo.value.text = value['name'];
                            controller.soldToId.value = key;
                          },
                        ),
                      ),
                      // const IconButton(onPressed: null, icon: SizedBox()),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: GetBuilder<CarTradingDashboardController>(
            builder: (controller) {
              return myTextFormFieldWithBorder(
                controller: controller.note,
                labelText: 'Note',
                maxLines: 7,
              );
            },
          ),
        ),
      ],
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
