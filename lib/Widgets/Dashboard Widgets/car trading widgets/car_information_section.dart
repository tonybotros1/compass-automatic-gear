import 'package:flutter/material.dart';
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
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, sectionConstraints) {
          return Row(
            spacing: 60,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  spacing: 10,
                  // crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    myTextFormFieldWithBorder(
                      width: 150,
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
                    CustomDropdown(
                      width: 300,
                      showedSelectedName: 'name',
                      textcontroller: controller.carBrand.value.text,
                      hintText: 'Car Brand',
                      onChanged: (key, value) {
                        controller.carModel.value.clear();
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
                    _ActionField(
                      field: CustomDropdown(
                        width: 300,
                        showedSelectedName: 'name',
                        textcontroller: controller.carModel.value.text,
                        hintText: 'Car Model',
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
                      action: valSectionInTheTableForBrands(
                        controller.carBrandsController,
                        controller.carBrandId.value,
                        constraints,
                        'New Model',
                      ),
                    ),
                    myTextFormFieldWithBorder(
                      width: 300,
                      controller: controller.carTrim.value,
                      labelText: 'Trim',
                      validate: false,
                      onChanged: (_) {
                        controller.carModified.value = true;
                      },
                    ),

                    myTextFormFieldWithBorder(
                      width: 200,
                      labelText: 'Mileage',
                      isnumber: true,
                      validate: false,
                      controller: controller.mileage.value,
                      onChanged: (_) {
                        controller.carModified.value = true;
                      },
                    ),

                    myTextFormFieldWithBorder(
                      width: 300,
                      labelText: 'VIN',
                      hintText: 'Enter VIN',
                      validate: false,
                      controller: controller.vin.value,
                      onChanged: (_) {
                        controller.carModified.value = true;
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    _ActionField(
                      field: CustomDropdown(
                        width: 200,
                        textcontroller: controller.carSpecification.value.text,
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
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'CAR_SPECIFICATIONS',
                        'New Car Specification',
                        'Car Specification',
                      ),
                    ),
                    _ActionField(
                      field: CustomDropdown(
                        width: 200,
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
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'ENGINE_TYPES',
                        'New Engine Size',
                        'Engine Size',
                      ),
                    ),
                    _ActionField(
                      field: CustomDropdown(
                        width: 200,
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
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'COLORS',
                        'New Color',
                        'Colors',
                      ),
                    ),
                    _ActionField(
                      field: CustomDropdown(
                        width: 200,
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
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'COLORS',
                        'New Color',
                        'Colors',
                      ),
                    ),
                    _ActionField(
                      field: CustomDropdown(
                        width: 150,
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
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'YEARS',
                        'New Year',
                        'Years',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _ActionField extends StatelessWidget {
  const _ActionField({required this.field, required this.action});

  final Widget field;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        field,
        const SizedBox(width: 6),
        SizedBox(width: 34, height: 38, child: action),
      ],
    );
  }
}
