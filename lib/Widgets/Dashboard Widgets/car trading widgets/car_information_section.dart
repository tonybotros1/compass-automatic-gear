import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Controllers/Main screen controllers/car_brands_controller.dart';
import '../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../main screen widgets/car_brands_widgets/values_section_models.dart';
import '../../main screen widgets/lists_widgets/values_section_in_list_of_values.dart';
import '../../my_text_field.dart';

Widget carInformation({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return FocusTraversalGroup(
    policy: WidgetOrderTraversalPolicy(),
    child: Scrollbar(
      thickness: 8,
      controller: controller.scrollControllerForCarInformation,
      trackVisibility: true,
      child: Container(
        height: 225,
        width: constraints.maxWidth,
        padding: const EdgeInsets.all(20),
        decoration: containerDecor,
        child: SingleChildScrollView(
          controller: controller.scrollControllerForCarInformation,
          scrollDirection: Axis.horizontal,
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
                        focusNode: controller.focusNodeForCarInformation1,
                        nextFocusNode: controller.focusNodeForCarInformation2,
                        width: 130,
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
                        // focusNode: controller.focusNodeForCarInformation4,
                        width: 130,
                        labelText: 'Mileage',
                        isnumber: true,
                        controller: controller.mileage.value,
                        onChanged: (_) {
                          controller.carModified.value = true;
                        },
                      ),
                      CustomDropdown(
                        // focusNode: controller.focusNodeForCarInformation7,
                        // nextFocusNode: controller.focusNodeForCarInformation8,
                        width: 130,
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
                            focusNode: controller.focusNodeForCarInformation2,
                            nextFocusNode:
                                controller.focusNodeForCarInformation3,
                            width: 180,
                            showedSelectedName: 'name',
                            textcontroller: controller.carBrand.value.text,
                            hintText: 'Car Brand',
                            onChanged: (key, value) {
                              controller.carModel.value.clear();
                              controller.getModelsByCarBrand(key);
                              controller.carBrand.value.text = value['name'];
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
                          const IconButton(onPressed: null, icon: SizedBox()),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomDropdown(
                            // focusNode: controller.focusNodeForCarInformation5,
                            // nextFocusNode: controller.focusNodeForCarInformation6,
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
                          valSectionInTheTable(
                            controller.listOfValuesController,
                            context,
                            constraints,
                            'CAR_SPECIFICATIONS',
                            'New Car Specification',
                            'Car Specification',
                            valuesSection(
                              constraints: constraints,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomDropdown(
                            // focusNode: controller.focusNodeForCarInformation8,
                            // nextFocusNode: controller.focusNodeForCarInformation9,
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
                          valSectionInTheTable(
                            controller.listOfValuesController,
                            context,
                            constraints,
                            'COLORS',
                            'New Color',
                            'Colors',
                            valuesSection(
                              constraints: constraints,
                              context: context,
                            ),
                          ),
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
                            focusNode: controller.focusNodeForCarInformation3,
                            nextFocusNode:
                                controller.focusNodeForCarInformation4,
                            width: 180,
                            showedSelectedName: 'name',
                            textcontroller: controller.carModel.value.text,
                            hintText: 'Car Model',
                            items: isModelLoading ? {} : controller.allModels,
                            onChanged: (key, value) {
                              controller.carModel.value.text = value['name'];
                              controller.carModelId.value = key;
                              controller.carModified.value = true;
                            },
                            onDelete: () {
                              controller.carModel.value.clear();
                              controller.carModelId.value = '';
                              controller.carModified.value = true;
                            },
                          ),
                          valSectionInTheTableForBrands(
                            controller.carBrandsController,
                            controller.carBrandId.value,
                            context,
                            constraints,
                            'New Model',
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomDropdown(
                            // focusNode: controller.focusNodeForCarInformation6,
                            // nextFocusNode: controller.focusNodeForCarInformation7,
                            width: 180,
                            textcontroller: controller.engineSize.value.text,
                            showedSelectedName: 'name',
                            hintText: 'Engine Size',

                            onChanged: (key, value) {
                              controller.engineSize.value.text = value['name'];
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
                          valSectionInTheTable(
                            controller.listOfValuesController,
                            context,
                            constraints,
                            'ENGINE_TYPES',
                            'New Engine Size',
                            'Engine Size',
                            valuesSection(
                              constraints: constraints,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomDropdown(
                            // focusNode: controller.focusNodeForCarInformation9,
                            // nextFocusNode: controller.focusNodeForBuySell1,
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
                          valSectionInTheTable(
                            controller.listOfValuesController,
                            context,
                            constraints,
                            'CAR_SPECIFICATIONS',
                            'New Year',
                            'Years',
                            valuesSection(
                              constraints: constraints,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget valSectionInTheTable(
  ListOfValuesController controller,
  BuildContext context,
  BoxConstraints constraints,
  String code,
  String tooltip,
  String screenName,
  Widget screen,
) {
  return IconButton(
    tooltip: tooltip,
    onPressed: () async {
      Map jsonData = await helper.getListDetails(code);
      String listId = jsonData['_id'];
      String masteredBy = jsonData['mastered_by'];
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
                      closeIcon(),
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
    icon: const Icon(Icons.add_card),
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
                        closeIcon(),
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
    icon: const Icon(Icons.add_card),
  );
}
