import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';

Container contactDetails({
  required CompanyController controller,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: containerDecor,
    child: Column(
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.userName,
                labelText: 'Name',
                hintText: 'Enter your name',
                keyboardType: TextInputType.name,
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.phoneNumber,
                labelText: 'Phone Number',
                hintText: 'Enter your phone Number',
                validate: true,
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.email,
                labelText: 'Email',
                hintText: 'Enter your email',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.password,
                labelText: 'Password',
                hintText: 'Enter your password',
                validate: true,
              ),
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.address,
          labelText: 'Address',
          hintText: 'Enter your address',
          validate: true,
        ),
        GetX<CompanyController>(builder: (controller) {
          final isCountriesLoading = controller.allCountries.isEmpty;
          return Row(
            spacing: 10,
            children: [
              Expanded(
                child: dropDownValues(
                  listValues: controller.allCountries.values
                      .map((value) => value['name'].toString())
                      .toList(),
                  labelText: 'Country',
                  hintText: 'Enter your country',
                  textController: controller.country,
                  validate: true,
                  menus: isCountriesLoading ? {} : controller.allCountries,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text('${suggestion['name']}'),
                    );
                  },
                  onSelected: (suggestion) {
                    controller.country.text = suggestion['name'];
                    controller.allCountries.entries.where((entry) {
                      return entry.value['name'] ==
                          suggestion['name'].toString();
                    }).forEach(
                      (entry) {
                        // controller.onSelect(entry.key);
                        controller.getCitiesByCountryID(entry.key);
                        controller.city.clear();
                        controller.selectedCountryId.value = entry.key;
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: dropDownValues(
                  listValues: controller.allCities.values
                      .map((value) => value['name'].toString())
                      .toList(),
                  suggestionsController: SuggestionsController(),
                  onTapForTypeAheadField: SuggestionsController().refresh,
                  labelText: 'City',
                  hintText: 'Enter your city',
                  textController: controller.city,
                  validate: true,
                  menus:
                      controller.allCities.isEmpty ? {} : controller.allCities,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text('${suggestion['name']}'),
                    );
                  },
                  onSelected: (suggestion) {
                    controller.city.text = suggestion['name'];
                    controller.allCities.entries.where((entry) {
                      return entry.value['name'] ==
                          suggestion['name'].toString();
                    }).forEach((entry) {
                      controller.selectedCityId.value = entry.key;
                    });
                  },
                ),
              ),
            ],
          );
        }),
      ],
    ),
  );
}
