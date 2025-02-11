import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/countries_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/countries_widgets/add_new_country_or_edit.dart';
import '../../../../Widgets/main screen widgets/countries_widgets/values_section_cities.dart';
import '../../../../consts.dart';

class Countries extends StatelessWidget {
  const Countries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GetX<CountriesController>(
                    init: CountriesController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for countries',
                        button:
                            newcountryButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CountriesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allCountries.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
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
            ),
          );
        },
      ),
    );
  }
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
          text: 'Code',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Flag',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Name',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Calling Code',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
    ],
    rows: controller.filteredCountries.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCountries.map<DataRow>((country) {
            final countryData = country.data() as Map<String, dynamic>;
            final countryId = country.id;
            return dataRowForTheTable(
                countryData, context, constraints, countryId, controller);
          }).toList()
        : controller.filteredCountries.map<DataRow>((country) {
            final countryData = country.data() as Map<String, dynamic>;
            final countryId = country.id;
            return dataRowForTheTable(
                countryData, context, constraints, countryId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> countryData, context,
    constraints, countryId, CountriesController controller) {
  return DataRow(cells: [
    DataCell(Text(
      countryData['code'] ?? 'no code',
    )),
    DataCell(countryData['flag'] != '' || countryData['flag'] != null
        ? Image.network(
            countryData['flag'],
            width: 40,
          )
        : Text('no flag')),
    DataCell(
      Text(
        countryData['name'] ?? 'no name',
      ),
    ),
    DataCell(
      Text(
        countryData['calling_code'] ?? 'no calling code',
      ),
    ),
    DataCell(
      Text(
        countryData['added_date'] != null && countryData['added_date'] != ''
            ? textToDate(countryData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        valSectionInTheTable(
            controller, countryId, context, constraints, countryData),
        activeInActiveSection(controller, countryData, countryId),
        editSection(context, controller, countryData, constraints, countryId),
        deleteSection(controller, countryId, context),
      ],
    )),
  ]);
}

ElevatedButton valSectionInTheTable(CountriesController controller, countryId,
    context, constraints, countryData) {
  return ElevatedButton(
      style: viewButtonStyle,
      onPressed: () {
        controller.getCitiesValues(countryId);
        controller.countryIdToWorkWith.value = countryId;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: citiesSection(
                  constraints: constraints,
                  context: context,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: cancelButtonStyle,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              );
            });
      },
      child: const Text('Cities'));
}

ElevatedButton activeInActiveSection(CountriesController controller,
    Map<String, dynamic> countryData, String countryId) {
  return ElevatedButton(
      style: countryData['status'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        if (countryData['status'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.changeCountryStatus(countryId, status);
      },
      child: countryData['status'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton deleteSection(
    CountriesController controller, countryId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The country will be deleted permanently",
            onPressed: () {
              controller.deleteCountry(countryId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, CountriesController controller,
    Map<String, dynamic> countryData, constraints, countryId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        showDialog(
           barrierDismissible: false,
            context: context,
            builder: (context) {
              final currency =
                  controller.getCurrencyCodeName(countryData['based_currency']);
              controller.countryCode.text = countryData['code'];
              controller.countryName.text = countryData['name'];
              controller.countryCallingCode.text = countryData['calling_code'];
              controller.countryCode.text = countryData['code'];
              controller.currencyId.value = countryData['based_currency'];
              controller.currencyRate.text =
                  (currency['rate'] ?? '').toString();
              controller.currency.text = currency['code'] ?? '';

              controller.flagUrl.value = countryData['flag'] ?? '';
              controller.imageBytes.value = Uint8List(0);
              controller.flagSelectedError.value = false;
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewCountryOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  canEdit: false,
                ),
                actions: [
                  GetX<CountriesController>(builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: controller.addingNewValue.value
                            ? null
                            : () {
                                controller.editCountries(countryId);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: controller.addingNewValue.value == false
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
                    );
                  }),
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
      child: const Text('Edit'));
}

ElevatedButton newcountryButton(BuildContext context,
    BoxConstraints constraints, CountriesController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.countryCode.clear();
      controller.countryName.clear();
      controller.countryCallingCode.clear();
      controller.currency.clear();
      controller.currencyId.value = '';
      controller.currencyRate.clear();
      controller.imageBytes.value = Uint8List(0);
      controller.flagUrl.value = '';
      controller.flagSelectedError.value = false;
      showDialog(
         barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewCountryOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<CountriesController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewValue.value
                                ? null
                                : () async {
                                    if (!controller
                                        .formKeyForAddingNewvalue.currentState!
                                        .validate()) {}
                                    if (controller.imageBytes.value.isEmpty) {
                                      controller.flagSelectedError.value = true;
                                    } else {
                                      await controller.addNewCountry();
                                    }
                                  },
                            style: saveButtonStyle,
                            child: controller.addingNewValue.value == false
                                ? const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(
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
    child: const Text('New Country'),
  );
}
