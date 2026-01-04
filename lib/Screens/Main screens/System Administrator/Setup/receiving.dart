import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/receiving_controller.dart';
import '../../../../Models/receiving/receiving_model.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/receiving_widgets/receiving_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class Receiving extends StatelessWidget {
  const Receiving({super.key});

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
                  GetX<ReceivingController>(
                    init: ReceivingController(),
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
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 10,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: myTextFormFieldWithBorder(
                                      labelText: 'Number',
                                      controller: controller
                                          .receivingNumberFilter
                                          .value,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,

                                    child: myTextFormFieldWithBorder(
                                      labelText: 'Reverence NO.',
                                      controller: controller
                                          .referenceNumberFilter
                                          .value,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 300,

                                    child: CustomDropdown(
                                      textcontroller: controller
                                          .vendorNameIdFilterName
                                          .value
                                          .text,
                                      showedSelectedName: 'entity_name',
                                      hintText: 'Vendor Name',
                                      onChanged: (key, value) async {
                                        controller
                                                .vendorNameIdFilterName
                                                .value
                                                .text =
                                            value['entity_name'];
                                        controller.vendorNameIdFilter.value =
                                            key;
                                      },
                                      onDelete: () {
                                        controller.vendorNameIdFilterName.value
                                            .clear();
                                        controller.vendorNameIdFilter.value =
                                            '';
                                      },
                                      onOpen: () {
                                        return controller.getAllVendors();
                                      },
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
                                      onDelete: () {
                                        controller.statusFilter.value.clear();
                                      },
                                    ),
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
                  GetX<ReceivingController>(
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
                                  newReceivingButton(
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
                    child: GetX<ReceivingController>(
                      builder: (controller) {
                        return Row(
                          spacing: 10,
                          children: [
                            customBox(
                              title: 'NUMBER OF Docs',
                              value: Text(
                                '${controller.numberOfReceivingDocs.value}',
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
                                text: '${controller.allReceivingTotals.value}',
                              ),
                            ),
                            customBox(
                              title: 'VATS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.red,
                                isBold: true,
                                text: '${controller.allReceivingVATS.value}',
                              ),
                            ),
                            customBox(
                              title: 'NETS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.blueGrey,
                                isBold: true,
                                text: '${controller.allReceivingNET.value}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  GetX<ReceivingController>(
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
                            data: controller.allReceivingDocs,
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
  required ReceivingController controller,
  required RxList<ReceivingModel> data,
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
    child: Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: PaginatedDataTable(
        controller: scrollController,
        rowsPerPage: controller.numberOfReceivingDocs.value <= 12
            ? 12
            : controller.numberOfReceivingDocs.value >= 30
            ? 30
            : controller.numberOfReceivingDocs.value,

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
              text: 'Reference No.',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),

          DataColumn(
            label: AutoSizedText(text: 'Vendor Name', constraints: constraints),
            // onSort: controller.onSort,
          ),

          DataColumn(
            label: AutoSizedText(text: 'Branch', constraints: constraints),
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
        source: CardDataSource(
          cards: isReceivingLoading ? [] : data,
          context: context,
          constraints: constraints,
          controller: controller,
        ),
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  ReceivingModel docData,
  context,
  constraints,
  docId,
  ReceivingController controller,
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
              data: docData,
              context: context,
            ),
          ],
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.receivingNumber ?? '',
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
          text: docData.referenceNumber ?? '',
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: docData.vendorName ?? '',
          maxWidth: null,
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
          text: docData.totals.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.vats.toString(),
          color: Colors.red,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: docData.net.toString(),
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<ReceivingModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final ReceivingController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final rec = cards[index];
    final cardId = rec.id;

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

ElevatedButton newReceivingButton(
  BuildContext context,
  BoxConstraints constraints,
  ReceivingController controller,
) {
  return ElevatedButton(
    onPressed: () async {
      controller.clearValues();
      receivigDialog(
        controller: controller,
        onTapForPost: () async {
          await controller.editPostForReceiving(
            controller.curreentReceivingId.value,
          );
        },
        onTapForSave: () async {
          await controller.addNewReceivingDoc();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Doc.'),
  );
}

IconButton editReceivingButton({
  required ReceivingController controller,
  required String id,
  required ReceivingModel data,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () async {
      controller.loadValues(data);
      receivigDialog(
        id: id,
        controller: controller,
        onTapForPost: () async {
          await controller.editPostForReceiving(id);
        },
        onTapForSave: () async {
          await controller.addNewReceivingDoc();
        },
        onTapForDelete: () {
          if (controller.status.value == 'New') {
            alertDialog(
              context: context,
              content: "This will be deleted permanently",
              onPressed: () {
                controller.deleteReceiving(id);
              },
            );
          } else {
            showSnackBar('Alert', 'Only New Receiving Allowed');
          }
        },
        onTapForCancel: () {
          controller.editCancelForReceiving(id);
        },
      );
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}
