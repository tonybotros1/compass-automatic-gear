import 'package:datahubai/Models/job%20cards/job_card_model.dart';
import 'package:datahubai/Widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/add_new_job_card_or_edit.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/job_card_buttons.dart';
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
              child: ListView(
                children: [
                  GetX<JobCardController>(
                    init: JobCardController(),
                    builder: (controller) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            myTextFormFieldWithBorder(
                              width: 150,
                              labelText: 'Job NO.',
                              controller: controller.jobNumberFilter.value,
                            ),
                            myTextFormFieldWithBorder(
                              width: 150,
                              labelText: 'Invoice NO.',
                              controller: controller.invoiceNumberFilter.value,
                            ),
                            CustomDropdown(
                              width: 200,
                              showedSelectedName: 'name',
                              textcontroller:
                                  controller.carBrandIdFilterName.value.text,
                              hintText: 'Car Brand',
                              onChanged: (key, value) async {
                                controller.getModelsByCarBrand(key);
                                controller.carBrandIdFilter.value = key;
                                controller.carBrandIdFilterName.value.text =
                                    value['name'];
                                controller.carModelIdFilter.value = '';
                                controller.carModelIdFilterName.value.text = '';
                              },
                              onDelete: () {
                                controller.carBrandIdFilter.value = "";
                                controller.carBrandIdFilterName.value.clear();
                                controller.carModelIdFilter.value = '';
                                controller.carModelIdFilterName.value.text = '';
                              },
                              onOpen: () {
                                return controller.getCarBrands();
                              },
                            ),
                            CustomDropdown(
                              width: 200,
                              showedSelectedName: 'name',
                              textcontroller:
                                  controller.carModelIdFilterName.value.text,
                              hintText: 'Car Model',
                              onChanged: (key, value) async {
                                controller.carModelIdFilter.value = key;
                                controller.carModelIdFilterName.value.text =
                                    value['name'];
                              },
                              onDelete: () {
                                controller.carModelIdFilter.value = "";
                                controller.carModelIdFilterName.value.clear();
                              },
                              onOpen: () {
                                return controller.getModelsByCarBrand(
                                  controller.carBrandIdFilter.value,
                                );
                              },
                            ),
                            myTextFormFieldWithBorder(
                              width: 150,
                              labelText: 'Plate NO.',
                              controller: controller.plateNumberFilter.value,
                            ),
                            myTextFormFieldWithBorder(
                              width: 200,
                              labelText: 'VIN',
                              controller: controller.vinFilter.value,
                            ),
                            CustomDropdown(
                              width: 300,
                              textcontroller: controller
                                  .customerNameIdFilterName
                                  .value
                                  .text,
                              showedSelectedName: 'entity_name',
                              hintText: 'Customer Name',
                              onChanged: (key, value) async {
                                controller.customerNameIdFilterName.value.text =
                                    value['entity_name'];
                                controller.customerNameIdFilter.value = key;
                              },
                              onDelete: () {
                                controller.customerNameIdFilterName.value
                                    .clear();
                                controller.customerNameIdFilter.value = "";
                              },
                              onOpen: () {
                                return controller.getAllCustomers();
                              },
                            ),
                            CustomDropdown(
                              width: 150,
                              textcontroller:
                                  controller.statusFilter.value.text,
                              showedSelectedName: 'name',
                              hintText: 'Status',
                              items: controller.allStatus,
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
                      );
                    },
                  ),
                  const SizedBox(height: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 150,
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
                                    width: 150,
                                    controller: controller.toDate.value,
                                    labelText: 'To Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.toDate.value.text,
                                        controller.toDate.value,
                                      );
                                    },
                                  ),
                                  filterButton(
                                    title: 'Today',
                                    onPressed: () {
                                      controller.isAllSelected.value = false;
                                      controller.isTodaySelected.value = true;
                                      controller.isThisMonthSelected.value =
                                          false;
                                      controller.isThisYearSelected.value =
                                          false;
                                      controller.isYearSelected.value = false;
                                      controller.isMonthSelected.value = false;
                                      controller.isDaySelected.value = true;
                                      controller.searchEngine({"today": true});
                                    },
                                    isSelected:
                                        controller.isTodaySelected.value,
                                  ),
                                  filterButton(
                                    title: 'This Month',
                                    onPressed: () {
                                      controller.isAllSelected.value = false;
                                      controller.isTodaySelected.value = false;
                                      controller.isThisMonthSelected.value =
                                          true;
                                      controller.isThisYearSelected.value =
                                          false;
                                      controller.isYearSelected.value = false;
                                      controller.isMonthSelected.value = true;
                                      controller.isDaySelected.value = false;
                                      controller.searchEngine({
                                        "this_month": true,
                                      });
                                    },
                                    isSelected:
                                        controller.isThisMonthSelected.value,
                                  ),
                                  filterButton(
                                    title: 'This Year',
                                    onPressed: () {
                                      controller.isTodaySelected.value = false;
                                      controller.isThisMonthSelected.value =
                                          false;
                                      controller.isThisYearSelected.value =
                                          true;
                                      controller.isYearSelected.value = true;
                                      controller.isMonthSelected.value = false;
                                      controller.isDaySelected.value = false;
                                      controller.searchEngine({
                                        "this_year": true,
                                      });
                                    },
                                    isSelected:
                                        controller.isThisYearSelected.value,
                                  ),
                                  const SizedBox(width: 10),
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
                                      // controller.update();
                                    },
                                    child: Text(
                                      'Clear Filters',
                                      style: fontStyleForElevatedButtons,
                                    ),
                                  ),
                                ],
                              ),
                              newJobCardButton(
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
                    child: GetX<JobCardController>(
                      builder: (controller) {
                        return Row(
                          spacing: 10,
                          children: [
                            customBox(
                              title: 'NUMBER OF JOBS',
                              value: Text(
                                '${controller.numberOfJobs.value}',
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
                                text: '${controller.allJobsTotals.value}',
                              ),
                            ),
                            customBox(
                              title: 'VATS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.red,
                                isBold: true,
                                text: '${controller.allJobsVATS.value}',
                              ),
                            ),
                            customBox(
                              title: 'NETS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.blueGrey,
                                isBold: true,
                                text: '${controller.allJobsNET.value}',
                              ),
                            ),
                            customBox(
                              title: 'PAID',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.orange,
                                isBold: true,
                                text: '${controller.allJobsPaid.value}',
                              ),
                            ),
                            customBox(
                              title: 'OUTSTANDING',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.blue,
                                isBold: true,
                                text: '${controller.allJobsOutstanding.value}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  GetX<JobCardController>(
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
          );
        },
      ),
    );
  }
}

