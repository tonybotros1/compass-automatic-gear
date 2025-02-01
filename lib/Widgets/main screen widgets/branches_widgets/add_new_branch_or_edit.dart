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
            textController: controller.country,
            controller: controller.country,
            labelText: 'Country',
            hintText: 'Enter Country',
            validate: true,
            menus: isCountryLoading == false ? controller.allCountries : {},
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
                  controller.onSelect(entry.key);
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
          var isCityLoading = controller.filterdCitiesByCountry.isEmpty;

          return dropDownValues(
            suggestionsController: SuggestionsController(),
            onTapForTypeAheadField: SuggestionsController().refresh,
            labelText: 'City',
            hintText: 'Enter your city',
            controller: controller,
            textController: controller.city,
            validate: true,
            menus:
                isCityLoading == false ? controller.filterdCitiesByCountry : {},
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
