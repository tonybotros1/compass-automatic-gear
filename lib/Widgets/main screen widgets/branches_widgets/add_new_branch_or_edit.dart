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
      SizedBox(
        height: 5,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.code,
        labelText: 'Code',
        hintText: 'Enter Code',
        validate: true,
      ),
      SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.name,
        labelText: 'Description',
        hintText: 'Enter Name',
        validate: true,
      ),
      SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.line,
        labelText: 'Line',
        hintText: 'Enter Line',
        validate: true,
      ),
      SizedBox(
        height: 10,
      ),
      GetX<BranchesController>(builder: (controller) {
        var isCountryLoading = controller.allCountries.isEmpty;
        return CustomDropdown(
          hintText: 'Country',
          textcontroller: controller.country.text,
          showedSelectedName: 'name',
          items: isCountryLoading ? {} : controller.allCountries,
          itemBuilder: (context, key, value) {
            return ListTile(
              title: Text(value['name']),
            );
          },
          onChanged: (key, value) {
            controller.country.text = value['name'];
            controller.getCitiesByCountryID(key);
            controller.city.clear();
            controller.countryId.value = key;
          },
        );
      
      }),
      SizedBox(
        height: 10,
      ),
      GetX<BranchesController>(builder: (controller) {
        var isCityLoading = controller.allCities.isEmpty;

        return CustomDropdown(
          hintText: 'City',
          textcontroller: controller.city.text,
          showedSelectedName: 'name',
          items: isCityLoading ? {} : controller.allCities,
          itemBuilder: (context, key, value) {
            return ListTile(
              title: Text(value['name']),
            );
          },
          onChanged: (key, value) {
            controller.city.text = value['name'];
            controller.cityId.value = key;
          },
        );
       
      }),
    ],
  );
}
