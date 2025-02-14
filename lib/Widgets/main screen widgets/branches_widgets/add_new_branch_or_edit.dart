import 'package:datahubai/Controllers/Main%20screen%20controllers/branches_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../my_text_field.dart';

Widget addNewBranchOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required BranchesController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 350,
    child: ListView(
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
          return dropDownValues(
            listValues: controller.allCountries.values
                .map((value) => value['name'].toString())
                .toList(),
            labelText: 'Country',
            hintText: 'Enter your country',
            textController: controller.country,
            validate: true,
            menus: isCountryLoading ? {} : controller.allCountries,
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text('${suggestion['name']}'),
              );
            },
            onSelected: (suggestion) {
              controller.country.text = suggestion['name'];
              controller.allCountries.entries.where((entry) {
                return entry.value['name'] == suggestion['name'].toString();
              }).forEach(
                (entry) {
                  // controller.onSelect(entry.key);
                  controller.getCitiesByCountryID(entry.key);
                  controller.city.clear();
                  controller.countryId.value = entry.key;
                },
              );
            },
          );
        }),
        SizedBox(
          height: 10,
        ),
        GetX<BranchesController>(builder: (controller) {
          var isCityLoading = controller.allCities.isEmpty;

          return dropDownValues(
            listValues: controller.allCities.values
                .map((value) => value['name'].toString())
                .toList(),
            suggestionsController: SuggestionsController(),
            onTapForTypeAheadField: SuggestionsController().refresh,
            labelText: 'City',
            hintText: 'Enter your city',
            textController: controller.city,
            validate: true,
            menus: isCityLoading ? {} : controller.allCities,
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text('${suggestion['name']}'),
              );
            },
            onSelected: (suggestion) {
              controller.city.text = suggestion['name'];
              controller.allCities.entries.where((entry) {
                return entry.value['name'] == suggestion['name'].toString();
              }).forEach((entry) {
                controller.cityId.value = entry.key;
              });
            },
          );
        }),
      ],
    ),
  );
}
