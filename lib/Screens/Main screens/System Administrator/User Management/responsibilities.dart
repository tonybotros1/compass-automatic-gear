import 'package:flutter/cupertino.dart';
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

ElevatedButton newResponsibilityButton(context, constraints, controller) {
  return ElevatedButton(
      onPressed: controller.loadingMenus.value == false
          ? () async {
              controller.loadingMenus.value = true;
              await controller.listOfMenus();
              controller.loadingMenus.value = false;
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      content: addNewResponsibilityOrView(
                          controller: controller,
                          constraints: constraints,
                          context: context,
                          menuName: controller.menuName),
                      actions: [
                        GetX<ResponsibilitiesController>(
                            builder: (controller) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: ElevatedButton(
                                    onPressed: controller
                                            .addingNewResponsibilityProcess
                                            .value
                                        ? null
                                        : () async {
                                            await controller
                                                .addNewResponsibility();
                                            if (controller
                                                    .addingNewResponsibilityProcess
                                                    .value ==
                                                false) {
                                              Get.back();
                                            }
                                          },
                                    style: saveButtonStyle,
                                    child: controller
                                                .addingNewResponsibilityProcess
                                                .value ==
                                            false
                                        ? const Text(
                                            'Save',
                                            style:
                                                TextStyle(color: Colors.white),
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
                              controller.addingNewResponsibilityProcess.value ==
                                      false
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
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        minimumSize: const Size(180, 40),
      ),
      child: Obx(
        () => controller.loadingMenus.value == false
            ? const Text('New Responsibility')
            : const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
      ));
}

Widget tableOfScreens(
    {required constraints, required context, required controller}) {
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
      // alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: viewSection(
                constraints: constraints,
                context: context,
                controller: controller,
                roleData: roleData,
                roleID: roleId),
          ),
          deleteSection(context, controller, roleId)
        ],
      ),
    )),
  ]);
}

ElevatedButton deleteSection(context, controller, roleId) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Alert"),
              content: const Text("The menu will be deleted permanently"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Get.back();
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  isDefaultAction: true,
                  child: const Text("OK"),
                  onPressed: () async {
                    await controller.deleteResponsibility(roleId);
                    Get.back();
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text('Delete'));
}

Widget viewSection(
    {required context,
    required controller,
    required roleData,
    required constraints,
    required roleID}) {
  return ElevatedButton(
      style: viewButtonStyle,
      onPressed: controller.viewLoading.value == false
          ? () async {
              await controller.listOfMenus();
              showDialog(
                  context: context,
                  builder: (context) {
                    controller.responsibilityName.text = roleData['role_name'];

                    controller.menuName.text = roleData['menu']['name'];
                    controller.menuIDFromList.value = roleData['menu']['id'];

                    // print(controller.menuName.text);
                    return AlertDialog(
                      actionsPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      content: addNewResponsibilityOrView(
                        controller: controller,
                        constraints: constraints,
                        context: context,
                        responsibilityName: controller.responsibilityName,
                        menuName: controller.menuName,
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: GetX<ResponsibilitiesController>(
                              builder: (controller) {
                            return ElevatedButton(
                              onPressed: controller
                                      .addingNewResponsibilityProcess.value
                                  ? null
                                  : () {
                                      controller.updateResponsibility(roleID);
                                      if (controller
                                              .addingNewResponsibilityProcess
                                              .value ==
                                          false) {
                                        Get.back();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: controller.addingNewResponsibilityProcess
                                          .value ==
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
                            );
                          }),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child:
                              controller.addingNewResponsibilityProcess.value ==
                                      false
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
            }
          : null,
      child: controller.viewLoading.value == false
          ? const Text('View')
          : const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ));
}
