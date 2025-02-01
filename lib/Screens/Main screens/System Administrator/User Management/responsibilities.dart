import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/responsibilities_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/responsibilities_widgets/add_new_responsibilities_or_view.dart';
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
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for responsibilities',
                        button: newResponsibilityButton(
                            context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<ResponsibilitiesController>(
                      builder: (controller) {
                        if (controller.isScreenLoading.value) {
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
    context, constraints, ResponsibilitiesController controller) {
  return ElevatedButton(
      onPressed: () async {
        controller.responsibilityName.clear();
        controller.menuName.clear();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewResponsibilityOrView(
                    controller: controller,
                    constraints: constraints,
                    context: context,
                    ),
                actions: [
                  GetX<ResponsibilitiesController>(
                      builder: (controller) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: controller
                                      .addingNewResponsibilityProcess.value
                                  ? null
                                  : () async {
                                      await controller.addNewResponsibility();
                                    },
                              style: saveButtonStyle,
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        minimumSize: const Size(180, 40),
      ),
      child: const Text('New Responsibility'));
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required ResponsibilitiesController controller}) {
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
                roleData, context, constraints, roleId, controller, role);
          }).toList()
        : controller.filteredResponsibilities.entries.map<DataRow>((role) {
            final roleData = role.value;
            final roleId = role.key;
            return dataRowForTheTable(
                roleData, context, constraints, roleId, controller, role);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> roleData, context, constraints,
    roleId, ResponsibilitiesController controller, role) {
  return DataRow(
      // selected: roleData['is_shown_for_users'] ?? false,
      // onSelectChanged: (isSelected) {
      //   controller.updateRoleStatus(roleId, isSelected);
      // },
      cells: [
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
                ? textToDate(roleData['added_date']) //
                : 'N/A',
          ),
        ),
        DataCell(Align(
          // alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              publicPrivateSection(roleData, controller, roleId),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: editSection(
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

ElevatedButton publicPrivateSection(
    roleData, ResponsibilitiesController controller, roleId) {
  return ElevatedButton(
      style: roleData['is_shown_for_users'] == false
          ? privateButtonStyle
          : publicButtonStyle,
      onPressed: () {
        bool status;
        if (roleData['is_shown_for_users'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.updateRoleStatus(roleId, status);
      },
      child: roleData['is_shown_for_users'] == true
          ? const Text('Public')
          : const Text('Private'));
}

ElevatedButton deleteSection(
    context, ResponsibilitiesController controller, roleId) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: 'The responsibility will be deleted permanently',
            onPressed: () {
              controller.deleteResponsibility(roleId);
            });
      },
      child: const Text('Delete'));
}

Widget editSection(
    {required context,
    required ResponsibilitiesController controller,
    required roleData,
    required constraints,
    required roleID}) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              controller.responsibilityName.text = roleData['role_name'] ?? '';

              controller.menuName.text = roleData['menu']['name'] ?? '';
              controller.menuIDFromList.value = roleData['menu_id'];

              // print(controller.menuName.text);
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewResponsibilityOrView(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child:
                        GetX<ResponsibilitiesController>(builder: (controller) {
                      return ElevatedButton(
                        onPressed:
                            controller.addingNewResponsibilityProcess.value
                                ? null
                                : () {
                                    controller.updateResponsibility(roleID);
                                  },
                        style: saveButtonStyle,
                        child:
                            controller.addingNewResponsibilityProcess.value ==
                                    false
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
                      );
                    }),
                  ),
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
      child: const Text('Edit'));
}
