import 'package:datahubai/Controllers/Main%20screen%20controllers/functions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/functions_widgets/add_new_screen_or_view.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class Functions extends StatelessWidget {
  const Functions({super.key});

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
                  GetX<FunctionsController>(
                    init: FunctionsController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for screens',
                        button:
                            newScreenButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<FunctionsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allScreens.isEmpty) {
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

ElevatedButton newScreenButton(
    BuildContext context, BoxConstraints constraints, controller) {
  return ElevatedButton(
    onPressed: () {
      controller.screenName.clear();
      controller.route.clear();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewScreenOrView(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<FunctionsController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewScreenProcess.value
                                ? null
                                : () async {
                                    await controller.addNewScreen();
                                  },
                            style: saveButtonStyle,
                            child:
                                controller.addingNewScreenProcess.value == false
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
    child: const Text('New Screen'),
  );
}

Widget tableOfScreens(
    {required constraints, required context, required controller}) {
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
        label: AutoSizedText(
          text: 'Screen',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Route',
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
      DataColumn(label: Text('')),
    ],
    rows: controller.filteredScreens.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allScreens.map<DataRow>((screen) {
            final screenData = screen.data() as Map<String, dynamic>;
            final screenId = screen.id;
            return dataRowForTheTable(
                screenData, context, constraints, screenId, controller);
          }).toList()
        : controller.filteredScreens.map<DataRow>((screen) {
            final screenData = screen.data() as Map<String, dynamic>;
            final screenId = screen.id;
            return dataRowForTheTable(
                screenData, context, constraints, screenId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> screenData, context,
    constraints, screenId, controller) {
  return DataRow(cells: [
    DataCell(Text(
      screenData['name'] ?? 'no name',
    )),
    DataCell(
      Text(
        screenData['routeName'] ?? 'no route',
      ),
    ),
    DataCell(
      Text(
        screenData['added_date'] != null
            ? textToDate(screenData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: editSection(
              context, controller, screenData, constraints, screenId),
        ),
        deleteSection(context, controller, screenId),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    context, FunctionsController controller, screenId) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: 'The user will be deleted permanently',
            onPressed: () {
              controller.deleteScreen(screenId);
            });
      },
      child: const Text('Delete'));
}

ElevatedButton editSection(context, controller, Map<String, dynamic> screenData,
    constraints, screenId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              controller.screenName.text = screenData['name'] ?? '';
              controller.route.text = screenData['routeName'] ?? '';

              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewScreenOrView(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: controller.addingNewScreenProcess.value
                          ? null
                          : () {
                              controller.updateScreen(screenId);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: controller.addingNewScreenProcess.value == false
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
