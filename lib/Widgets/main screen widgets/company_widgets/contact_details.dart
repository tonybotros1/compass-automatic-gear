import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Container contactDetails({required CompanyController controller}) {
  return Container(
    padding: const EdgeInsets.all(20),
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
                keyboardType: TextInputType.name,
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.phoneNumber,
                labelText: 'Phone Number',
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
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.password,
                labelText: 'Password',
                validate: true,
              ),
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.address,
          labelText: 'Address',
          validate: true,
        ),
        GetX<CompanyController>(
          builder: (controller) {
            final isCountriesLoading = controller.allCountries.isEmpty;
            return Row(
              spacing: 10,
              children: [
                Expanded(
                  child: MenuWithValues(
                    labelText: 'Country',
                    headerLqabel: 'Countries',
                    dialogWidth: 600,
                    controller: controller.country,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    data: isCountriesLoading ? {} : controller.allCountries,
                    onDelete: () {
                      controller.country.clear();
                      controller.allCities.clear();
                      controller.city.clear();
                      controller.selectedCountryId.value = '';
                      controller.selectedCityId.value = '';
                    },
                    onSelected: (value) {
                      controller.country.text = value['name'];
                      controller.getCitiesByCountryId(value['_id']);
                      controller.city.clear();
                      controller.selectedCountryId.value = value['_id'];
                      controller.selectedCityId.value = '';
                    },
                  ),
                ),
                Expanded(
                  child: MenuWithValues(
                    labelText: 'City',
                    headerLqabel: 'Cities',
                    dialogWidth: 600,
                    controller: controller.city,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    data: controller.allCities.isEmpty
                        ? {}
                        : controller.allCities,
                    onDelete: () {
                      controller.city.clear();
                      controller.selectedCityId.value = '';
                    },
                    onSelected: (value) {
                      controller.city.text = value['name'];
                      controller.selectedCityId.value = value['_id'];
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}
