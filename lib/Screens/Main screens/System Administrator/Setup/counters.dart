import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/counters_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/counters_widgets/counters_dialog.dart';
import '../../../../consts.dart';

class Counters extends StatelessWidget {
  const Counters({super.key});

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
                  GetX<CountersController>(
                    init: CountersController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for counters',
                        button:
                            newCounterButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CountersController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allCounters.isEmpty) {
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
    required CountersController controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    horizontalMargin: horizontalMarginForTable,
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
          text: 'Description',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Prefix',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Value',
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
    rows: controller.filteredCounters.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCounters.map<DataRow>((counter) {
            final counterData = counter.data() as Map<String, dynamic>;
            final counterId = counter.id;
            return dataRowForTheTable(
                counterData, context, constraints, counterId, controller);
          }).toList()
        : controller.filteredCounters.map<DataRow>((counter) {
            final counterData = counter.data() as Map<String, dynamic>;
            final counterId = counter.id;
            return dataRowForTheTable(
                counterData, context, constraints, counterId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> counterData, context,
    constraints, counterId, CountersController controller) {
  return DataRow(cells: [
    DataCell(Text(
      counterData['code'] ?? 'no code',
    )),
    DataCell(
      Text(
        counterData['description'] ?? 'no description',
      ),
    ),
    DataCell(
      Text(
        counterData['prefix'] ?? 'no prefix',
      ),
    ),
    DataCell(
      Text(
        '${counterData['value']}',
      ),
    ),
    DataCell(
      Text(
        counterData['added_date'] != null && counterData['added_date'] != ''
            ? textToDate(counterData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        activeInActiveSection(controller, counterData, counterId),
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: editSection(
              context, controller, counterData, constraints, counterId),
        ),
        deleteSection(controller, counterId, context),
      ],
    )),
  ]);
}

ElevatedButton activeInActiveSection(CountersController controller,
    Map<String, dynamic> counterData, String counterId) {
  return ElevatedButton(
      style: counterData['status'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        if (counterData['status'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.changeCounterStatus(counterId, status);
      },
      child: counterData['status'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton deleteSection(
    CountersController controller, variableId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The counter will be deleted permanently",
            onPressed: () {
              controller.deleteCounter(variableId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, CountersController controller,
    Map<String, dynamic> counterData, constraints, counterId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.code.text = counterData['code'] ?? '';
        controller.description.text = counterData['description'] ?? '';
        controller.prefix.text = counterData['prefix'] ?? '';
        controller.value.text = (counterData['value'] ?? '').toString();
        controller.length.text = (counterData['length'] ?? '0').toString();
        controller.separator.text = counterData['separator'] ?? '';
        countersDialog(
            constraints: constraints,
            controller: controller,
            canEdit: false,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editCounter(counterId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newCounterButton(BuildContext context,
    BoxConstraints constraints, CountersController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.code.clear();
      controller.description.clear();
      controller.prefix.clear();
      controller.value.clear();
      controller.length.clear();
      countersDialog(
          constraints: constraints,
          controller: controller,
          canEdit: true,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  await controller.addNewCounter();
                });
    },
    style: newButtonStyle,
    child: const Text('New Counter'),
  );
}
