import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/branches_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/branches_widgets/branches_dialog.dart';
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
                        // controller: controller,
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
    {required BoxConstraints constraints,
    required BuildContext context,
    required BranchesController controller}) {
  return DataTable(
    horizontalMargin: horizontalMarginForTable,
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
      const DataColumn(
        label: Text(''),
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
      mainAxisAlignment: MainAxisAlignment.end,
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
            content: "The branch will be deleted permanently",
            onPressed: () {
              controller.deleteBranch(branchId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(BuildContext context, BranchesController controller,
    Map<String, dynamic> branchData, constraints, branchId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        controller.city.text = (await controller.getCityName(
            branchData['country_id'], branchData['city_id']))!;
        controller.getCitiesByCountryID(branchData['country_id']);
        controller.code.text = branchData['code'] ?? '';
        controller.name.text = branchData['name'] ?? '';
        controller.line.text = branchData['line'] ?? '';
        controller.country.text =
            controller.getCountryName(branchData['country_id'])!;

        controller.countryId.value = branchData['country_id'];
        controller.cityId.value = branchData['city_id'];
        branchesDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editBranch(branchId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newBranchesButton(BuildContext context,
    BoxConstraints constraints, BranchesController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.allCities.clear();
      controller.code.clear();
      controller.name.clear();
      controller.line.clear();
      controller.country.clear();
      controller.countryId.value = '';
      controller.city.clear();
      controller.cityId.value = '';
      branchesDialog(
          constraints: constraints,
          controller: controller,
          canEdit: true,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  await controller.addNewBranch();
                });
    },
    style: newButtonStyle,
    child: const Text('New Branch'),
  );
}
