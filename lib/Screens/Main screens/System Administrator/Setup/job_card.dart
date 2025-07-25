import 'package:cloud_firestore/cloud_firestore.dart';
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
  JobCard({super.key});
  final JobCardController jobCardController = Get.put(JobCardController());

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
                  GetX<JobCardController>(builder: (controller) {
                    bool isBrandLoading = controller.allBrands.isEmpty;
                    bool isModelLoading = controller.allModels.isEmpty;
                    bool isCustomersLoading = controller.allCustomers.isEmpty;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 10,
                      children: [
                        Expanded(
                            child: myTextFormFieldWithBorder(
                          labelText: 'Job NO.',
                          controller: controller.jobNumberFilter.value,
                        )),
                        Expanded(
                            child: myTextFormFieldWithBorder(
                          labelText: 'Invoice NO.',
                          controller: controller.invoiceNumberFilter.value,
                        )),
                        Expanded(
                          flex: 2,
                          child: CustomDropdown(
                            showedSelectedName: 'name',
                            textcontroller:
                                controller.carBrandIdFilterName.value.text,
                            hintText: 'Car Brand',
                            items: isBrandLoading ? {} : controller.allBrands,
                            onChanged: (key, value) async {
                              controller.carModel.clear();
                              controller.getModelsByCarBrand(key);
                              controller.carBrandIdFilter.value = key;
                              controller.carBrandIdFilterName.value.text =
                                  value['name'];
                              controller.carModelIdFilter.value = '';
                              controller.carModelIdFilterName.value.text = '';
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomDropdown(
                            showedSelectedName: 'name',
                            textcontroller:
                                controller.carModelIdFilterName.value.text,
                            hintText: 'Car Model',
                            items: isModelLoading ? {} : controller.allModels,
                            onChanged: (key, value) async {
                              controller.carModelIdFilter.value = key;
                              controller.carModelIdFilterName.value.text =
                                  value['name'];
                            },
                          ),
                        ),
                        Expanded(
                            child: myTextFormFieldWithBorder(
                          labelText: 'Plate NO.',
                          controller: controller.plateNumberFilter.value,
                        )),
                        Expanded(
                            flex: 2,
                            child: myTextFormFieldWithBorder(
                              labelText: 'VIN',
                              controller: controller.vinFilter.value,
                            )),
                        Expanded(
                            flex: 3,
                            child: CustomDropdown(
                                textcontroller: controller
                                    .customerNameIdFilterName.value.text,
                                showedSelectedName: 'entity_name',
                                hintText: 'Customer Name',
                                onChanged: (key, value) async {
                                  controller.customerNameIdFilterName.value
                                      .text = value['entity_name'];
                                  controller.customerNameIdFilter.value = key;
                                },
                                items: isCustomersLoading
                                    ? {}
                                    : controller.allCustomers)),
                        Expanded(
                          child: CustomDropdown(
                            textcontroller: controller.statusFilter.value.text,
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
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  GetBuilder<JobCardController>(builder: (controller) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: myTextFormFieldWithBorder(
                                controller: controller.fromDate.value,
                                labelText: 'From Date',
                                onFieldSubmitted: (_) async {
                                  await normalizeDate(
                                      controller.fromDate.value.text,
                                      controller.fromDate.value);
                                  // if (nor) {
                                  //   controller.searchEngine();
                                  // }
                                },
                              )),
                              Expanded(
                                  child: myTextFormFieldWithBorder(
                                controller: controller.toDate.value,
                                labelText: 'To Date',
                                onFieldSubmitted: (_) async {
                                  await normalizeDate(
                                      controller.toDate.value.text,
                                      controller.toDate.value);
                                  // if (nor) {
                                  //   controller.searchEngine();
                                  // }
                                },
                              )),
                              ElevatedButton(
                                  style: allButtonStyle,
                                  onPressed: () {
                                    controller.clearAllFilters();
                                    controller.isAllSelected.value = true;
                                    controller.isTodaySelected.value = false;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value = false;
                                    controller.carBrand.clear();
                                    controller.carModel.clear();
                                    controller.carBrandId.value = '';
                                    controller.carModelId.value = '';
                                    controller.allModels.clear();
                                    controller.searchEngine();
                                  },
                                  child: Text('All')),
                              ElevatedButton(
                                  style: todayButtonStyle,
                                  onPressed: controller.isTodaySelected.isFalse
                                      ? () {
                                          controller.isAllSelected.value =
                                              false;
                                          controller.isTodaySelected.value =
                                              true;
                                          controller.isThisMonthSelected.value =
                                              false;
                                          controller.isThisYearSelected.value =
                                              false;
                                          controller.isYearSelected.value =
                                              false;
                                          controller.isMonthSelected.value =
                                              false;
                                          controller.isDaySelected.value = true;
                                          controller.searchEngine();
                                        }
                                      : null,
                                  child: Text('Today')),
                              ElevatedButton(
                                  style: thisMonthButtonStyle,
                                  onPressed: controller
                                          .isThisMonthSelected.isFalse
                                      ? () {
                                          controller.isAllSelected.value =
                                              false;
                                          controller.isTodaySelected.value =
                                              false;
                                          controller.isThisMonthSelected.value =
                                              true;
                                          controller.isThisYearSelected.value =
                                              false;
                                          controller.isYearSelected.value =
                                              false;
                                          controller.isMonthSelected.value =
                                              true;
                                          controller.isDaySelected.value =
                                              false;
                                          controller.searchEngine();
                                        }
                                      : null,
                                  child: Text('This Month')),
                              ElevatedButton(
                                  style: thisYearButtonStyle,
                                  onPressed: controller
                                          .isThisYearSelected.isFalse
                                      ? () {
                                          controller.isTodaySelected.value =
                                              false;
                                          controller.isThisMonthSelected.value =
                                              false;
                                          controller.isThisYearSelected.value =
                                              true;
                                          controller.isYearSelected.value =
                                              true;
                                          controller.isMonthSelected.value =
                                              false;
                                          controller.isDaySelected.value =
                                              false;
                                          controller.searchEngine();
                                        }
                                      : null,
                                  child: Text('This Year')),
                              ElevatedButton(
                                  style: saveButtonStyle,
                                  onPressed:
                                      controller.isThisYearSelected.isFalse
                                          ? () async {
                                              await controller.removeFilters();
                                              controller.searchEngine();
                                            }
                                          : null,
                                  child: Text(
                                    'Find',
                                    style: fontStyleForElevatedButtons,
                                  )),
                              ElevatedButton(
                                  style: clearVariablesButtonStyle,
                                  onPressed:
                                      controller.isThisYearSelected.isFalse
                                          ? () {
                                              controller.clearAllFilters();
                                              controller.update();
                                            }
                                          : null,
                                  child: Text(
                                    'Clear Filters',
                                    style: fontStyleForElevatedButtons,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: SizedBox()),
                        newJobCardButton(context, constraints, controller)
                      ],
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GetX<JobCardController>(
                        init: JobCardController(),
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
                                        fontSize: 16),
                                  )),
                              customBox(
                                  title: 'TOTALS',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.green,
                                    isBold: true,
                                    text: '${controller.allJobsTotals.value}',
                                  )),
                              customBox(
                                  title: 'VATS',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.red,
                                    isBold: true,
                                    text: '${controller.allJobsVATS.value}',
                                  )),
                              customBox(
                                  title: 'NETS',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.blueGrey,
                                    isBold: true,
                                    text: '${controller.allJobsNET.value}',
                                  )),
                            ],
                          );
                        }),
                  ),
                  GetX<JobCardController>(builder: (controller) {
                    return Container(
                      // height: controller.allJobCards.isEmpty ? 300 : null,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          // searchBar(
                          //   search: controller.search,
                          //   constraints: constraints,
                          //   context: context,
                          //   title: 'Search for job cards',
                          //   button: newJobCardButton(
                          //       context, constraints, controller),
                          // ),
                          controller.isScreenLoding.isTrue &&
                                  controller.allJobCards.isEmpty
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
                                      data: controller.allJobCards),
                                )
                        ],
                      ),
                    );
                  }),
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
        // showBottomBorder: true,
        // dataTextStyle: regTextStyle,
        // headingTextStyle: fontStyleForTableHeader,
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
          DataColumn(label: columnForTable(constraints, '', 'Date')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, '', 'Status')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, 'Invoice', 'Number')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, '', 'Date')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, '', 'LPO Number')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, 'Car', 'Brand')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, '', 'Model')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, 'Plate', 'Number')
              // onSort: controller.onSort,
              ),
          // DataColumn(label: columnForTable(constraints, '', 'Code')
          //     // onSort: controller.onSort,
          //     ),
          // DataColumn(label: columnForTable(constraints, '', 'City')
          //     // onSort: controller.onSort,
          //     ),
          DataColumn(label: columnForTable(constraints, '', 'Customer Name')
              // onSort: controller.onSort,
              ),
          DataColumn(label: columnForTable(constraints, '', 'VIN')
              // onSort: controller.onSort,
              ),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.end,
              label: columnForTable(constraints, '', 'Totals')
              // onSort: controller.onSort,
              ),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.end,
              label: columnForTable(constraints, '', 'VAT')
              // onSort: controller.onSort,
              ),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.end,
              label: columnForTable(constraints, '', 'NET')
              // onSort: controller.onSort,
              ),
        ],
        source: dataSource,
      ),
    ),
  );
}

