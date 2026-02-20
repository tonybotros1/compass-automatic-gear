import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Models/job%20cards/job_card_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../../Models/dynamic_boxes_line_model.dart';
import '../../../../Widgets/dynamic_boxes_line.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/add_new_job_card_or_edit.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/job_card_buttons.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key});

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GetX<JobCardController>(
                      init: JobCardController(),
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
                                      width: 90,
                                      labelText: 'Job No.',
                                      controller:
                                          controller.jobNumberFilter.value,
                                    ),
                                    myTextFormFieldWithBorder(
                                      width: 90,
                                      labelText: 'Invoice No.',
                                      controller:
                                          controller.invoiceNumberFilter.value,
                                    ),
                                    MenuWithValues(
                                      labelText: 'Car Brand',
                                      headerLqabel: 'Brands',
                                      dialogWidth: constraints.maxWidth / 3,
                                      width: 170,
                                      controller:
                                          controller.carBrandIdFilterName.value,
                                      displayKeys: const ['name'],
                                      displaySelectedKeys: const ['name'],
                                      onOpen: () {
                                        return controller.getCarBrands();
                                      },
                                      onDelete: () {
                                        controller.carBrandIdFilter.value = "";
                                        controller.carBrandIdFilterName.value
                                            .clear();
                                        controller.carModelIdFilter.value = '';
                                        controller
                                                .carModelIdFilterName
                                                .value
                                                .text =
                                            '';
                                      },
                                      onSelected: (value) {
                                        controller.carBrandIdFilter.value =
                                            value['_id'];
                                        controller
                                                .carBrandIdFilterName
                                                .value
                                                .text =
                                            value['name'];
                                        controller.carModelIdFilter.value = '';
                                        controller
                                                .carModelIdFilterName
                                                .value
                                                .text =
                                            '';
                                      },
                                    ),
                                    MenuWithValues(
                                      labelText: 'Car Model',
                                      headerLqabel: 'Models',
                                      dialogWidth: constraints.maxWidth / 3,
                                      width: 170,
                                      controller:
                                          controller.carModelIdFilterName.value,
                                      displayKeys: const ['name'],
                                      displaySelectedKeys: const ['name'],
                                      onOpen: () {
                                        return controller.getModelsByCarBrand(
                                          controller.carBrandIdFilter.value,
                                        );
                                      },
                                      onDelete: () {
                                        controller.carModelIdFilter.value = "";
                                        controller.carModelIdFilterName.value
                                            .clear();
                                      },
                                      onSelected: (value) {
                                        controller.carModelIdFilter.value =
                                            value['_id'];
                                        controller
                                                .carModelIdFilterName
                                                .value
                                                .text =
                                            value['name'];
                                      },
                                    ),
                                    myTextFormFieldWithBorder(
                                      width: 90,
                                      labelText: 'Plate NO.',
                                      controller:
                                          controller.plateNumberFilter.value,
                                    ),
                                    myTextFormFieldWithBorder(
                                      width: 170,
                                      labelText: 'VIN',
                                      controller: controller.vinFilter.value,
                                    ),
                                    myTextFormFieldWithBorder(
                                      width: 170,
                                      labelText: 'LPO No.',
                                      controller: controller.lpoFilter.value,
                                    ),
                                    MenuWithValues(
                                      labelText: 'Customer',
                                      headerLqabel: 'Customers',
                                      dialogWidth: constraints.maxWidth / 2,
                                      width: 300,
                                      controller: controller
                                          .customerNameIdFilterName
                                          .value,
                                      displayKeys: const ['entity_name'],
                                      displaySelectedKeys: const [
                                        'entity_name',
                                      ],
                                      onOpen: () {
                                        return controller.getAllCustomers();
                                      },
                                      onDelete: () {
                                        controller
                                            .customerNameIdFilterName
                                            .value
                                            .clear();
                                        controller.customerNameIdFilter.value =
                                            "";
                                      },
                                      onSelected: (value) {
                                        controller
                                                .customerNameIdFilterName
                                                .value
                                                .text =
                                            value['entity_name'];
                                        controller.customerNameIdFilter.value =
                                            value['_id'];
                                      },
                                    ),

                                    MenuWithValues(
                                      labelText: 'Branch',
                                      headerLqabel: 'Branches',
                                      dialogWidth: constraints.maxWidth / 3,
                                      width: 250,
                                      controller:
                                          controller.branchFilterName.value,
                                      displayKeys: const ['name'],
                                      displaySelectedKeys: const ['name'],
                                      onOpen: () {
                                        return controller.getBranches();
                                      },
                                      onDelete: () {
                                        controller.branchFilterName.value
                                            .clear();
                                        controller.branchNameIdFilter.value =
                                            "";
                                      },
                                      onSelected: (value) {
                                        controller.branchFilterName.value.text =
                                            value['name'];
                                        controller.branchNameIdFilter.value =
                                            value['_id'];
                                      },
                                    ),
                                  ],
                                ),

                                Row(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                      onTapOutside: (_) {
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
                                      onTapOutside: (_) {
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
                    GetX<JobCardController>(
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
                                    newJobCardButton(
                                      context,
                                      constraints,
                                      controller,
                                      false,
                                    ),
                                    newJobCardButton(
                                      context,
                                      constraints,
                                      controller,
                                      true,
                                    ),
                                  ],
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInToLinear,
                                      onValueChanged: (v) {
                                        controller.onChooseForDatePicker(v);
                                      },
                                    ),
                                    separator(color: Colors.black),
                                    CustomSlidingSegmentedControl<int>(
                                      height: 30,
                                      initialValue: controller
                                          .initStatusPickersValue
                                          .value,
                                      children: const {
                                        1: Text('ALL'),
                                        2: Text('NEW'),
                                        3: Text('POSTED'),
                                        4: Text('CANCELLED'),
                                        5: Text('APPROVED'),
                                        6: Text('READY'),
                                        7: Text('DRAFT'),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInToLinear,
                                      onValueChanged: (v) {
                                        controller.onChooseForStatusPicker(v);
                                      },
                                    ),
                                    separator(color: Colors.black),
                                    CustomSlidingSegmentedControl<int>(
                                      height: 30,
                                      initialValue:
                                          controller.initTypePickersValue.value,
                                      children: const {
                                        1: Text('ALL'),
                                        2: Text('JOBS'),
                                        3: Text('SALES'),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInToLinear,
                                      onValueChanged: (v) {
                                        controller.onChooseForTypePicker(v);
                                      },
                                    ),
                                    separator(color: Colors.black),
                                    CustomSlidingSegmentedControl<int>(
                                      height: 30,
                                      initialValue: controller
                                          .initLabelPickersValue
                                          .value,
                                      children: const {
                                        1: Text('ALL'),
                                        2: Text('RETURNED'),
                                        3: Text('NOT RETUNRED'),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInToLinear,
                                      onValueChanged: (v) {
                                        controller.onChooseForLabelPicker(v);
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    ElevatedButton(
                                      style: findButtonStyle,
                                      onPressed:
                                          controller.isScreenLoding.isFalse
                                          ? () async {
                                              controller.filterSearch();
                                            }
                                          : null,
                                      child: controller.isScreenLoding.isFalse
                                          ? Text(
                                              'Find',
                                              style:
                                                  fontStyleForElevatedButtons,
                                            )
                                          : loadingProcess,
                                    ),
                                    ElevatedButton(
                                      style: clearVariablesButtonStyle,
                                      onPressed: () {
                                        controller.clearAllFilters();
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GetX<JobCardController>(
                        builder: (controller) {
                          return SizedBox(
                            height: 100,

                            // padding: const EdgeInsets.all(4),
                            child: dynamicBoxesLine(
                              dynamicConfigs: [
                                DynamicBoxesLineModel(
                                  isFormated: false,
                                  width: 300,
                                  label: 'NUMBER OF JOBS',
                                  value: '${controller.numberOfJobs.value}',
                                  valueColor: mainColor,
                                  icon: counterIcon,
                                  iconColor: mainColorWithAlpha,
                                ),
                                DynamicBoxesLineModel(
                                  icon: moneyIcon,
                                  iconColor: Colors.green.shade100,
                                  width: 300,
                                  label: 'TOTAL AMOUNT',
                                  value: '${controller.allJobsTotals.value}',
                                  valueColor: Colors.green,
                                ),
                                DynamicBoxesLineModel(
                                  icon: moneyIcon,
                                  iconColor: Colors.blue.shade100,
                                  width: 300,
                                  label: 'VAT AMOUNT',
                                  value: '${controller.allJobsVATS.value}',
                                  valueColor: Colors.blue,
                                ),
                                DynamicBoxesLineModel(
                                  icon: moneyIcon,
                                  iconColor: Colors.blueGrey.shade100,
                                  width: 300,
                                  label: 'NET AMOUNT',
                                  value: '${controller.allJobsNET.value}',
                                  valueColor: Colors.blueGrey,
                                ),
                                DynamicBoxesLineModel(
                                  icon: moneyIcon,
                                  iconColor: Colors.orange.shade100,
                                  width: 300,
                                  label: 'PAID AMOUNT',
                                  value: '${controller.allJobsVATS.value}',
                                  valueColor: Colors.orange,
                                ),
                                DynamicBoxesLineModel(
                                  icon: moneyIcon,
                                  iconColor: Colors.red.shade100,
                                  width: 300,
                                  label: 'OUTSTANDING AMOUNT',
                                  value:
                                      '${controller.allJobsOutstanding.value}',
                                  valueColor: Colors.red,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    GetX<JobCardController>(
                      builder: (controller) {
                        return Container(
                          // padding: const EdgeInsets.all(2),
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
                            height: constraints.maxHeight * 3 / 4,
                            child: tableOfScreensForMainJobCards(
                              showHistoryButton: true,
                              scrollController:
                                  controller.scrollControllerFotTable1,
                              constraints: constraints,
                              context: context,
                              controller: controller,
                              data: controller.allJobCards,
                            ),
                          ),
                        );
                      },
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Text('💳 History', style: fontStyleForAppBar),
                    // Expanded(
                    //     child: Container(
                    //   width: constraints.maxWidth,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.grey),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: GetX<JobCardController>(builder: (controller) {
                    //     return controller.historyJobCards.isNotEmpty
                    //         ? SingleChildScrollView(
                    //             scrollDirection: Axis.vertical,
                    //             child: tableOfScreens(
                    //                 showHistoryButton: false,
                    //                 scrollController:
                    //                     controller.scrollControllerFotTable2,
                    //                 constraints: constraints,
                    //                 context: context,
                    //                 controller: controller,
                    //                 data: controller.historyJobCards))
                    //         : const Center(
                    //             child: Text(
                    //               'History',
                    //               style: TextStyle(color: Colors.grey),
                    //             ),
                    //           );
                    //   }),
                    // ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreensForMainJobCards({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  required List<JobCardModel> data,
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
      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.grey.shade200, width: 0.5),
      ),
      smRatio: 0.67,
      lmRatio: 3,
      autoRowsToHeight: true,
      showCheckboxColumn: false,
      headingRowHeight: 60,
      columnSpacing: 5,
      showFirstLastButtons: true,
      horizontalMargin: 5,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      columns: [
        const DataColumn2(
          size: ColumnSize.S,
          label: SizedBox(),
          // onSort: controller.onSort,
        ),
        const DataColumn2(
          size: ColumnSize.S,
          label: SizedBox(),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.S,
          label: columnForTable(constraints, '', 'Type'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, '', 'Number'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, '', 'Date'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, '', 'Status'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, 'Invoice', 'Number'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, '', 'Date'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, 'LPO', 'Number'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, 'Car', 'Brand'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, '', 'Model'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, 'Plate', 'Number'),
          // onSort: controller.onSort,
        ),
        // DataColumn(label: columnForTable(constraints, '', 'Code')
        //     // onSort: controller.onSort,
        //     ),
        // DataColumn(label: columnForTable(constraints, '', 'City')
        //     // onSort: controller.onSort,
        //     ),
        DataColumn2(
          // size: ColumnSize.L
          size: ColumnSize.L,

          label: columnForTable(constraints, '', 'Customer Name'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          label: columnForTable(constraints, '', 'Branch'),
          // onSort: controller.onSort,
        ),
        // DataColumn2(
        //   size: ColumnSize.L,

        //   label: columnForTable(constraints, '', 'VIN'),
        //   // onSort: controller.onSort,
        // ),
        DataColumn2(
          size: ColumnSize.M,

          numeric: true,
          label: columnForTable(constraints, '', 'Totals'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          numeric: true,
          label: columnForTable(constraints, '', 'VAT'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          numeric: true,
          label: columnForTable(constraints, '', 'NET'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          numeric: true,
          label: columnForTable(constraints, '', 'Paid'),
          // onSort: controller.onSort,
        ),
        DataColumn2(
          size: ColumnSize.M,

          numeric: true,
          label: columnForTable(constraints, 'Out-', 'standing'),
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

Column columnForTable(
  BoxConstraints constraints,
  String title1,
  String title2,
) {
  return Column(
    spacing: 5,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AutoSizedText(text: title1, constraints: constraints),
      AutoSizedText(text: title2, constraints: constraints),
    ],
  );
}

DataRow dataRowForTheTable(
  JobCardModel jobData,
  BuildContext context,
  BoxConstraints constraints,
  String jobId,
  JobCardController controller,
  int index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow2(
    // onSelectChanged: (_) {},
    // selected: true,
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return !isEvenRow ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(
        editSection(
          context,
          jobData,
          constraints,
          jobId,
          jobData.type == 'SALES' ? false : true,
        ),
      ), // need to be changed
      DataCell(
        jobData.label == 'Draft'
            ? statusBox('D')
            : jobData.label == 'Returned'
            ? statusBox('R', hieght: 35, width: 35)
            : const SizedBox(),
      ),
      DataCell(
        jobData.type == 'SALES'
            ? statusBox('SI', width: 35)
            : statusBox('JC', width: 35),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.jobNumber ?? "-",
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.jobNumber != ''
              ? textToDate(jobData.jobDate ?? "")
              : '-',
        ),
      ),
      DataCell(
        statusBox(
          jobData.jobStatus1 == 'Posted'
              ? ((isBeforeToday(jobData.jobWarrantyEndDate.toString()))
                    ? 'Closed'
                    : 'Warranty')
              : (jobData.jobStatus2 ?? ''),
          hieght: 35,
          // width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: jobData.invoiceNumber ?? '-',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.invoiceNumber != '-'
              ? textToDate(jobData.invoiceDate)
              : '',
        ),
      ),
      DataCell(SelectableText(jobData.lpoNumber ?? '-', maxLines: 1)),
      DataCell(textForDataRowInTable(text: jobData.carBrandName ?? '-')),
      DataCell(textForDataRowInTable(text: jobData.carModelName ?? '-')),
      DataCell(
        SelectableText(
          "${jobData.plateNumber ?? ''} - ${jobData.plateCode ?? ''}",
          maxLines: 1,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          text: jobData.customerName ?? '-',
        ),
      ),
      DataCell(
        textForDataRowInTable(maxWidth: null, text: jobData.branchName ?? '-'),
      ),
      // DataCell(
      //   textForDataRowInTable(
      //     text: jobData.vehicleIdentificationNumber ?? '-',
      //     maxWidth: null,
      //     isBold: true,
      //     formatDouble: false,
      //   ),
      // ),
      DataCell(
        textForDataRowInTable(
          color: Colors.green,
          isBold: true,
          text: (jobData.totals.toString()),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.blue,
          isBold: true,
          text: (jobData.vat.toString()),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.blueGrey,
          isBold: true,
          text: (jobData.net.toString()),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.orange,
          isBold: true,
          text: (jobData.paid.toString()),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.red,
          isBold: true,
          text: (jobData.finlOutstanding.toString()),
        ),
      ),
    ],
  );
}

Widget editSection(
  BuildContext context,
  JobCardModel jobData,
  BoxConstraints constraints,
  String jobId,
  bool isJob,
) {
  return GetX<JobCardController>(
    builder: (controller) {
      final isLoading = controller.buttonLoadingStates[jobId] ?? false;
      return IconButton(
        tooltip: 'Edit',
        onPressed: isLoading
            ? null
            : () async {
                controller.setButtonLoading(jobId, true);

                try {
                  controller.currentCountryVAT.value =
                      (controller.companyDetails['vat_percentage'] != null
                          ? controller.companyDetails['vat_percentage'] * 100
                          : null) ??
                      controller.companyDetails['country_vat'] ??
                      0;

                  // controller.currentCountryVAT.value =
                  //     controller.companyDetails.containsKey('country_vat')
                  //     ? controller.companyDetails['country_vat'].toString()
                  //     : "";
                  await controller.loadValues(jobData);
                  controller.getJobItemsSummaryTable(jobId);
                  controller.getTimeSheetsSummaryForJobCard(jobId);
                  editJobCardDialog(controller, jobData, jobId, isJob);
                } finally {
                  controller.setButtonLoading(jobId, false);
                }
              },
        icon: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.edit_note_rounded, color: Colors.blue),
      );
    },
  );
}

ElevatedButton historySection(
  JobCardController controller,
  Map<String, dynamic> jobData,
) {
  return ElevatedButton(
    style: historyButtonStyle,
    onPressed: () async {
      controller.selectForHistory(jobData['vehicle_identification_number']);
      // controller.currentCountryVAT.value = controller.getdataName(
      //     controller.companyDetails['contact_details']['country'],
      //     controller.allCountries,
      //     title: 'vat');
      // controller.loadValues(jobData);
      // editJobCardDialog(controller, jobData, jobId);
    },
    child: const Text('History'),
  );
}

Future<dynamic> editJobCardDialog(
  JobCardController controller,
  JobCardModel jobData,
  String jobId,
  bool isJob, {
  String screenName = '',
  headerColor = '',
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, meta: true): SaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveIntent: CallbackAction(
              onInvoke: (intent) {
                controller.addNewJobCard();
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        color: headerColor == '' ? mainColor : headerColor,
                      ),
                      padding: const EdgeInsets.all(16),
                      width: constraints.maxWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth - 40,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    isJob == true
                                        ? screenName == ''
                                              ? controller.getScreenName()
                                              : screenName
                                        : "Sales Invoices",
                                    style: fontStyleForScreenNameUsedInButtons,
                                  ),
                                  GetX<JobCardController>(
                                    builder: (ctl) {
                                      if (ctl.jobStatus2.value.isNotEmpty &&
                                          ctl.jobStatus1.value.isNotEmpty) {
                                        return statusBox(
                                          ctl.jobStatus1.value == 'Posted'
                                              ? (isBeforeToday(
                                                      ctl
                                                          .jobWarrentyEndDate
                                                          .value
                                                          .text,
                                                    )
                                                    ? 'Closed'
                                                    : 'Warranty')
                                              : ctl.jobStatus2.value,
                                          hieght: 35,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  separator(),
                                  saveJobButton(
                                    () => controller.addNewJobCard(),
                                  ),
                                  separator(),
                                  printButton(context),
                                  point(),
                                  creatQuotationButton(controller, jobId),
                                  point(),
                                  creatReceiptButton(controller, jobId),
                                  point(),
                                  inspectionFormButton(
                                    controller,
                                    jobId,
                                    context,
                                  ),
                                  point(),
                                  internalNotesButton(
                                    controller,
                                    constraints,
                                    jobId,
                                  ),
                                  separator(),

                                  copyJobButton(jobId, context),
                                  point(),
                                  deleteJobButton(controller, context, jobId),
                                  separator(),
                                  changeStatusToPostedButton(controller, jobId),
                                  point(),
                                  changeStatusToCancelledButton(jobId),
                                  point(),
                                  changeStatusToNewButton(jobId),
                                  point(),
                                  changeStatusToApproveButton(jobId),
                                  point(),
                                  changeStatusToReadyButton(jobId),
                                  separator(),
                                  closeIcon(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: addNewJobCardOrEdit(
                          jobId: jobId,
                          controller: controller,
                          constraints: constraints,
                          context: context,
                          isJob: isJob,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

ElevatedButton newJobCardButton(
  BuildContext context,
  BoxConstraints constraints,
  JobCardController controller,
  bool isJob,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues(isJob);

      Get.dialog(
        barrierDismissible: false,
        Dialog(
          backgroundColor: const Color(0xffF6F9FC),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: const EdgeInsets.all(8),
          child: Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              // Ctrl + S on Windows/Linux
              SingleActivator(LogicalKeyboardKey.keyS, control: true):
                  SaveIntent(),

              // Command + S on macOS
              SingleActivator(LogicalKeyboardKey.keyS, meta: true):
                  SaveIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                SaveIntent: CallbackAction(
                  onInvoke: (intent) {
                    controller.addNewJobCard();
                    return null;
                  },
                ),
              },
              child: Focus(
                autofocus: true,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        GetX<JobCardController>(
                          builder: (controller) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                color: mainColor,
                              ),
                              padding: const EdgeInsets.all(16),
                              width: constraints.maxWidth,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth - 40,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Text(
                                            isJob == true
                                                ? controller.getScreenName()
                                                : "🏷️ Sales Invoices",
                                            style:
                                                fontStyleForScreenNameUsedInButtons,
                                          ),
                                          controller.jobStatus2.value.isNotEmpty
                                              ? statusBox(
                                                  controller.jobStatus1.value ==
                                                          'Posted'
                                                      ? ((isBeforeToday(
                                                              controller
                                                                  .jobWarrentyEndDate
                                                                  .value
                                                                  .text,
                                                            ))
                                                            ? 'Closed'
                                                            : 'Warranty')
                                                      : (controller
                                                            .jobStatus2
                                                            .value),
                                                  hieght: 35,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                      ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          separator(),
                                          saveJobButton(
                                            () => controller.addNewJobCard(),
                                          ),
                                          separator(),
                                          creatQuotationButton(
                                            controller,
                                            controller.curreentJobCardId.value,
                                          ),
                                          point(),

                                          creatReceiptButton(
                                            controller,
                                            controller.curreentJobCardId.value,
                                          ),

                                          point(),
                                          internalNotesButton(
                                            controller,
                                            constraints,
                                            controller.curreentJobCardId.value,
                                          ),

                                          separator(),
                                          changeStatusToPostedButton(
                                            controller,
                                            controller.curreentJobCardId.value,
                                          ),
                                          point(),
                                          changeStatusToCancelledButton(
                                            controller.curreentJobCardId.value,
                                          ),
                                          point(),
                                          changeStatusToNewButton(
                                            controller.curreentJobCardId.value,
                                          ),
                                          point(),
                                          changeStatusToApproveButton(
                                            controller.curreentJobCardId.value,
                                          ),
                                          point(),
                                          changeStatusToReadyButton(
                                            controller.curreentJobCardId.value,
                                          ),
                                          separator(),
                                          closeIcon(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: addNewJobCardOrEdit(
                              jobId: controller.curreentJobCardId.value,
                              controller: controller,
                              constraints: constraints,
                              context: context,
                              isJob: isJob,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        controller.focusNodeForCardDetails1.requestFocus();
      });
    },
    style: isJob == true ? newButtonStyle : newSalesInvoicesButtonStyle,
    child: Text(isJob == true ? 'New Job' : 'New Sale'),
  );
}

class CardDataSource extends DataTableSource {
  final List<JobCardModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final JobCardController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final jobCard = cards[index];
    final cardId = jobCard.id ?? '';

    return dataRowForTheTable(
      jobCard,
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
