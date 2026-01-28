import 'dart:typed_data';

import 'package:datahubai/Models/countries/countries_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/countries_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/countries_widgets/countries_dialog.dart';
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
                        onChanged: (_) {
                          controller.filterCountries();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterCountries();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for countries',
                        button: newcountryButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CountriesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allCountries.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical,
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required CountriesController controller,
}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(text: 'Code', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Flag'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Name'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Calling Code'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSort,
      ),
      const DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text(''),
      ),
    ],
    rows:
        controller.filteredCountries.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCountries.map<DataRow>((country) {
            final countryId = country.id;
            return dataRowForTheTable(
              country,
              context,
              constraints,
              countryId,
              controller,
            );
          }).toList()
        : controller.filteredCountries.map<DataRow>((country) {
            final countryId = country.id;
            return dataRowForTheTable(
              country,
              context,
              constraints,
              countryId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  Country countryData,
  context,
  constraints,
  countryId,
  CountriesController controller,
) {
  return DataRow(
    cells: [
      DataCell(Text(countryData.code)),
      DataCell(
        Image.network(
          countryData.flag,
          width: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 40, color: Colors.grey);
          },
        ),
      ),
      DataCell(Text(countryData.name)),
      DataCell(Text(countryData.callingCode)),
      DataCell(Text(textToDate(countryData.createdAt))),
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            valSectionInTheTable(
              controller,
              countryId,
              context,
              constraints,
              countryData,
            ),
            activeInActiveSection(controller, countryData, countryId),
            editSection(
              context,
              controller,
              countryData,
              constraints,
              countryId,
            ),
            deleteSection(controller, countryId, context),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton valSectionInTheTable(
  CountriesController controller,
  countryId,
  context,
  BoxConstraints constraints,
  countryData,
) {
  return ElevatedButton(
    style: viewButtonStyle,
    onPressed: () {
      controller.searchForCities.value.clear();
      controller.queryForCities.value = '';
      controller.getCitiesValues(countryId);
      controller.countryIdToWorkWith.value = countryId;
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: mainColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '🏙️ Cities',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      closeButton,
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: citiesSection(
                      constraints: constraints,
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    child: const Text('Cities'),
  );
}

ElevatedButton activeInActiveSection(
  CountriesController controller,
  Country countryData,
  String countryId,
) {
  return ElevatedButton(
    style: countryData.status == false
        ? inActiveButtonStyle
        : activeButtonStyle,
    onPressed: () {
      bool status;
      if (countryData.status == false) {
        status = true;
      } else {
        status = false;
      }
      controller.changeCountryStatus(countryId, status);
    },
    child: countryData.status == true
        ? const Text('Active')
        : const Text('Inactive'),
  );
}

ElevatedButton deleteSection(
  CountriesController controller,
  countryId,
  context,
) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: "The country will be deleted permanently",
        onPressed: () {
          controller.deleteCountry(countryId);
        },
      );
    },
    child: const Text("Delete"),
  );
}

ElevatedButton editSection(
  BuildContext context,
  CountriesController controller,
  Country countryData,
  constraints,
  countryId,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () {
      controller.countryName.text = countryData.name;
      controller.countryCallingCode.text = countryData.callingCode;
      controller.countryCode.text = countryData.code;
      controller.currencyName.text = countryData.currencyName;
      controller.currencyCode.text = countryData.currencyCode;
      controller.subunitName.text = countryData.subunitName;
      controller.subunitCode.text = countryData.subunitCode;
      controller.vat.text = countryData.vat.toString();

      controller.flagUrl.value = countryData.flag;
      controller.imageBytes.value = Uint8List(0);
      controller.flagSelectedError.value = false;
      countriesDialog(
        canEdit: false,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.editCountry(countryId);
              },
      );
    },
    child: const Text('Edit'),
  );
}

ElevatedButton newcountryButton(
  BuildContext context,
  BoxConstraints constraints,
  CountriesController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.countryCode.clear();
      controller.countryName.clear();
      controller.countryCallingCode.clear();
      controller.currencyName.clear();
      controller.currencyCode.clear();
      controller.vat.clear();
      controller.imageBytes.value = Uint8List(0);
      controller.flagUrl.value = '';
      controller.flagSelectedError.value = false;
      controller.subunitCode.clear();
      controller.subunitName.clear();
      countriesDialog(
        canEdit: true,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                if (!controller.formKeyForAddingNewvalue.currentState!
                    .validate()) {}
                if (controller.imageBytes.value.isEmpty) {
                  controller.flagSelectedError.value = true;
                } else {
                  await controller.addNewCountry();
                }
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Country'),
  );
}
