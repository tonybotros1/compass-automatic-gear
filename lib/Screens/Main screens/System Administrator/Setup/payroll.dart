import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../../Models/payroll/payroll_model.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/payroll_widgets/payroll_dialog.dart';
import '../../../../consts.dart';

class Payroll extends StatelessWidget {
  const Payroll({super.key});

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
                GetBuilder<PayrollController>(
                  init: PayrollController(),
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                // myTextFormFieldWithBorder(
                                //   width: 250,
                                //   labelText: 'Name',
                                //   controller: controller.nameFilter,
                                // ),
                                // myTextFormFieldWithBorder(
                                //   width: 250,
                                //   labelText: 'Code',
                                //   controller: controller.codeFilter,
                                // ),
                                // MenuWithValues(
                                //   labelText: 'Based Element',
                                //   headerLqabel: 'Based Elements',
                                //   dialogWidth: 600,
                                //   width: 300,
                                //   controller: controller.basedElementFilter,
                                //   displayKeys: const ['name'],
                                //   displaySelectedKeys: const ['name'],
                                //   onOpen: () {
                                //     return controller.getAllPayrollElements();
                                //   },
                                //   onDelete: () {
                                //     controller.basedElementFilterId.value = "";
                                //     controller.basedElementFilter.clear();
                                //   },
                                //   onSelected: (value) {
                                //     controller.basedElementFilterId.value =
                                //         value['_id'];
                                //     controller.basedElementFilter.text =
                                //         value['name'];
                                //   },
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GetX<PayrollController>(
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
                            newPayrollButton(context, constraints, controller),
                            CustomSlidingSegmentedControl<int>(
                              height: 30,
                              initialValue:
                                  controller.initTypePickersValue.value,
                              children: const {
                                1: Text('ALL'),
                                2: Text('CALENDAR DAYS'),
                                3: Text('WORKING DAYS'),
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
                    child: GetX<PayrollController>(
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
  required PayrollController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    autoRowsToHeight: true,
    renderEmptyRowsInTheEnd: true,
    columns: [
      const DataColumn2(label: Text(''), size: ColumnSize.S),
      DataColumn2(
        label: AutoSizedText(text: 'Name', constraints: constraints),
        size: ColumnSize.M,
      ),
      DataColumn2(
        label: AutoSizedText(text: 'Status', constraints: constraints),
        size: ColumnSize.M,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Period Type'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(
          constraints: constraints,
          text: 'First Period Start Date',
        ),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Number of Years'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'AP Invoice Type'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: controller.allPayrolls.isEmpty ? [] : controller.allPayrolls,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  PayrollModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  PayrollController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, employeeId, context),
            editSection(context, controller, data, constraints, employeeId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          color: Colors.blueGrey,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(statusBox(data.status ?? '')),
      DataCell(
        textForDataRowInTable(text: data.periodType ?? '', maxWidth: null),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.firstPeriodStartDate),
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.numberOfYears.toString(),
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.apInvoiceTypeName ?? '',
          maxWidth: null,
        ),
      ),
    ],
  );
}

IconButton deleteSection(
  PayrollController controller,
  String id,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The type will be deleted permanently",
        onPressed: () {
          // controller.deleteLeaveType(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  PayrollController controller,
  PayrollModel data,
  BoxConstraints constraints,
  String id,
) {
  return IconButton(
    onPressed: () async {
      // controller.name.text = data.name ?? '';
      // controller.code.text = data.code ?? '';
      // controller.type.text = data.type ?? '';
      // controller.basedElement.text = data.basedElement ?? '';
      // controller.basedElementId.value = data.basedElementId ?? '';
      // controller.isCalendarDaysSelected.value = data.type == "Calendar Days"
      //     ? true
      //     : false;
      // leaveTypesDialog(
      //   constraints: constraints,
      //   controller: controller,
      //   onPressed: controller.addingNewValue.value
      //       ? null
      //       : () {
      //           controller.editLeaveType(id);
      //         },
      // );
    },
    icon: editIcon,
  );
}

ElevatedButton newPayrollButton(
  BuildContext context,
  BoxConstraints constraints,
  PayrollController controller,
) {
  return ElevatedButton(
    onPressed: () {
      // controller.name.clear();
      // controller.code.clear();
      // controller.type.clear();
      // controller.basedElement.clear();
      // controller.basedElementId.value = '';
      payrollDialog(
        context: context,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewPayroll();
              },
      );
    },
    style: newButtonStyle,
    child: const Text("New Payroll"),
  );
}

class CardDataSourceForEmployees extends DataTableSource {
  final List<PayrollModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final PayrollController controller;

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
