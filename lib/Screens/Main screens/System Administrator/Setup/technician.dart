import 'package:datahubai/Models/technicians/technicians_model.dart';
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
                        onChanged: (_) {
                          controller.filterTechnicians();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterTechnicians();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for technicianses',
                        button: newtechniciansesButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<TechnicianController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allTechnician.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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
  required TechnicianController controller,
}) {
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
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Name', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Job'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSort,
      ),
    ],
    rows:
        controller.filteredTechnicians.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allTechnician.map<DataRow>((technicians) {
            final techniciansId = technicians.id;
            return dataRowForTheTable(
              technicians,
              context,
              constraints,
              techniciansId,
              controller,
            );
          }).toList()
        : controller.filteredTechnicians.map<DataRow>((technicians) {
            final techniciansId = technicians.id;
            return dataRowForTheTable(
              technicians,
              context,
              constraints,
              techniciansId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  TechnicianModel techniciansData,
  context,
  constraints,
  techniciansId,
  TechnicianController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, techniciansId, context),
            editSection(
              context,
              controller,
              techniciansData,
              constraints,
              techniciansId,
            ),
          ],
        ),
      ),
      DataCell(Text(techniciansData.name ?? '')),
      DataCell(Text(techniciansData.job ?? '')),
      DataCell(Text(textToDate(techniciansData.createdAt))),
    ],
  );
}

IconButton deleteSection(
  TechnicianController controller,
  techniciansId,
  context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The technicians will be deleted permanently",
        onPressed: () {
          controller.deleteTechnician(techniciansId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  TechnicianController controller,
  TechnicianModel techniciansData,
  BoxConstraints constraints,
  String techniciansId,
) {
  return IconButton(
    onPressed: () async {
      controller.name.text = techniciansData.name ?? '';
      controller.job.text = techniciansData.job ?? '';
      technicianDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.updateTechnicians(techniciansId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newtechniciansesButton(
  BuildContext context,
  BoxConstraints constraints,
  TechnicianController controller,
) {
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
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Technician'),
  );
}
