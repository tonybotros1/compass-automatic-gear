import 'package:datahubai/Controllers/Main%20screen%20controllers/branches_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          return CustomDropdown(
            hintText: 'Country',
            textcontroller: controller.country.text,
            showedSelectedName: 'name',
            items: isCountryLoading ? {} : controller.allCountries,
            onChanged: (key, value) {
              controller.country.text = value['name'];
              controller.getCitiesByCountryID(key);
              controller.city.clear();
              controller.countryId.value = key;
            },
            onDelete: () {
              controller.allCities.clear();
            },
          );
        },
      ),
      const SizedBox(height: 10),
      GetX<BranchesController>(
        builder: (controller) {
          var isCityLoading = controller.allCities.isEmpty;

          return CustomDropdown(
            hintText: 'City',
            textcontroller: controller.city.text,
            showedSelectedName: 'name',
            items: isCityLoading ? {} : controller.allCities,
            onChanged: (key, value) {
              controller.city.text = value['name'];
              controller.cityId.value = key;
            },
          );
        },
      ),
    ],
  );
}
