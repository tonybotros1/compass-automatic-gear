import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/issue_items_controller.dart';
import '../../../../Models/issuing/issung_model.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/issue_items_widgets/issue_dialog.dart';
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
                                  CustomDropdown(
                                    width: 300,
                                    textcontroller:
                                        controller.receivedByFilter.value.text,
                                    showedSelectedName: 'name',
                                    hintText: 'Issue To',
                                    onChanged: (key, value) async {
                                      controller.receivedByFilter.value.text =
                                          value['name'];
                                      controller.receivedByIdFilter.value = key;
                                    },
                                    onDelete: () {
                                      controller.receivedByFilter.value.clear();
                                      controller.receivedByIdFilter.value = '';
                                    },
                                    onOpen: () {
                                      return controller.getISSUERECEIVEPEOPLE();
                                    },
                                  ),
                                  CustomDropdown(
                                    width: 120,
                                    textcontroller:
                                        controller.statusFilter.value.text,
                                    showedSelectedName: 'name',
                                    hintText: 'Status',
                                    items: allStatus,
                                    onChanged: (key, value) async {
                                      controller.statusFilter.value.text =
                                          value['name'];
                                    },
                                    onDelete: () {
                                      controller.statusFilter.value.clear();
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
                              Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  newIssueButton(
                                    context,
                                    constraints,
                                    controller,
                                  ),
                                  CustomSlidingSegmentedControl<int>(
                                    height: 30,
                                    initialValue: 1,
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
                        return Row(
                          spacing: 10,
                          children: [
                            customBox(
                              width: Get.width / 5,
                              title: 'NUMBER OF Docs',
                              value: Text(
                                '${controller.numberOfIssuesgDocs.value}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            customBox(
                              width: Get.width / 5,
                              title: 'TOTALS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.green,
                                isBold: true,
                                text: '${controller.allIssuesTotals.value}',
                              ),
                            ),
                          ],
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
    child: Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: PaginatedDataTable(
        controller: scrollController,
        rowsPerPage: controller.numberOfIssuesgDocs.value <= 12
            ? 12
            : controller.numberOfIssuesgDocs.value >= 30
            ? 30
            : controller.numberOfIssuesgDocs.value,
        showCheckboxColumn: false,

        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        columnSpacing: 15,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        columns: [
          const DataColumn(
            label: SizedBox(),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Number', constraints: constraints),

            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Date', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Status', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              text: 'Job / Converter',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Name', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Received By', constraints: constraints),
            // onSort: controller.onSort,
          ),

          DataColumn(
            label: AutoSizedText(text: 'Branch', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Note', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
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
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.issueTypeName ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.detailsString ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.receivedByName ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.branchName ?? '',
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.note ?? '',
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
