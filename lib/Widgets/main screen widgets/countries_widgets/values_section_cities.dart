import 'package:datahubai/Controllers/Main%20screen%20controllers/countries_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';
import 'add_new_city_or_edit.dart';

Widget citiesSection({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Container(
    width: constraints.maxWidth,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        GetX<CountriesController>(
          builder: (controller) {
            return searchBar(
              search: controller.searchForCities,
              constraints: constraints,
              context: context,
              controller: controller,
              title: 'Search for cities',
              button: newCityButton(context, constraints, controller),
            );
          },
        ),
        Expanded(
          child: GetX<CountriesController>(
            builder: (controller) {
              if (controller.loadingcities.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.allCities.isEmpty) {
                return const Center(
                  child: Text('No Element'),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: tableOfScreens(
                    constraints: constraints,
                    context: context,
                    controller: controller,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required CountriesController controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Code',
        ),
        onSort: controller.onSortForCities,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Name',
        ),
        onSort: controller.onSortForCities,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSortForCities,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
    ],
    rows: controller.filteredCities.isEmpty &&
            controller.searchForCities.value.text.isEmpty
        ? controller.allCities.map<DataRow>((city) {
            final cityData = city.data() as Map<String, dynamic>;
            final cityId = city.id;
            return dataRowForTheTable(
                cityData, context, constraints, cityId, controller);
          }).toList()
        : controller.filteredCities.map<DataRow>((city) {
            final cityData = city.data() as Map<String, dynamic>;
            final cityId = city.id;
            return dataRowForTheTable(
                cityData, context, constraints, cityId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> cityData, context, constraints,
    String cityId, CountriesController controller) {
  return DataRow(cells: [
    DataCell(
      Text(
        cityData['code'] ?? 'no code',
      ),
    ),
    DataCell(
      Text(
        cityData['name'] ?? 'no city',
      ),
    ),
    DataCell(
      Text(
        cityData['added_date'] != null
            ? textToDate(cityData['added_date'])
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        activeInActiveSection(cityData, controller, cityId),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child:
              editSection(controller, cityData, context, constraints, cityId),
        ),
        deleteSection(context, controller, cityId),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(context, CountriesController controller, cityId) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: 'The city will be deleted permanently',
            onPressed: () {
              controller.deleteCity(
                  controller.countryIdToWorkWith.value, cityId);
            });
      },
      child: const Text('Delete'));
}

ElevatedButton editSection(CountriesController controller,
    Map<String, dynamic> cityData, context, constraints, String cityId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.cityName.text = cityData['name'];
        controller.cityCode.text = cityData['code'];
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewCityOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  isEnabled: false,
                ),
                actions: [
                  GetX<CountriesController>(
                      builder: (controller) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: controller.addingNewCityValue.value
                                  ? null
                                  : () async {
                                      if (!controller.formKeyForAddingNewvalue
                                          .currentState!
                                          .validate()) {
                                      } else {
                                        controller.editcity(
                                            controller
                                                .countryIdToWorkWith.value,
                                            cityId);
                                      }
                                    },
                              style: saveButtonStyle,
                              child:
                                  controller.addingNewCityValue.value == false
                                      ? const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                            ),
                          )),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: cancelButtonStyle,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              );
            });
      },
      child: Text('Edit'));
}

ElevatedButton activeInActiveSection(Map<String, dynamic> cityData,
    CountriesController controller, String cityId) {
  return ElevatedButton(
      style: cityData['available'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        if (cityData['available'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.editHideOrUnhide(
            controller.countryIdToWorkWith.value, cityId, status);
      },
      child: cityData['available'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton newCityButton(BuildContext context, BoxConstraints constraints,
    CountriesController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.cityName.clear();
      controller.cityCode.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewCityOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
                isEnabled: true,
              ),
              actions: [
                GetX<CountriesController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewCityValue.value
                                ? null
                                : () async {
                                    if (!controller
                                        .formKeyForAddingNewvalue.currentState!
                                        .validate()) {
                                    } else {
                                      await controller.addNewCity(
                                          controller.countryIdToWorkWith.value);
                                    }
                                  },
                            style: saveButtonStyle,
                            child: controller.addingNewCityValue.value == false
                                ? const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                          ),
                        )),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: cancelButtonStyle,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New City'),
  );
}
