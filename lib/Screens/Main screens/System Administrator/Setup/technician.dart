import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/technician_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/technician_widgets/technician_dialog.dart';
import '../../../../consts.dart';

class Technician extends StatelessWidget {
  const Technician({super.key});

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
                  GetX<TechnicianController>(
                    init: TechnicianController(),
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
                    child: GetX<TechnicianController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allTechnician.isEmpty) {
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
    required TechnicianController controller}) {
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
          text: 'Name',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Job',
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
        label: Text(''),
      ),
    ],
    rows: controller.filteredTechnicians.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allTechnician.map<DataRow>((branch) {
            final branchData = branch.data() as Map<String, dynamic>;
            final branchId = branch.id;
            return dataRowForTheTable(
                branchData, context, constraints, branchId, controller);
          }).toList()
        : controller.filteredTechnicians.map<DataRow>((branch) {
            final branchData = branch.data() as Map<String, dynamic>;
            final branchId = branch.id;
            return dataRowForTheTable(
                branchData, context, constraints, branchId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> branchData, context,
    constraints, branchId, TechnicianController controller) {
  return DataRow(cells: [
    DataCell(Text(
      branchData['name'] ?? '',
    )),
    DataCell(
      Text(
        branchData['job'] ?? '',
      ),
    ),
    DataCell(
      Text(
        branchData['added_date'] != null && branchData['added_date'] != ''
            ? textToDate(branchData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        editSection(
            context, controller, branchData, constraints, branchId),
        deleteSection(controller, branchId, context),
      ],
    )),
  ]);
}


ElevatedButton deleteSection(TechnicianController controller, branchId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The branch will be deleted permanently",
            onPressed: () {
              // controller.deleteBranch(branchId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, TechnicianController controller,
    Map<String, dynamic> branchData, constraints, branchId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
       
        technicianDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    // controller.editBranch(branchId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newBranchesButton(BuildContext context,
    BoxConstraints constraints, TechnicianController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.job.clear();
      
      technicianDialog(
          constraints: constraints,
          controller: controller,
          canEdit: true,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  // await controller.addNewBranch();
                });
    },
    style: newButtonStyle,
    child: const Text('New Technician'),
  );
}
