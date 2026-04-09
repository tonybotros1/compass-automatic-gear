import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/payroll_elements_controller.dart';
import '../../../../Models/payroll elements/payroll_elements_model.dart';
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
                                  labelText: 'Key',
                                  controller: controller.elementKeyFilter,
                                ),
                                myTextFormFieldWithBorder(
                                  width: 250,
                                  labelText: 'Name',
                                  controller: controller.elementNameFilter,
                                ),
                                // MenuWithValues(
                                //   labelText: 'Type',
                                //   headerLqabel: 'Types',
                                //   dialogWidth: 600,
                                //   width: 250,
                                //   controller: controller.elementTypeFilter,
                                //   displayKeys: const ['name'],
                                //   displaySelectedKeys: const ['name'],
                                //   data: controller.elementTypes,
                                //   onDelete: () {
                                //     controller.elementTypeFilter.clear();
                                //   },
                                //   onSelected: (value) {
                                //     controller.elementTypeFilter.value =
                                //         value['name'];
                                //   },
                                // ),
                                // myTextFormFieldWithBorder(
                                //   width: 250,
                                //   labelText: 'Priority',
                                //   controller: controller.elementPriorityFilter,
                                // ),
                                // myTextFormFieldWithBorder(
                                //   width: 250,
                                //   labelText: 'Comments',
                                //   controller: controller.elementCommentFilter,
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
                                newElementButton(
                                  context,
                                  constraints,
                                  controller,
                                ),
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
                                    2: Text('EARNING'),
                                    3: Text('DEDUCTION'),
                                    4: Text('INFORMATION'),
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
                                    controller.onChooseForTypePicker(v);
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
                                          controller.filterSearch();
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
                                    controller.clearSearchValues();
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
                    child: GetX<PayrollElementsController>(
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
    lmRatio: 2.5,
    columns: [
      const DataColumn2(label: Text(''), size: ColumnSize.S),
      DataColumn2(
        label: AutoSizedText(text: 'Key', constraints: constraints),
        size: ColumnSize.M,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Name'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Type'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Priority'),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Comments'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: controller.allPayrollElements.isEmpty
          ? []
          : controller.allPayrollElements,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  PayrollElementsModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  PayrollElementsController controller,
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
          text: data.key ?? '',
          color: Colors.blueGrey,
          isBold: true,
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.type ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.priority ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.comments ?? '',
          formatDouble: false,
          maxLines: null,
        ),
      ),
    ],
  );
}

ElevatedButton newElementButton(
  BuildContext context,
  BoxConstraints constraints,
  PayrollElementsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      definationDialog(
        context: context,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                await controller.addNewPayrollElement();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Element'),
  );
}

IconButton deleteSection(
  PayrollElementsController controller,
  String employeeId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The doc will be deleted permanently",
        onPressed: () {
          controller.deletePayrollElement(employeeId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  PayrollElementsController controller,
  PayrollElementsModel data,
  BoxConstraints constraints,
  String elementID,
) {
  return IconButton(
    onPressed: () async {
      controller.loadValues(data);
      definationDialog(
        context: context,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewPayrollElement();
              },
      );
    },
    icon: editIcon,
  );
}

class CardDataSourceForEmployees extends DataTableSource {
  final List<PayrollElementsModel> cards;
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
