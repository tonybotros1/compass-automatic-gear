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
                        // controller: controller,
                        title: 'Search for technicianses',
                        button: newtechniciansesButton(
                            context, constraints, controller),
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
      const DataColumn(
        label: Text(''),
      ),
    ],
    rows: controller.filteredTechnicians.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allTechnician.map<DataRow>((technicians) {
            final techniciansData = technicians.data() as Map<String, dynamic>;
            final techniciansId = technicians.id;
            return dataRowForTheTable(techniciansData, context, constraints,
                techniciansId, controller);
          }).toList()
        : controller.filteredTechnicians.map<DataRow>((technicians) {
            final techniciansData = technicians.data() as Map<String, dynamic>;
            final techniciansId = technicians.id;
            return dataRowForTheTable(techniciansData, context, constraints,
                techniciansId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> techniciansData, context,
    constraints, techniciansId, TechnicianController controller) {
  return DataRow(cells: [
    DataCell(Text(
      techniciansData['name'] ?? '',
    )),
    DataCell(
      Text(
        techniciansData['job'] ?? '',
      ),
    ),
    DataCell(
      Text(
        techniciansData['added_date'] != null &&
                techniciansData['added_date'] != ''
            ? textToDate(techniciansData['added_date'])
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        editSection(
            context, controller, techniciansData, constraints, techniciansId),
        deleteSection(controller, techniciansId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    TechnicianController controller, techniciansId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The technicians will be deleted permanently",
            onPressed: () {
              controller.deleteTechnician(techniciansId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, TechnicianController controller,
    Map<String, dynamic> techniciansData, constraints, techniciansId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        controller.name.text = techniciansData['name'];
        controller.job.text = techniciansData['job'];
        technicianDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editTechnician(techniciansId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newtechniciansesButton(BuildContext context,
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
                  await controller.addNewTechnicians();
                });
    },
    style: newButtonStyle,
    child: const Text('New Technician'),
  );
}