Column columnForTable(
    BoxConstraints constraints, String title1, String title2) {
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

DataRow dataRowForTheTable(Map<String, dynamic> jobData, context, constraints,
    jobId, JobCardController controller, int index) {
  final isEvenRow = index % 2 == 0;
  return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade400;
        }
        return isEvenRow ? Colors.grey.shade200 : Colors.white;
      }),
      cells: [
        DataCell(Row(
          children: [
            editSection(context, jobData, constraints, jobId),
          ],
        )),
        DataCell(jobData['label'] == 'Draft'
            ? statusBox('D')
            : jobData['label'] == 'Returned'
                ? statusBox('R')
                : SizedBox()),

        DataCell(textForDataRowInTable(text: '${jobData['job_number']}')),
        DataCell(textForDataRowInTable(
            text: jobData['job_number'] != ''
                ? textToDate(jobData['job_date'])
                : '')),
        DataCell(
          statusBox(
            jobData['job_status_1'] == 'Posted'
                ? ((isBeforeToday(jobData['job_warrenty_end_date']))
                    ? 'Closed'
                    : 'Warranty')
                : (jobData['job_status_2'] as String? ?? 'Unknown'),
            hieght: 35,
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
        ),

        DataCell(textForDataRowInTable(text: '${jobData['invoice_number']}')),
        DataCell(textForDataRowInTable(
            text: jobData['invoice_number'] != ''
                ? textToDate(jobData['invoice_date'])
                : '')),
        DataCell(SelectableText(
          '${jobData['lpo_number']}',
          maxLines: 1,
        )),
        // DataCell(
        //     textForDataRowInTable(text: '${controller.carBrandsNames[jobId]}')),
        DataCell(textForDataRowInTable(
            text: controller.getdataName(
                jobData['car_brand'], controller.allBrands))),
        // DataCell(
        //     textForDataRowInTable(text: '${controller.carModelsNames[jobId]}')),
        DataCell(
          FutureBuilder<String>(
            future: controller.getModelName(
                jobData['car_brand'], jobData['car_model']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
        DataCell(SelectableText(
          jobData['plate_number'],
          maxLines: 1,
        )),
        // DataCell(SelectableText(
        //   jobData['plate_code'],
        //   maxLines: 1,
        // )),
        // DataCell(
        //   FutureBuilder<String>(
        //     future: controller.getCityName(jobData['country'], jobData['city']),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Text('Loading...');
        //       } else if (snapshot.hasError) {
        //         return const Text('Error');
        //       } else {
        //         return textForDataRowInTable(
        //           text: '${snapshot.data}',
        //         );
        //       }
        //     },
        //   ),
        // ),
        // DataCell(textForDataRowInTable(
        //     maxWidth: null, text: '${controller.customerNames[jobId]}')),
        DataCell(
          textForDataRowInTable(
            maxWidth: null,
            // maxWidth: 1,
            text: controller.getdataName(
                jobData['customer'], controller.allCustomers,
                title: 'entity_name'),
          ),
        ),
        DataCell(SelectableText(
          jobData['vehicle_identification_number'],
          maxLines: 1,
        )),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: textForDataRowInTable(
              color: Colors.green,
              isBold: true,
              text: (jobData.containsKey('totals_amount') &&
                      jobData['totals_amount'] != null &&
                      jobData['totals_amount'].toString().trim().isNotEmpty)
                  ? jobData['totals_amount'].toString()
                  : '0',
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: textForDataRowInTable(
              color: Colors.red,
              isBold: true,
              text: (jobData.containsKey('total_vat_amount') &&
                      jobData['total_vat_amount'] != null &&
                      jobData['total_vat_amount'].toString().trim().isNotEmpty)
                  ? jobData['total_vat_amount'].toString()
                  : '0',
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: textForDataRowInTable(
              color: Colors.blueGrey,
              isBold: true,
              text: (jobData.containsKey('total_net_amount') &&
                      jobData['total_net_amount'] != null &&
                      jobData['total_net_amount'].toString().trim().isNotEmpty)
                  ? jobData['total_net_amount'].toString()
                  : '0',
            ),
          ),
        )
      ]);
}

Widget editSection(BuildContext context, Map<String, dynamic> jobData,
    BoxConstraints constraints, String jobId) {
  return GetX<JobCardController>(
    builder: (controller) {
      // Always read the reactive map here so GetX rebuilds when it changes
      final isLoading = controller.buttonLoadingStates[jobId] ?? false;

      return IconButton(
        tooltip: 'Edit',
        onPressed: isLoading
            ? null
            : () async {
                controller.setButtonLoading(jobId, true);

                try {
                  await controller.getAllInvoiceItems(jobId);
                  controller.currentCountryVAT.value = controller.getdataName(
                    controller.companyDetails['contact_details']['country'],
                    controller.allCountries,
                    title: 'vat',
                  );
                  await controller.loadValues(jobData);
                  editJobCardDialog(controller, jobData, jobId);
                } finally {
                  controller.setButtonLoading(jobId, false);
                }
              },
        icon: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.edit_note_rounded,
                color: Colors.blue,
              ),
      );
    },
  );
}

ElevatedButton historySection(
    JobCardController controller, Map<String, dynamic> jobData) {
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
      child: const Text('History'));
}

