import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/currency_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/currencies_widgets/add_new_currency_or_edit.dart';
import '../../../../consts.dart';

class Currency extends StatelessWidget {
  const Currency({super.key});

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
                  GetX<CurrencyController>(
                    init: CurrencyController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for currencies',
                        button:
                            newCurrencyButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CurrencyController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allCurrencies.isEmpty) {
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
    required CurrencyController controller}) {
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
          text: 'Rate',
        ),
        onSort: controller.onSort,
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
    rows: controller.filteredCurrencies.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCurrencies.map<DataRow>((currency) {
            final currencyData = currency.data() as Map<String, dynamic>;
            final currencyId = currency.id;
            return dataRowForTheTable(
                currencyData, context, constraints, currencyId, controller);
          }).toList()
        : controller.filteredCurrencies.map<DataRow>((currency) {
            final currencyData = currency.data() as Map<String, dynamic>;
            final currencyId = currency.id;
            return dataRowForTheTable(
                currencyData, context, constraints, currencyId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> currencyData, context,
    constraints, currencyId, CurrencyController controller) {
  return DataRow(cells: [
    DataCell(Text(
      currencyData['code'] ?? 'no code',
    )),
    DataCell(
      Text(
        currencyData['name'] ?? 'no name',
      ),
    ),
    DataCell(
      Text(
        '${currencyData['rate']}',
      ),
    ),
    DataCell(
      Text(
        currencyData['added_date'] != null && currencyData['added_date'] != ''
            ? textToDate(currencyData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        activeInActiveSection(controller, currencyData, currencyId),
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: editSection(
              context, controller, currencyData, constraints, currencyId),
        ),
        deleteSection(controller, currencyId, context),
      ],
    )),
  ]);
}

ElevatedButton activeInActiveSection(CurrencyController controller,
    Map<String, dynamic> currencyData, String currencyId) {
  return ElevatedButton(
      style: currencyData['status'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        if (currencyData['status'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.changeCurrencyStatus(currencyId, status);
      },
      child: currencyData['status'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton deleteSection(
    CurrencyController controller, currencyId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The counter will be deleted permanently",
            onPressed: () {
              controller.deleteCurrency(currencyId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, CurrencyController controller,
    Map<String, dynamic> currencyData, constraints, currencyId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              controller.code.text = currencyData['code'] ?? '';
              controller.name.text = currencyData['name'] ?? '';
              controller.rate.text = (currencyData['rate'] ?? '').toString();

              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewCurrencyOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: controller.addingNewValue.value
                          ? null
                          : () {
                              controller.editCurrency(currencyId);
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

ElevatedButton newCurrencyButton(BuildContext context,
    BoxConstraints constraints, CurrencyController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.code.clear();
      controller.name.clear();
      controller.rate.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewCurrencyOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<CurrencyController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewValue.value
                                ? null
                                : () async {
                                    await controller.addNewCurrency();
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
    child: const Text('New Currency'),
  );
}
