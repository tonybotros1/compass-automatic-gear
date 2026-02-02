import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/company_controller.dart';
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
                  child: CustomDropdown(
                    hintText: 'Country',
                    showedSelectedName: 'name',
                    textcontroller: controller.country.text,
                    items: isCountriesLoading ? {} : controller.allCountries,
                    onChanged: (key, value) {
                      controller.country.text = value['name'];
                      controller.getCitiesByCountryId(key);
                      controller.city.clear();
                      controller.selectedCountryId.value = key;
                      controller.selectedCityId.value = '';
                    },
                    onDelete: () {
                      controller.country.clear();
                      controller.allCities.clear();
                      controller.city.clear();
                      controller.selectedCountryId.value = '';
                      controller.selectedCityId.value = '';
                    },
                  ),
                ),
                Expanded(
                  child: CustomDropdown(
                    hintText: 'City',
                    showedSelectedName: 'name',
                    textcontroller: controller.city.text,
                    items: controller.allCities.isEmpty
                        ? {}
                        : controller.allCities,
                    onChanged: (key, value) {
                      controller.city.text = value['name'];
                      controller.selectedCityId.value = key;
                    },onDelete: (){
                      controller.city.clear();
                      controller.selectedCityId.value = '';
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