Future<dynamic> editJobCardDialog(
    JobCardController controller, Map<String, dynamic> jobData, String jobId,
    {String screenName = '', headerColor = ''}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: LayoutBuilder(builder: (context, constraints) {
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
                  constraints:
                      BoxConstraints(minWidth: constraints.maxWidth - 40),
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
                          GetX<JobCardController>(builder: (ctl) {
                            if (ctl.jobStatus2.value.isNotEmpty &&
                                ctl.jobStatus1.value.isNotEmpty) {
                              return statusBox(
                                ctl.jobStatus1.value == 'Posted'
                                    ? (isBeforeToday(
                                            ctl.jobWarrentyEndDate.value.text)
                                        ? 'Closed'
                                        : 'Warranty')
                                    : ctl.jobStatus2.value,
                                hieght: 35,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                              );
                            }
                            return const SizedBox();
                          }),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          separator(),
                          creatQuotationButton(controller, jobId),
                          point(),
                          inspectionFormButton(
                              controller, jobId, jobData, context),
                          point(),
                          internalNotesButton(controller, constraints, jobId),
                          separator(),
                          saveJobButton(() => controller.editJobCard(jobId)),
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
      }),
    ),
  );
}

ElevatedButton newJobCardButton(BuildContext context,
    BoxConstraints constraints, JobCardController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.currentCountryVAT.value = controller.getdataName(
          controller.companyDetails['contact_details']['country'],
          controller.allCountries,
          title: 'vat');
      controller.country.text = controller.getdataName(
          controller.companyDetails['contact_details']['country'],
          controller.allCountries);
      controller.countryId.value =
          controller.companyDetails['contact_details']['country'];
      controller.getCitiesByCountryID(
          controller.companyDetails['contact_details']['country']);
      controller.mileageIn.value.text = '0';
      controller.mileageOut.value.text = '0';
      controller.inOutDiff.value.text = '0';
      controller.customerCreditNumber.text = '0';
      controller.customerOutstanding.text = '0';
      controller.isCashSelected.value = true;
      controller.payType.value = 'Cash';
      controller.jobCardDate.value.text = textToDate(DateTime.now());
      controller.invoiceDate.value.text = textToDate(DateTime.now());
      controller.startDate.value.text = textToDate(DateTime.now());
      var entry = controller.allCurrencies.entries.firstWhere(
          (entry) =>
              entry.value['country_id'] ==
              controller.companyDetails['contact_details']['country'],
          orElse: () => const MapEntry('', {}));
      controller.customerCurrencyId.value = entry.key ?? '';
      controller.customerCurrencyRate.text =
          (entry.value['rate'] ?? '1').toString();
      controller.customerCurrency.text = controller.getdataName(
          controller.companyDetails['contact_details']['country'],
          controller.allCountries,
          title: 'currency_code');
      controller.clearValues();
      Get.dialog(
          barrierDismissible: false,
          Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              insetPadding: const EdgeInsets.all(8),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(children: [
                  GetX<JobCardController>(builder: (controller) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          color: mainColor,
                        ),
                        padding: const EdgeInsets.all(16),
                        width: constraints.maxWidth,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: constraints.maxWidth - 40),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Text(
                                        '${controller.getScreenName()}',
                                        style:
                                            fontStyleForScreenNameUsedInButtons,
                                      ),
                                      controller.jobStatus2.value.isNotEmpty
                                          ? statusBox(
                                              controller.jobStatus1.value ==
                                                      'Posted'
                                                  ? ((isBeforeToday(controller
                                                          .jobWarrentyEndDate
                                                          .value
                                                          .text))
                                                      ? 'Closed'
                                                      : 'Warranty')
                                                  : (controller
                                                      .jobStatus2.value),
                                              hieght: 35,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      separator(),
                                      creatQuotationButton(controller,
                                          controller.curreentJobCardId.value),
                                      point(),
                                      internalNotesButton(
                                          controller,
                                          constraints,
                                          controller.curreentJobCardId.value),
                                      separator(),
                                      saveJobButton(
                                          () => controller.addNewJobCard()),
                                      separator(),
                                      changeStatusToPostedButton(controller,
                                          controller.curreentJobCardId.value),
                                      point(),
                                      changeStatusToCancelledButton(
                                          controller.curreentJobCardId.value),
                                      point(),
                                      changeStatusToNewButton(
                                          controller.curreentJobCardId.value),
                                      point(),
                                      changeStatusToApproveButton(
                                          controller.curreentJobCardId.value),
                                      point(),
                                      changeStatusToReadyButton(
                                          controller.curreentJobCardId.value),
                                      separator(),
                                      closeIcon()
                                    ],
                                  ),
                                ]),
                          ),
                        ));
                  }),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: addNewJobCardOrEdit(
                      jobId: controller.curreentJobCardId.value,
                      controller: controller,
                      constraints: constraints,
                      context: context,
                    ),
                  ))
                ]);
              })));
    },
    style: newButtonStyle,
    child: const Text('New Card'),
  );
}

class CardDataSource extends DataTableSource {
  final List<DocumentSnapshot> cards;
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
