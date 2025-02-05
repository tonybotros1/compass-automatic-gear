import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/countries_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/countries_widgets/add_new_country_or_edit.dart';
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        activeInActiveSection(controller, countryData, countryId),
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: editSection(
              context, controller, countryData, constraints, countryId),
        ),
        deleteSection(controller, countryId, context),
      ],
    )),
  ]);
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
            context: context,
            builder: (context) {
              controller.countryCode.text = countryData['code'];
              controller.countryName.text = countryData['name'];
              controller.countryCallingCode.text = countryData['calling_code'];
              controller.countryCode.text = countryData['code'];
              controller.currencyId.value = countryData['basd_currency'];
              controller.currencyRate.text = countryData['rate'];
              controller.currency.text =
                  controller.getCurrencyCodeName(countryData['basd_currency'])!;
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewCountryOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  canEdit: false,
                ),
                actions: [
                  Padding(
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
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
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
      showDialog(
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
                                    await controller.addNewCountry();
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
