import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/branches_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/branches_widgets/add_new_branch_or_edit.dart';
import '../../../../consts.dart';

class Branches extends StatelessWidget {
  const Branches({super.key});

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
                  GetX<BranchesController>(
                    init: BranchesController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for branches',
                        button:
                            newBranchesButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<BranchesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allBranches.isEmpty) {
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
    required BranchesController controller}) {
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
    rows: controller.filteredBranches.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allBranches.map<DataRow>((branch) {
            final branchData = branch.data() as Map<String, dynamic>;
            final branchId = branch.id;
            return dataRowForTheTable(
                branchData, context, constraints, branchId, controller);
          }).toList()
        : controller.filteredBranches.map<DataRow>((branch) {
            final branchData = branch.data() as Map<String, dynamic>;
            final branchId = branch.id;
            return dataRowForTheTable(
                branchData, context, constraints, branchId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> branchData, context,
    constraints, branchId, BranchesController controller) {
  return DataRow(cells: [
    DataCell(Text(
      branchData['code'] ?? 'no code',
    )),
    DataCell(
      Text(
        branchData['name'] ?? 'no name',
      ),
    ),
    DataCell(
      Text(
        branchData['added_date'] != null && branchData['added_date'] != ''
            ? textToDate(branchData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        activeInActiveSection(controller, branchData, branchId),
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: editSection(
              context, controller, branchData, constraints, branchId),
        ),
        deleteSection(controller, branchId, context),
      ],
    )),
  ]);
}

ElevatedButton activeInActiveSection(BranchesController controller,
    Map<String, dynamic> branchData, String branchId) {
  return ElevatedButton(
      style: branchData['status'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        if (branchData['status'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.changeBranchStatus(branchId, status);
      },
      child: branchData['status'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton deleteSection(BranchesController controller, branchId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The branch will be deleted permanently",
            onPressed: () {
              controller.deleteBranch(branchId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, BranchesController controller,
    Map<String, dynamic> branchData, constraints, branchId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              controller.onSelect(branchData['country_id']);
              controller.code.text = branchData['code'] ?? '';
              controller.name.text = branchData['name'] ?? '';
              controller.line.text = branchData['line'] ?? '';
              controller.country.text =
                  controller.getCountryName(branchData['country_id'])!;
              controller.city.text =
                  controller.getCityName(branchData['city_id'])!;
              controller.countryId.value = branchData['country_id'];
              controller.cityId.value = branchData['city_id'];

              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewBranchOrEdit(
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
                              controller.editBranch(branchId);
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

ElevatedButton newBranchesButton(BuildContext context,
    BoxConstraints constraints, BranchesController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.code.clear();
      controller.name.clear();
      controller.line.clear();
      controller.country.clear();
      controller.countryId.value = '';
      controller.city.clear();
      controller.cityId.value = '';
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewBranchOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<BranchesController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewValue.value
                                ? null
                                : () async {
                                    await controller.addNewBranch();
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
    child: const Text('New Branch'),
  );
}
