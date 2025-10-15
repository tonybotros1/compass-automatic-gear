import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../consts.dart';

Widget carDetailsSection() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<QuotationCardController>(
      builder: (controller) {
        return Column(
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 10,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.carBrand.text,
                    hintText: 'Brand',
                    onChanged: (key, value) {
                      controller.carBrandLogo.value = value['logo'];
                      controller.carBrand.text = value['name'];
                      controller.getModelsByCarBrand(key);
                      controller.carBrandId.value = key;
                    },
                    onDelete: () {
                      controller.carBrandLogo.value = '';
                      controller.carBrand.clear();
                      controller.carModel.clear();
                      controller.allModels.clear();
                      controller.carBrandId.value = '';
                      controller.isQuotationModified.value = true;
                    },
                    onOpen: () {
                      return controller.getCarBrands();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: carLogo(controller.carBrandLogo.value),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.carModel.text,
                    hintText: 'Model',
                    items: controller.allModels.isEmpty
                        ? {}
                        : controller.allModels,
                    onChanged: (key, value) {
                      controller.carModel.text = value['name'];
                      controller.carModelId.value = key;
                    },
                    onDelete: () {
                      controller.carModel.clear();
                      controller.carModelId.value = '';
                      controller.isQuotationModified.value = true;
                    },
                  ),
                ),
                Expanded(
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.color.text,
                    hintText: 'Color',
                    onChanged: (key, value) {
                      controller.color.text = value['name'];
                      controller.colorId.value = key;
                    },
                    onDelete: () {
                      controller.color.clear();
                      controller.colorId.value = '';
                    },
                    onOpen: () {
                      return controller.getColors();
                    },
                  ),
                ),
                Expanded(
                  child: myTextFormFieldWithBorder(
                    controller: controller.year,
                    labelText: 'Year',
                    hintText: 'Enter Year',
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    controller: controller.plateNumber,
                    labelText: 'Plate No.',
                    hintText: 'Enter Plate No.',
                  ),
                ),
                Expanded(
                  child: myTextFormFieldWithBorder(
                    controller: controller.plateCode,
                    labelText: 'Code',
                    hintText: 'Enter Plate Code',
                    isCapitaLetters: true,
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox()),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.country.text,
                    hintText: 'Country',
                    onChanged: (key, value) {
                      controller.country.text = value['name'];
                      controller.city.clear();
                      controller.getCitiesByCountryID(key);
                      controller.countryId.value = key;
                    },
                    onDelete: () {
                      controller.country.clear();
                      controller.city.clear();
                      controller.allCities.clear();
                      controller.countryId.value = '';
                    },
                    onOpen: () {
                      return controller.getCountries();
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.city.text,
                    hintText: 'City',
                    items: controller.allCities.isEmpty
                        ? {}
                        : controller.allCities,
                    onChanged: (key, value) {
                      controller.country.text = value['name'];
                      controller.city.clear();
                      controller.city.text = value['name'];
                      controller.cityId.value = key;
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    controller: controller.transmissionType,
                    labelText: 'Transmission Type',
                    hintText: 'Enter Transmission Type',
                    isCapitaLetters: true,
                  ),
                ),
                Expanded(
                  child: CustomDropdown(
                    showedSelectedName: 'name',
                    textcontroller: controller.engineType.text,
                    hintText: 'Engine Type',
                    onChanged: (key, value) {
                      controller.engineType.text = value['name'];
                      controller.engineTypeId.value = key;
                    },
                    onDelete: () {
                      controller.engineType.clear();
                      controller.engineTypeId.value = '';
                    },
                    onOpen: () {
                      return controller.getEngineTypes();
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    controller: controller.vin,
                    labelText: 'VIN',
                    hintText: 'Enter VIN',
                    isCapitaLetters: true,
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    isnumber: true,
                    controller: controller.mileageIn.value,
                    labelText: 'Mileage In',
                    hintText: 'Enter Mileage In',
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        );
      },
    ),
  );
}
