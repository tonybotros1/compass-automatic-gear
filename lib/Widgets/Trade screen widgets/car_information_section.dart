import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Trading Controllers/car_trading_controller.dart';
import '../../consts.dart';
import '../drop_down_menu3.dart';
import '../my_text_field.dart';

Container carInformation({
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: GetX<CarTradingController>(builder: (controller) {
          bool isColorsLoading = controller.allColors.isEmpty;
          return Column(
            spacing: 10,
            children: [
              myTextFormFieldWithBorder(
                controller: controller.date.value,
                labelText: 'Date',
                isDate: true,
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.date.value);
                    },
                    icon: const Icon(Icons.date_range)),
              ),
              myTextFormFieldWithBorder(
                  labelText: 'Mileage',
                  isnumber: true,
                  controller: controller.mileage.value),
              CustomDropdown(
                textcontroller: controller.colorOut.value.text,
                hintText: 'Color (OUT)',
                showedSelectedName: 'name',
                items: isColorsLoading ? {} : controller.allColors,
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text(value['name']),
                  );
                },
                onChanged: (key, value) {
                  controller.colorOut.value.text = value['name'];
                  controller.colorOutId.value = key;
                },
              )
            ],
          );
        })),
        Expanded(
            flex: 2,
            child: GetX<CarTradingController>(builder: (controller) {
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
                          itemBuilder: (context, key, value) {
                            return ListTile(
                              title: Text(value['name']),
                            );
                          },
                          onChanged: (key, value) {
                            controller.carModel.value.clear();
                            controller.getModelsByCarBrand(key);
                            controller.carBrand.value.text = value['name'];
                            controller.carBrandId.value = key;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        tooltip: 'New Car Brand',
                      )
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
                          itemBuilder: (context, key, value) {
                            return ListTile(
                              title: Text(value['name']),
                            );
                          },
                          onChanged: (key, value) {
                            controller.carSpecification.value.text =
                                value['name'];
                            controller.carSpecificationId.value = key;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        tooltip: 'New Specification',
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          textcontroller: controller.colorIn.value.text,
                          showedSelectedName: 'name',
                          hintText: 'Color (IN)',
                          items: isColorsLoading ? {} : controller.allColors,
                          itemBuilder: (context, key, value) {
                            return ListTile(
                              title: Text(value['name']),
                            );
                          },
                          onChanged: (key, value) {
                            controller.colorIn.value.text = value['name'];
                            controller.colorInId.value = key;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        tooltip: 'New Color',
                      )
                    ],
                  ),
                ],
              );
            })),
        Expanded(
            flex: 2,
            child: GetX<CarTradingController>(builder: (controller) {
              bool isModelLoading = controller.allModels.isEmpty;
              bool isEngineSizeLoading = controller.allEngineSizes.isEmpty;
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
                          itemBuilder: (context, key, value) {
                            return ListTile(
                              title: Text(value['name']),
                            );
                          },
                          onChanged: (key, value) {
                            controller.carModel.value.text = value['name'];
                            controller.carModelId.value = key;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        tooltip: 'New Car Model',
                      )
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
                          itemBuilder: (context, key, value) {
                            return ListTile(
                              title: Text(value['name']),
                            );
                          },
                          onChanged: (key, value) {
                            controller.engineSize.value.text = value['name'];
                            controller.engineSizeId.value = key;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        tooltip: 'New Engine Size',
                      )
                    ],
                  )
                ],
              );
            })),
        Expanded(
            flex: 1,
            child: GetX<CarTradingController>(builder: (controller) {
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
                          textcontroller: controller.year.value.text,
                          hintText: 'Year',
                          items: isYearsLoading ? {} : controller.allYears,
                          itemBuilder: (context, key, value) {
                            return ListTile(
                              title: Text(value['name']),
                            );
                          },
                          onChanged: (key, value) {
                            controller.year.value.text = value['name'];
                            controller.yearId.value = key;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        tooltip: 'New Year',
                      )
                    ],
                  )
                ],
              );
            })),
        Expanded(
          flex: 2,
          child: GetBuilder<CarTradingController>(builder: (controller) {
            return myTextFormFieldWithBorder(
                controller: controller.note, labelText: 'Note', maxLines: 7);
          }),
        )
      ],
    ),
  );
}
