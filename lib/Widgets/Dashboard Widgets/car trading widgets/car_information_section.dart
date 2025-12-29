import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../main screen widgets/add_new_values_button.dart';
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
                        // focusNode: controller.focusNodeForCarInformation1,
                        // nextFocusNode: controller.focusNodeForCarInformation2,
                        width: 130,
                        controller: controller.date.value,
                        labelText: 'Transaction Date',
                        onFieldSubmitted: (_) async {
                          normalizeDate(
                            controller.date.value.text,
                            controller.date.value,
                          );
                        },
                        onChanged: (_) {
                          controller.carModified.value = true;
                        },
                        isEnabled: false,
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
                            // focusNode: controller.focusNodeForCarInformation2,
                            // nextFocusNode:
                            //     controller.focusNodeForCarInformation3,
                            width: 180,
                            showedSelectedName: 'name',
                            textcontroller: controller.carBrand.value.text,
                            hintText: 'Car Brand',
                            onChanged: (key, value) {
                              controller.carModel.value.clear();
                              // controller.getModelsByCarBrand(key);
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
                            constraints,
                            'CAR_SPECIFICATIONS',
                            'New Car Specification',
                            'Car Specification',
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
                            constraints,
                            'COLORS',
                            'New Color',
                            'Colors',
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              GetX<CarTradingDashboardController>(
                builder: (controller) {
                  return Column(
                    spacing: 10,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomDropdown(
                            // focusNode: controller.focusNodeForCarInformation3,
                            // nextFocusNode:
                            //     controller.focusNodeForCarInformation4,
                            width: 180,
                            showedSelectedName: 'name',
                            textcontroller: controller.carModel.value.text,
                            hintText: 'Car Model',
                            // items: isModelLoading ? {} : controller.allModels,
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
                            constraints,
                            'ENGINE_TYPES',
                            'New Engine Size',
                            'Engine Size',
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
                            constraints,
                            'YEARS',
                            'New Year',
                            'Years',
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
