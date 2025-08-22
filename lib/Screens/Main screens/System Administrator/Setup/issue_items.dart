import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/issue_items_controller.dart';
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
                      bool isJobConverterLoading =
                          controller.alljobConverters.isEmpty;
                      bool isReceivedByLoading =
                          controller.allReceivedBy.isEmpty;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: 150,
                              child: myTextFormFieldWithBorder(
                                labelText: 'Number',
                                controller: controller.issueNumberFilter.value,
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: CustomDropdown(
                                textcontroller:
                                    controller.jobConverterFilter.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Job / Converter',
                                onChanged: (key, value) async {
                                  controller.jobConverterFilter.value.text =
                                      value['name'];
                                  controller.jobConverterIdFilter.value = key;
                                },
                                items: isJobConverterLoading
                                    ? {}
                                    : controller.alljobConverters,
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: CustomDropdown(
                                textcontroller:
                                    controller.receivedByFilter.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Received By',
                                onChanged: (key, value) async {
                                  controller.receivedByFilter.value.text =
                                      value['name'];
                                  controller.receivedByIdFilter.value = key;
                                },
                                items: isReceivedByLoading
                                    ? {}
                                    : controller.allReceivedBy,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: CustomDropdown(
                                textcontroller:
                                    controller.statusFilter.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Status',
                                items: allStatus,
                                onChanged: (key, value) async {
                                  controller.statusFilter.value.text =
                                      value['name'];
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  GetBuilder<IssueItemsController>(
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
                                  SizedBox(
                                    width: 120,
                                    child: myTextFormFieldWithBorder(
                                      controller: controller.fromDate.value,
                                      labelText: 'From Date',
                                      onFieldSubmitted: (_) async {
                                        await normalizeDate(
                                          controller.fromDate.value.text,
                                          controller.fromDate.value,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,

                                    child: myTextFormFieldWithBorder(
                                      controller: controller.toDate.value,
                                      labelText: 'To Date',
                                      onFieldSubmitted: (_) async {
                                        await normalizeDate(
                                          controller.toDate.value.text,
                                          controller.toDate.value,
                                        );
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: allButtonStyle,
                                    onPressed: () {
                                      // controller.clearAllFilters();
                                      controller.isAllSelected.value = true;
                                      controller.isTodaySelected.value = false;
                                      controller.isThisMonthSelected.value =
                                          false;
                                      controller.isThisYearSelected.value =
                                          false;
                                      // controller.searchEngine();
                                    },
                                    child: const Text('All'),
                                  ),
                                  ElevatedButton(
                                    style: todayButtonStyle,
                                    onPressed:
                                        controller.isTodaySelected.isFalse
                                        ? () {
                                            controller.isAllSelected.value =
                                                false;
                                            controller.isTodaySelected.value =
                                                true;
                                            controller
                                                    .isThisMonthSelected
                                                    .value =
                                                false;
                                            controller
                                                    .isThisYearSelected
                                                    .value =
                                                false;
                                            controller.isYearSelected.value =
                                                false;
                                            controller.isMonthSelected.value =
                                                false;
                                            controller.isDaySelected.value =
                                                true;
                                            // controller.searchEngine();
                                          }
                                        : null,
                                    child: const Text('Today'),
                                  ),
                                  ElevatedButton(
                                    style: thisMonthButtonStyle,
                                    onPressed:
                                        controller.isThisMonthSelected.isFalse
                                        ? () {
                                            controller.isAllSelected.value =
                                                false;
                                            controller.isTodaySelected.value =
                                                false;
                                            controller
                                                    .isThisMonthSelected
                                                    .value =
                                                true;
                                            controller
                                                    .isThisYearSelected
                                                    .value =
                                                false;
                                            controller.isYearSelected.value =
                                                false;
                                            controller.isMonthSelected.value =
                                                true;
                                            controller.isDaySelected.value =
                                                false;
                                            // controller.searchEngine();
                                          }
                                        : null,
                                    child: const Text('This Month'),
                                  ),
                                  ElevatedButton(
                                    style: thisYearButtonStyle,
                                    onPressed:
                                        controller.isThisYearSelected.isFalse
                                        ? () {
                                            controller.isTodaySelected.value =
                                                false;
                                            controller
                                                    .isThisMonthSelected
                                                    .value =
                                                false;
                                            controller
                                                    .isThisYearSelected
                                                    .value =
                                                true;
                                            controller.isYearSelected.value =
                                                true;
                                            controller.isMonthSelected.value =
                                                false;
                                            controller.isDaySelected.value =
                                                false;
                                            // controller.searchEngine();
                                          }
                                        : null,
                                    child: const Text('This Year'),
                                  ),
                                  ElevatedButton(
                                    style: saveButtonStyle,
                                    onPressed:
                                        controller.isThisYearSelected.isFalse
                                        ? () async {
                                            // await controller.removeFilters();
                                            // controller.searchEngine();
                                          }
                                        : null,
                                    child: Text(
                                      'Find',
                                      style: fontStyleForElevatedButtons,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: clearVariablesButtonStyle,
                                    onPressed:
                                        controller.isThisYearSelected.isFalse
                                        ? () {
                                            // controller.clearAllFilters();
                                          }
                                        : null,
                                    child: Text(
                                      'Clear Filters',
                                      style: fontStyleForElevatedButtons,
                                    ),
                                  ),
                                ],
                              ),
                              // Expanded(flex: 2, child: SizedBox()),
                              newIssueButton(context, constraints, controller),
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
                              title: 'TOTALS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.green,
                                isBold: true,
                                text: '${controller.allIssuesTotals.value}',
                              ),
                            ),
                            customBox(
                              title: 'VATS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.red,
                                isBold: true,
                                text: '${controller.allIssuesVATS.value}',
                              ),
                            ),
                            customBox(
                              title: 'NETS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.blueGrey,
                                isBold: true,
                                text: '${controller.allIssuesNET.value}',
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            controller.isScreenLoding.isTrue &&
                                    controller.allIssuesDocs.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: loadingProcess,
                                  )
                                : SizedBox(
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
                          ],
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
  required RxList<DocumentSnapshot> data,
  required ScrollController scrollController,
  required bool showHistoryButton,
}) {
  final dataSource = CardDataSource(
    cards: data,
    context: context,
    constraints: constraints,
    controller: controller,
  );
  return DataTableTheme(
    data: DataTableThemeData(
      headingTextStyle: fontStyleForTableHeader,
      dataTextStyle: regTextStyle,
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
        rowsPerPage: 5,
        showCheckboxColumn: false,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        headingRowHeight: 70,
        columnSpacing: 15,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
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
            label: AutoSizedText(
              text: 'Job / Converter',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Status', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Received By', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Date', constraints: constraints),
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
          DataColumn(
            numeric: true,
            label: AutoSizedText(text: 'VAT', constraints: constraints),
            // onSort: controller.onSort,
          ),

          DataColumn(
            numeric: true,
            label: AutoSizedText(text: 'NET', constraints: constraints),
            // onSort: controller.onSort,
          ),
        ],
        source: dataSource,
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  Map<String, dynamic> docData,
  context,
  constraints,
  docId,
  IssueItemsController controller,
  int index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return isEvenRow ? Colors.grey.shade200 : Colors.white;
    }),
    cells: [
      DataCell(
        Row(
          children: [
            editReceivingButton(
              controller: controller,
              id: docId,
              docData: docData,
              context: context,
            ),
          ],
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: '${docData['number']}',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(text: '${docData['']}', formatDouble: false),
      ),
      DataCell(
        statusBox(
          docData['status'],
          hieght: 35,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),
      DataCell(textForDataRowInTable(text: '', formatDouble: false)),
      DataCell(
        textForDataRowInTable(
          text: docData['date'] != null && docData['date'] != ''
              ? textToDate(docData['date'])
              : 'N/A',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '', //getdataName(docData['branch'], controller.allBranches),
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(text: '${docData['note']}', formatDouble: false),
      ),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<DocumentSnapshot> cards;
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
    final cardData = trade.data() as Map<String, dynamic>;
    final cardId = trade.id;

    return dataRowForTheTable(
      cardData,
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
      // controller.clearValues();
      issueDialog(
        controller: controller,
        onTapForPost: () async {
          // await controller.editPostForReceiving(
          //   controller.curreentReceivingId.value,
          // );
        },
        onTapForSave: () async {
          // await controller.addNewReceivingDoc();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Issue Doc.'),
  );
}

IconButton editReceivingButton({
  required IssueItemsController controller,
  required String id,
  required Map<String, dynamic> docData,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () async {
      // controller.loadValues(docData, id);
      // receivigDialog(
      //   id: id,
      //   controller: controller,
      //   onTapForPost: () async {
      //     await controller.editPostForReceiving(id);
      //   },
      //   onTapForSave: () async {
      //     await controller.editReceivingDoc(id);
      //   },
      //   onTapForDelete: () {
      //     controller.deleteReceivingDoc(id, context);
      //   },
      //   onTapForCancel: () {
      //     controller.editCancelForReceiving(id);
      //   },
      // );
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}
