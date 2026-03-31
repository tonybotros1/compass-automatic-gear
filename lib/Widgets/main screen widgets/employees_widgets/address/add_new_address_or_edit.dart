import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewAddressOrEdit({
  required EmployeesController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        myTextFormFieldWithBorder(
          maxLines: 3,
          obscureText: false,
          controller: controller.line,
          labelText: 'Line',
          validate: true,
        ),
        MenuWithValues(
          labelText: 'Country',
          headerLqabel: 'Countries',
          dialogWidth: 600,
          width: 300,
          controller: controller.country,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.country.clear();
            controller.countryId.value = '';
            controller.city.clear();
            controller.cityId.value = '';
          },
          onSelected: (value) {
            controller.country.text = value['name'];
            controller.countryId.value = value['_id'];
            controller.getCitiesByCountryID(value['_id']);
            controller.city.clear();
            controller.cityId.value = '';
          },
          onOpen: () {
            return controller.getCountries();
          },
        ),
        MenuWithValues(
          labelText: 'City',
          headerLqabel: 'Cities',
          dialogWidth: 600,
          width: 300,
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
          onOpen: () {
            return controller.getCitiesByCountryID(controller.countryId.value);
          },
        ),
      ],
    ),
  );
}
