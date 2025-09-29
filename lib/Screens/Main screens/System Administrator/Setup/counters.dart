import 'package:datahubai/Models/counters/counters_model.dart';
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
                        onChanged: (_) {
                          controller.filterCounters();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterCounters();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for counters',
                        button: newCounterButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CountersController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allCounters.isEmpty) {
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
  required CountersController controller,
}) {
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
        label: AutoSizedText(text: 'Code', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Description'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Prefix'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Value'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSort,
      ),
      const DataColumn(label: Text('')),
    ],
    rows:
        controller.filteredCounters.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCounters.map<DataRow>((counter) {
            final counterId = counter.id;
            return dataRowForTheTable(
              counter,
              context,
              constraints,
              counterId,
              controller,
            );
          }).toList()
        : controller.filteredCounters.map<DataRow>((counter) {
            final counterId = counter.id;
            return dataRowForTheTable(
              counter,
              context,
              constraints,
              counterId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  CountersModel counterData,
  context,
  constraints,
  counterId,
  CountersController controller,
) {
  return DataRow(
    cells: [
      DataCell(Text(counterData.code)),
      DataCell(Text(counterData.description)),
      DataCell(Text(counterData.prefix)),
      DataCell(Text('${counterData.value}')),
      DataCell(Text(textToDate(counterData.createdAt))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            activeInActiveSection(controller, counterData, counterId),
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: editSection(
                context,
                controller,
                counterData,
                constraints,
                counterId,
              ),
            ),
            deleteSection(controller, counterId, context),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton activeInActiveSection(
  CountersController controller,
  CountersModel counterData,
  String counterId,
) {
  return ElevatedButton(
    style: counterData.status == false
        ? inActiveButtonStyle
        : activeButtonStyle,
    onPressed: () {
      bool status;
      if (counterData.status == false) {
        status = true;
      } else {
        status = false;
      }
      controller.changeCounterStatus(counterId, status);
    },
    child: counterData.status == true
        ? const Text('Active')
        : const Text('Inactive'),
  );
}

ElevatedButton deleteSection(
  CountersController controller,
  variableId,
  context,
) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: "The counter will be deleted permanently",
        onPressed: () {
          controller.deleteCounter(variableId);
        },
      );
    },
    child: const Text("Delete"),
  );
}

ElevatedButton editSection(
  BuildContext context,
  CountersController controller,
  CountersModel counterData,
  constraints,
  counterId,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () {
      controller.code.text = counterData.code;
      controller.description.text = counterData.description;
      controller.prefix.text = counterData.prefix;
      controller.value.text = (counterData.value).toString();
      controller.length.text = (counterData.length).toString();
      controller.separator.text = counterData.separator;
      countersDialog(
        constraints: constraints,
        controller: controller,
        canEdit: false,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.editCounter(counterId);
              },
      );
    },
    child: const Text('Edit'),
  );
}

ElevatedButton newCounterButton(
  BuildContext context,
  BoxConstraints constraints,
  CountersController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.code.clear();
      controller.description.clear();
      controller.prefix.clear();
      controller.value.clear();
      controller.length.clear();
      controller.separator.clear();
      countersDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                await controller.addNewCounter();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Counter'),
  );
}
