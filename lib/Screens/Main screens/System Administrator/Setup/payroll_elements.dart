import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/payroll_elements_controller.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/defination_widgets/defination_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class Defination extends StatelessWidget {
  const Defination({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Column(
              children: [
                GetBuilder<PayrollElementsController>(
                  init: PayrollElementsController(),
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                myTextFormFieldWithBorder(
                                  width: 250,
                                  labelText: 'Name',
                                  // controller: controller.employeeNameFilter,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GetX<PayrollElementsController>(
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                newButton(context, constraints, controller),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                CustomSlidingSegmentedControl<int>(
                                  height: 30,
                                  initialValue:
                                      controller.initTypePickersValue.value,
                                  children: const {
                                    1: Text('ALL'),
                                    2: Text(''),
                                    3: Text(''),
                                    4: Text(''),
                                  },
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.lightBackgroundGray,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  thumbDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(1),
                                        blurRadius: 4.0,
                                        spreadRadius: 1.0,
                                        offset: const Offset(0.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInToLinear,
                                  onValueChanged: (v) {
                                    // controller.onChooseForTypePicker(v);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  style: findButtonStyle,
                                  onPressed: controller.isScreenLoding.isFalse
                                      ? () async {
                                          // controller.filterSearch();
                                        }
                                      : null,
                                  child: controller.isScreenLoding.isFalse
                                      ? Text(
                                          'Find',
                                          style: fontStyleForElevatedButtons,
                                        )
                                      : loadingProcess,
                                ),
                                ElevatedButton(
                                  style: clearVariablesButtonStyle,
                                  onPressed: () {
                                    // controller.clearAllFilters();
                                    // controller.update();
                                  },
                                  child: Text(
                                    'Clear',
                                    style: fontStyleForElevatedButtons,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetBuilder<PayrollElementsController>(
                      builder: (controller) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreens(
                            constraints: constraints,
                            context: context,
                            controller: controller,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
  required PayrollElementsController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    autoRowsToHeight: true,
    renderEmptyRowsInTheEnd: true,
    columns: [
      const DataColumn2(label: Text(''), size: ColumnSize.S),
      DataColumn2(
        label: AutoSizedText(text: 'Full Name', constraints: constraints),
        size: ColumnSize.M,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Type'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Status'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Employer'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Department'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Job Title'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Location'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: [],
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  dynamic data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  PayrollElementsController controller,
  int index,
) {
  return DataRow(
    cells: [
      const DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // deleteSection(controller, employeeId, context),
            // editSection(context, controller, data, constraints, employeeId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.fullName ?? '',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(textForDataRowInTable(text: data.personType ?? '')),
      DataCell(textForDataRowInTable(text: data.statusName ?? '')),
      DataCell(textForDataRowInTable(text: data.employerName ?? '')),
      DataCell(textForDataRowInTable(text: data.departmentName ?? '')),
      DataCell(
        textForDataRowInTable(isBold: true, text: data.jobTitleName ?? ''),
      ),
      DataCell(
        textForDataRowInTable(isBold: true, text: data.locationName ?? ''),
      ),
    ],
  );
}

ElevatedButton newButton(
  BuildContext context,
  BoxConstraints constraints,
  PayrollElementsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      // controller.clearValues(isEmployee);

      definationDialog(
        context: context,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                // await controller.addNewEmployee();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New'),
  );
}

class CardDataSourceForEmployees extends DataTableSource {
  final List cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final PayrollElementsController controller;

  CardDataSourceForEmployees({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final card = cards[index];
    final cardId = card.id ?? '';

    return dataRowForTheTable(
      card,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