Widget tableOfScreens({
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
        columnSpacing: 5,
        showFirstLastButtons: true,
        horizontalMargin: 5,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          const DataColumn(
            label: SizedBox(),
            // onSort: controller.onSort,
          ),
          const DataColumn(
            label: SizedBox(),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, 'Job', 'Number'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, '', 'Date'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, '', 'Status'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, 'Invoice', 'Number'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, '', 'Date'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, '', 'LPO Number'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, 'Car', 'Brand'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, '', 'Model'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, 'Plate', 'Number'),
            // onSort: controller.onSort,
          ),
          // DataColumn(label: columnForTable(constraints, '', 'Code')
          //     // onSort: controller.onSort,
          //     ),
          // DataColumn(label: columnForTable(constraints, '', 'City')
          //     // onSort: controller.onSort,
          //     ),
          DataColumn(
            label: columnForTable(constraints, '', 'Customer Name'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: columnForTable(constraints, '', 'VIN'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: columnForTable(constraints, '', 'Totals'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: columnForTable(constraints, '', 'VAT'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: columnForTable(constraints, '', 'NET'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: columnForTable(constraints, '', 'Paid'),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: columnForTable(constraints, '', 'Outstanding'),
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
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return isEvenRow ? Colors.grey.shade200 : Colors.white;
    }),
    cells: [
      DataCell(editSection(context, jobData, constraints, jobId)),
      DataCell(
        jobData.label == 'Draft'
            ? statusBox('D')
            : jobData.label == 'Returned'
            ? statusBox('R', hieght: 35, width: 35)
            : const SizedBox(),
      ),

      DataCell(textForDataRowInTable(text: jobData.jobNumber ?? "")),
      DataCell(
        textForDataRowInTable(
          text: jobData.jobNumber != ''
              ? textToDate(jobData.jobDate ?? "")
              : '',
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
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),

      DataCell(textForDataRowInTable(text: jobData.invoiceNumber ?? '')),
      DataCell(
        textForDataRowInTable(
          text: jobData.invoiceNumber != ''
              ? textToDate(jobData.invoiceDate)
              : '',
        ),
      ),
      DataCell(SelectableText(jobData.lpoNumber ?? '', maxLines: 1)),
      DataCell(textForDataRowInTable(text: jobData.carBrandName ?? '')),
      DataCell(textForDataRowInTable(text: jobData.carModelName ?? '')),
      DataCell(SelectableText(jobData.plateNumber ?? '', maxLines: 1)),
      DataCell(
        textForDataRowInTable(maxWidth: null, text: jobData.customerName ?? ''),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.vehicleIdentificationNumber ?? '',
          maxWidth: null,
          isBold: true,
          color: Colors.deepPurple,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.green,
          isBold: true,
          text: (jobData.totals.toString()),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.red,
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
          color: Colors.blue,
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
                  editJobCardDialog(controller, jobData, jobId);
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
  String jobId, {
  String screenName = '',
  headerColor = '',
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
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
                              screenName == ''
                                  ? controller.getScreenName()
                                  : screenName,
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
                            creatQuotationButton(controller, jobId),
                            point(),
                            creatReceiptButton(controller, jobId),
                            point(),
                            inspectionFormButton(controller, jobId, context),
                            point(),
                            internalNotesButton(controller, constraints, jobId),
                            separator(),
                            saveJobButton(() => controller.addNewJobCard()),
                            point(),
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

ElevatedButton newJobCardButton(
  BuildContext context,
  BoxConstraints constraints,
  JobCardController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          backgroundColor: const Color(0xffF6F9FC),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: const EdgeInsets.all(8),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      controller.getScreenName(),
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
                                                : (controller.jobStatus2.value),
                                            hieght: 35,
                                            padding: const EdgeInsets.symmetric(
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
                                    saveJobButton(
                                      () => controller.addNewJobCard(),
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
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
    style: newButtonStyle,
    child: const Text('New Card'),
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
