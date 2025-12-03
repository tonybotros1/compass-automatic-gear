import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/converters_controller.dart';
import '../../../../Models/converters/converter_model.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            myTextFormFieldWithBorder(
                              width: 150,
                              labelText: 'Converter NO.',
                              controller: controller.converterNumberFilter,
                            ),
                            myTextFormFieldWithBorder(
                              width: 150,
                              labelText: 'Name',
                              controller: controller.converterNameFilter,
                            ),
                            myTextFormFieldWithBorder(
                              width: 300,
                              labelText: 'Description',
                              controller: controller.converterDescriptionFilter,
                            ),
                            CustomDropdown(
                              width: 150,
                              textcontroller:
                                  controller.statusFilter.value.text,
                              showedSelectedName: 'name',
                              hintText: 'Status',
                              items: allStatus,
                              onChanged: (key, value) async {
                                controller.statusFilter.text = value['name'];
                              },
                              onDelete: () {
                                controller.statusFilter.clear();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  GetX<ConvertersController>(
                    builder: (controller) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth - 28,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 150,
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
                                    width: 150,
                                    controller: controller.toDate,
                                    labelText: 'To Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.toDate.text,
                                        controller.toDate,
                                      );
                                    },
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
                                            controller.searchEngine({
                                              "today": true,
                                            });
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
                                            controller.searchEngine({
                                              "this_month": true,
                                            });
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
                                            controller.searchEngine({
                                              "this_year": true,
                                            });
                                          }
                                        : null,
                                    child: const Text('This Year'),
                                  ),
                                  ElevatedButton(
                                    style: saveButtonStyle,
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
                                  // const Spacer(),
                                ],
                              ),
                              newConverterButton(
                                context,
                                constraints,
                                controller,
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
                        return Row(
                          spacing: 10,
                          children: [
                            customBox(
                              width: Get.width / 5,
                              title: 'NUMBER OF CONVERTERS',
                              value: Text(
                                '${controller.numberOfConverters.value}',
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
                                text: '${controller.allConvertersTotals.value}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  GetX<ConvertersController>(
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
                            data: controller.allConverters,
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
  required ConvertersController controller,
  required RxList<ConverterModel> data,
  required ScrollController scrollController,
  required bool showHistoryButton,
}) {
  bool isReceivingLoading = data.isEmpty;

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
        rowsPerPage: 10,
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
            columnWidth: IntrinsicColumnWidth(flex: 0.2),
            label: SizedBox(),
            // onSort: controller.onSort,
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            label: AutoSizedText(text: 'Number', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            label: AutoSizedText(text: 'Date', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            label: AutoSizedText(text: 'Status', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            label: AutoSizedText(text: 'Name', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 2),
            label: AutoSizedText(text: 'Description', constraints: constraints),
            // onSort: controller.onSort,
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
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
      return isEvenRow ? Colors.grey.shade200 : Colors.white;
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
          width: 100,
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
