import 'package:datahubai/Controllers/Main%20screen%20controllers/branches_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Widget addNewBranchOrEdit({
  required BranchesController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(height: 5),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.code,
        labelText: 'Code',
        validate: true,
      ),
      const SizedBox(height: 10),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.name,
        labelText: 'Name',
        validate: true,
      ),
      const SizedBox(height: 10),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.line,
        labelText: 'Line',
        validate: true,
      ),
      const SizedBox(height: 10),
      GetX<BranchesController>(
        builder: (controller) {
          var isCountryLoading = controller.allCountries.isEmpty;
          return MenuWithValues(
            labelText: 'Country',
            headerLqabel: 'Countries',
            dialogWidth: 600,
            data: isCountryLoading ? {} : controller.allCountries,
            controller: controller.country,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onDelete: () {
              controller.country.clear();
              controller.allCities.clear();
              controller.countryId.value = '';
            },
            onSelected: (value) {
              controller.country.text = value['name'];
              controller.getCitiesByCountryID(value['_id']);
              controller.city.clear();
              controller.countryId.value = value['_id'];
            },
          );
        },
      ),
      const SizedBox(height: 10),
      GetX<BranchesController>(
        builder: (controller) {
          var isCityLoading = controller.allCities.isEmpty;

          return MenuWithValues(
            labelText: 'City',
            headerLqabel: 'Cities',
            dialogWidth: 600,
            data: isCityLoading ? {} : controller.allCities,
            controller: controller.city,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onDelete: () {
              controller.city.clear();
              controller.cityId.value = '';
            },
            onSelected: (value) {
              controller.city.text = value['name'];
              controller.cityId.value = value['_id'];
            },
          );
        },
      ),
    ],
  );
}
