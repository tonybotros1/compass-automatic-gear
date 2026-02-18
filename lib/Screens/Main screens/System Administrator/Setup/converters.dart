import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/converters_controller.dart';
import '../../../../Models/converters/converter_model.dart';
import '../../../../Models/dynamic_boxes_line_model.dart';
import '../../../../Widgets/dynamic_boxes_line.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/converters_widgets/converter_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class Converters extends StatelessWidget {
  const Converters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: SizedBox(
              width: constraints.maxWidth,
              child: ListView(
                children: [
                  GetBuilder<ConvertersController>(
                    init: ConvertersController(),
                    builder: (controller) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth - 28,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 10,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 10,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 150,
                                    labelText: 'Converter NO.',
                                    controller:
                                        controller.converterNumberFilter,
                                  ),
                                  myTextFormFieldWithBorder(
                                    width: 150,
                                    labelText: 'Name',
                                    controller: controller.converterNameFilter,
                                  ),
                                  myTextFormFieldWithBorder(
                                    width: 300,
                                    labelText: 'Description',
                                    controller:
                                        controller.converterDescriptionFilter,
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 120,
                                    controller: controller.fromDate,
                                    labelText: 'From Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.fromDate.text,
                                        controller.fromDate,
                                      );
                                    },
                                  ),
                                  myTextFormFieldWithBorder(
                                    width: 120,
                                    controller: controller.toDate,
                                    labelText: 'To Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.toDate.text,
                                        controller.toDate,
                                      );
                                    },
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
                  GetX<ConvertersController>(
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
                              newConverterButton(
                                context,
                                constraints,
                                controller,
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  CustomSlidingSegmentedControl<int>(
                                    height: 30,
                                    initialValue:
                                        controller.initDatePickerValue.value,
                                    children: const {
                                      1: Text('ALL'),
                                      2: Text('TODAY'),
                                      3: Text('THIS MONTH'),
                                      4: Text('THIS YEAR'),
                                    },
                                    decoration: BoxDecoration(
                                      color:
                                          CupertinoColors.lightBackgroundGray,
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
                                      controller.onChooseForDatePicker(v);
                                    },
                                  ),
                                  separator(color: Colors.black),
                                  CustomSlidingSegmentedControl<int>(
                                    height: 30,
                                    initialValue:
                                        controller.initStatusPickersValue.value,
                                    children: const {
                                      1: Text('ALL'),
                                      2: Text('NEW'),
                                      3: Text('POSTED'),
                                      4: Text('CANCELLED'),
                                    },
                                    decoration: BoxDecoration(
                                      color:
                                          CupertinoColors.lightBackgroundGray,
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
                                      controller.onChooseForStatusPicker(v);
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
                                      controller.clearAllFilters();
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GetX<ConvertersController>(
                      builder: (controller) {
                        return SizedBox(
                          height: 100,

                          // padding: const EdgeInsets.all(4),
                          child: dynamicBoxesLine(
                            dynamicConfigs: [
                              DynamicBoxesLineModel(
                                isFormated: false,
                                width: 300,
                                label: 'NUMBER OF CONVERTERS',
                                value: '${controller.numberOfConverters.value}',
                                valueColor: mainColor,
                                icon: counterIcon,
                                iconColor: mainColorWithAlpha,
                              ),
                              DynamicBoxesLineModel(
                                icon: moneyIcon,
                                iconColor: Colors.green.shade100,
                                width: 300,
                                label: 'TOTAL AMOUNT',
                                value:
                                    '${controller.allConvertersTotals.value}',
                                valueColor: Colors.green,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  GetX<ConvertersController>(
                    builder: (controller) {
                      return Container(
                        height: constraints.maxHeight * 0.73,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        child: tableOfScreens(
                          showHistoryButton: true,
                          scrollController:
                              controller.scrollControllerFotTable1,
                          constraints: constraints,
                          context: context,
                          controller: controller,
                          data: controller.allConverters,
                        ),
                      );
                    },
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
  required ConvertersController controller,
  required RxList<ConverterModel> data,
  required ScrollController scrollController,
  required bool showHistoryButton,
}) {
  bool isReceivingLoading = data.isEmpty;

  return DataTableTheme(
    data: DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300;
        }
        return null;
      }),
    ),
    child: PaginatedDataTable2(
      showCheckboxColumn: false,
      autoRowsToHeight: true,
      columnSpacing: 5,
      lmRatio: 2.5,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      columns: [
        const DataColumn2(
          size: ColumnSize.S,
          label: SizedBox(),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(text: 'Number', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(text: 'Date', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(text: 'Status', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(text: 'Name', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(text: 'Description', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          numeric: true,
          label: AutoSizedText(text: 'Total', constraints: constraints),
          // onSort: controller.onSort,
        ),
      ],
      source: ConverterDataSource(
        cards: isReceivingLoading ? [] : data,
        context: context,
        constraints: constraints,
        controller: controller,
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  ConverterModel docData,
  BuildContext context,
  BoxConstraints constraints,
  String docId,
  ConvertersController controller,
  int index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return !isEvenRow ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(editConverterButton(context, constraints, controller, docData)),
      DataCell(
        textForDataRowInTable(
          text: docData.converterNumber ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(textForDataRowInTable(text: textToDate(docData.date))),
      DataCell(
        statusBox(
          docData.status ?? '',
          hieght: 35,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),
      DataCell(
        textForDataRowInTable(text: docData.name ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.description ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.total.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
    ],
  );
}

ElevatedButton newConverterButton(
  BuildContext context,
  BoxConstraints constraints,
  ConvertersController controller,
) {
  return ElevatedButton(
    onPressed: () async {
      controller.clearValues();
      converterDialog(
        controller: controller,

        onTapForSave: () async {
          await controller.addNewConverter();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Converter'),
  );
}

IconButton editConverterButton(
  BuildContext context,
  BoxConstraints constraints,
  ConvertersController controller,
  ConverterModel data,
) {
  return IconButton(
    onPressed: () {
      controller.loadValues(data);
      converterDialog(
        controller: controller,
        onTapForPost: () async {
          controller.editPostedStatus(data.issues ?? []);
        },
        onTapForSave: () async {
          await controller.addNewConverter();
        },
        onTapForDelete: () {
          alertDialog(
            context: context,
            content: "This will be deleted permanently",
            onPressed: () {
              controller.deleteConverterCard(data.id ?? '');
            },
          );
        },
        onTapForCancel: () {
          controller.editCancelledStatus();
        },
      );
    },
    icon: editIcon,
  );
}

class ConverterDataSource extends DataTableSource {
  final List<ConverterModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final ConvertersController controller;

  ConverterDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final rec = cards[index];
    final cardId = rec.id ?? '';

    return dataRowForTheTable(
      rec,
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
