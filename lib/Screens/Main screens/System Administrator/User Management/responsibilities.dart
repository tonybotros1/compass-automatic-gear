import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/responsibilities_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/add_new_responsibilities_or_view.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class Responsibilities extends StatelessWidget {
  const Responsibilities({super.key});

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
                  GetX<ResponsibilitiesController>(
                    init: ResponsibilitiesController(),
                    builder: (controller) {
                      return searchBar(
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for Responsibilities',
                        buttonTitle: 'New Responsibilities',
                        button: newResponsibilityButton(
                            context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<ResponsibilitiesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allResponsibilities.isEmpty) {
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

ElevatedButton newResponsibilityButton(
    BuildContext context, BoxConstraints constraints, controller) {
  return ElevatedButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewResponsibilityOrView(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  menuName: controller.menuName),
              actions: [
                GetX<ResponsibilitiesController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed:
                                controller.addingNewResponsibilityProcess.value
                                    ? null
                                    : () async {
                                        await controller.addNewResponsibility();
                                        if (controller
                                                .addingNewResponsibilityProcess
                                                .value ==
                                            false) {
                                          Get.back();
                                        }
                                      },
                            style: saveButtonStyle,
                            child: controller
                                        .addingNewResponsibilityProcess.value ==
                                    false
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
                        )),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: cancelButtonStyle,
                  child:
                      controller.addingNewResponsibilityProcess.value == false
                          ? const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                ),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New Responsibility'),
  );
}

Widget tableOfScreens(
    {required constraints, required context, required controller}) {
  return DataTable(
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
          text: 'Responsibility',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Child',
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
    rows: controller.filteredResponsibilities.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allResponsibilities.entries.map<DataRow>((role) {
            final roleData = role.value;
            final roleId = role.key;
            return dataRowForTheTable(
                roleData, context, constraints, roleId, controller);
          }).toList()
        : controller.filteredResponsibilities.entries.map<DataRow>((role) {
            final roleData = role.value;
            final roleId = role.key;
            return dataRowForTheTable(
                roleData, context, constraints, roleId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> roleData, context, constraints, roleId, controller) {
  return DataRow(cells: [
    DataCell(Text(
      roleData['role_name'] ?? 'no name',
    )),
    DataCell(
      Text(
        roleData['menu'] != null || roleData['menu'].isNotEmpty()
            ? '${roleData['menu']['name']} (${roleData['menu']['description']})'
            : 'no menu',
      ),
    ),
    DataCell(
      Text(
        roleData['added_date'] != null
            ? controller.textToDate(roleData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Align(
      alignment: Alignment.center,
      child: ElevatedButton(
          style: viewButtonStyle,
          onPressed: () {
            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       controller.screenName.text = screenData['name'];
            //       controller.route.text = screenData['routeName'];

            //       return AlertDialog(
            //         actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
            //         content: addNewScreenOrView(
            //           controller: controller,
            //           constraints: constraints,
            //           context: context,
            //           screenName: controller.screenName,
            //           route: controller.route,
            //         ),
            //         actions: [
            //           Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 16),
            //             child: ElevatedButton(
            //               onPressed: controller.addingNewResponsibilityProcess.value
            //                   ? null
            //                   : () {
            //                       controller.updateScreen(screenId);
            //                       if (controller.addingNewResponsibilityProcess.value ==
            //                           false) {
            //                         Get.back();
            //                       }
            //                     },
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: Colors.green,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(5),
            //                 ),
            //               ),
            //               child:
            //                   controller.addingNewResponsibilityProcess.value == false
            //                       ? const Text(
            //                           'Save',
            //                           style: TextStyle(color: Colors.white),
            //                         )
            //                       : const Padding(
            //                           padding: EdgeInsets.all(8.0),
            //                           child: CircularProgressIndicator(
            //                             color: Colors.white,
            //                           ),
            //                         ),
            //             ),
            //           ),
            //           ElevatedButton(
            //             onPressed: () {
            //               Get.back();
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: mainColor,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(5),
            //               ),
            //             ),
            //             child: controller.addingNewResponsibilityProcess.value == false
            //                 ? const Text(
            //                     'Cancel',
            //                     style: TextStyle(color: Colors.white),
            //                   )
            //                 : const Padding(
            //                     padding: EdgeInsets.all(8.0),
            //                     child: CircularProgressIndicator(
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //           ),
            //         ],
            //       );
            //     });
          },
          child: const Text('View')),
    )),
  ]);
}
