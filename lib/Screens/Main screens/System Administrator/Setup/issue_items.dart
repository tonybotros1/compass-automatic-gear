import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/issue_items_controller.dart';
import '../../../../Models/dynamic_boxes_line_model.dart';
import '../../../../Models/issuing/issung_model.dart';
import '../../../../Widgets/dynamic_boxes_line.dart';
import '../../../../Widgets/main screen widgets/issue_items_widgets/issue_dialog.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class IssueItems extends StatelessWidget {
  const IssueItems({super.key});

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
                  GetX<IssueItemsController>(
                    init: IssueItemsController(),
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
                                    labelText: 'Number',
                                    controller:
                                        controller.issueNumberFilter.value,
                                  ),
                                  // myTextFormFieldWithBorder(
                                  //   width: 300,
                                  //   labelText: 'Job Card',
                                  //   controller: controller.issueNumberFilter.value,
                                  // ),
                                  // myTextFormFieldWithBorder(
                                  //   width: 300,
                                  //   labelText: 'Converter',
                                  //   controller: controller.issueNumberFilter.value,
                                  // ),
                                  // CustomDropdown(
                                  //   width: 300,
                                  //   textcontroller:
                                  //       controller.jobConverterFilter.value.text,
                                  //   showedSelectedName: 'name',
                                  //   hintText: 'Job / Converter',
                                  //   onChanged: (key, value) async {
                                  //     controller.jobConverterFilter.value.text =
                                  //         value['name'];
                                  //     controller.jobConverterIdFilter.value = key;
                                  //   },
                                  //   items: isJobConverterLoading
                                  //       ? {}
                                  //       : controller.alljobConverters,
                                  // ),
                                  MenuWithValues(
                                    labelText: 'Issue To',
                                    headerLqabel: 'Issue To',
                                    dialogWidth: constraints.maxWidth / 3,
                                    width: 300,
                                    controller:
                                        controller.receivedByFilter.value,
                                    displayKeys: const ['name'],
                                    displaySelectedKeys: const ['name'],
                                    onOpen: () {
                                      return controller.getISSUERECEIVEPEOPLE();
                                    },
                                    onDelete: () {
                                      controller.receivedByFilter.value.clear();
                                      controller.receivedByIdFilter.value = '';
                                    },
                                    onSelected: (value) {
                                      controller.receivedByFilter.value.text =
                                          value['name'];
                                      controller.receivedByIdFilter.value =
                                          value['_id'];
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 120,
                                    controller: controller.fromDate.value,
                                    labelText: 'From Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.fromDate.value.text,
                                        controller.fromDate.value,
                                      );
                                    },
                                  ),
                                  myTextFormFieldWithBorder(
                                    width: 120,
                                    controller: controller.toDate.value,
                                    labelText: 'To Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.toDate.value.text,
                                        controller.toDate.value,
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
                  GetX<IssueItemsController>(
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
                            children: [
                              newIssueButton(context, constraints, controller),
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
                                      'Clear Filters',
                                      style: fontStyleForElevatedButtons,
                                    ),
                                  ),
                                ],
                              ),
                              // Expanded(flex: 2, child: SizedBox()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GetX<IssueItemsController>(
                      builder: (controller) {
                        return SizedBox(
                          height: 100,
                          child: dynamicBoxesLine(
                            dynamicConfigs: [
                              DynamicBoxesLineModel(
                                isFormated: false,
                                width: 300,
                                label: 'NUMBER OF DOCS',
                                value:
                                    '${controller.numberOfIssuesgDocs.value}',
                                valueColor: Colors.blue,
                                icon: counterIcon,
                                iconColor: Colors.blue.shade100,
                              ),
                              DynamicBoxesLineModel(
                                icon: moneyIcon,
                                iconColor: Colors.green.shade100,
                                width: 300,
                                label: 'TOTAL AMOUNT',
                                value: '${controller.allIssuesTotals.value}',
                                valueColor: Colors.green,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  GetX<IssueItemsController>(
                    builder: (controller) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.73,
                          child: tableOfScreens(
                            showHistoryButton: true,
                            scrollController:
                                controller.scrollControllerFotTable1,
                            constraints: constraints,
                            context: context,
                            controller: controller,
                            data: controller.allIssuesDocs,
                          ),
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
  required IssueItemsController controller,
  required RxList<IssuingModel> data,
  required ScrollController scrollController,
  required bool showHistoryButton,
}) {
  bool isJobsLoading = data.isEmpty;

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
      columnSpacing: 15,
      lmRatio: 2.5,
      autoRowsToHeight: true,
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
          size: ColumnSize.M,
          label: AutoSizedText(
            text: 'Issue Type',
            constraints: constraints,
          ),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(text: 'Name', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(text: 'Issued To', constraints: constraints),
          // onSort: controller.onSort,
        ),

        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(text: 'Branch', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(text: 'Note', constraints: constraints),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,
          numeric: true,
          label: AutoSizedText(text: 'Total', constraints: constraints),
          // onSort: controller.onSort,
        ),
      ],
      source: CardDataSource(
        cards: isJobsLoading ? [] : data,
        context: context,
        constraints: constraints,
        controller: controller,
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  IssuingModel docData,
  BuildContext context,
  BoxConstraints constraints,
  String docId,
  IssueItemsController controller,
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
      DataCell(
        editReceivingButton(
          controller: controller,
          id: docId,
          docData: docData,
          context: context,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.issuingNumber ?? '',
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
        textForDataRowInTable(
          text: docData.issueTypeName ?? '-',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.detailsString ?? '-',
          formatDouble: false,
          maxWidth: null,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.receivedByName ?? '-',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.branchName ?? '-',
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.note ?? '-',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.total.toString(),
          formatDouble: true,
          isBold: true,
          color: Colors.green,
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<IssuingModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final IssueItemsController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final trade = cards[index];
    final cardId = trade.id ?? '';

    return dataRowForTheTable(
      trade,
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

ElevatedButton newIssueButton(
  BuildContext context,
  BoxConstraints constraints,
  IssueItemsController controller,
) {
  return ElevatedButton(
    onPressed: () async {
      controller.clearValues();
      issueDialog(
        controller: controller,
        onTapForPost: () async {
          controller.updateToPostedStatus();
        },
        onTapForSave: () async {
          await controller.addNewIssuingDoc();
        },
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        controller.focusNode1.requestFocus();
      });
    },
    style: newButtonStyle,
    child: const Text('New Doc.'),
  );
}

IconButton editReceivingButton({
  required IssueItemsController controller,
  required String id,
  required IssuingModel docData,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () async {
      controller.loadValues(docData);
      issueDialog(
        id: id,
        controller: controller,
        onTapForPost: () {
          controller.updateToPostedStatus();
        },
        onTapForSave: () async {
          await controller.addNewIssuingDoc();
        },
        onTapForDelete: () {
          if (controller.status.value == 'New') {
            alertDialog(
              context: context,
              content: "This will be deleted permanently",
              onPressed: () {
                controller.deleteIssuing(id);
              },
            );
          } else {
            alertMessage(
              context: Get.context!,
              content: 'Only New Issuing Allowed',
            );
          }
        },
        onTapForCancel: () {
          controller.updateToCanelledStatus();
        },
      );
    },
    icon: editIcon,
  );
}
