import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/entity_informations_controller.dart'
    show EntityInformationsController;
import '../../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/Mobile widgets/inspection report widgets/inspection_report_body.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/entity_informations_widgets/add_new_entity_or_edit.dart'
    show addNewEntityOrEdit;
import '../../../../Widgets/main screen widgets/job_cards_widgets/add_new_job_card_or_edit.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/internal_notes_widget.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/invoice_items_widget.dart';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          GetX<JobCardController>(
                            init: JobCardController(),
                            builder: (controller) {
                              return searchBar(
                                search: controller.search,
                                constraints: constraints,
                                context: context,
                                controller: controller,
                                title: 'Search for job cards',
                                button: newJobCardButton(
                                    context, constraints, controller),
                              );
                            },
                          ),
                          Expanded(
                            child: GetX<JobCardController>(
                              builder: (controller) {
                                if (controller.isScreenLoding.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (controller.allJobCards.isEmpty) {
                                  return const Center(
                                    child: Text('No Element'),
                                  );
                                }
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    width: constraints.maxWidth,
                                    child: tableOfScreens(
                                        showHistoryButton: true,
                                        scrollController: controller
                                            .scrollControllerFotTable1,
                                        constraints: constraints,
                                        context: context,
                                        controller: controller,
                                        data: controller
                                                    .filteredJobCards.isEmpty &&
                                                controller
                                                    .search.value.text.isEmpty
                                            ? controller.allJobCards
                                            : controller.filteredJobCards),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('💳 History', style: fontStyleForAppBar),
                  Expanded(
                      child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetX<JobCardController>(builder: (controller) {
                      return controller.historyJobCards.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: tableOfScreens(
                                  showHistoryButton: false,
                                  scrollController:
                                      controller.scrollControllerFotTable2,
                                  constraints: constraints,
                                  context: context,
                                  controller: controller,
                                  data: controller.historyJobCards))
                          : const Center(
                              child: Text(
                                'History',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                    }),
                  ))
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
  return Scrollbar(
    trackVisibility: true,
    scrollbarOrientation: ScrollbarOrientation.top,
    interactive: true,
    controller: scrollController,
    thumbVisibility: true,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            child: Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth - 30,
              ),
              child: DataTable(
                showCheckboxColumn: false,
                dataRowMaxHeight: 40,
                dataRowMinHeight: 30,
                headingRowHeight: 70,
                columnSpacing: 15,
                showBottomBorder: true,
                dataTextStyle: regTextStyle,
                headingTextStyle: fontStyleForTableHeader,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.isAscending.value,
                headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
                columns: [
                  const DataColumn(
                    label: SizedBox(),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizedText(
                            text: 'Quotation', constraints: constraints),
                        AutoSizedText(text: 'Number', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        // AutoSizedText(text: '', constraints: constraints),
                        AutoSizedText(text: 'Date', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'Status', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizedText(text: 'Job', constraints: constraints),
                        AutoSizedText(text: 'Number', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'Date', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  // DataColumn(
                  //   label: Column(
                  //     spacing: 5,
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(),
                  //       AutoSizedText(text: 'Status', constraints: constraints),
                  //     ],
                  //   ),
                  //   // onSort: controller.onSort,
                  // ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'Status', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizedText(
                            text: 'Invoice', constraints: constraints),
                        AutoSizedText(text: 'Number', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'Date', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(
                            text: 'LPO Number', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizedText(text: 'Car', constraints: constraints),
                        AutoSizedText(text: 'Brand', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'Model', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizedText(text: 'Plate', constraints: constraints),
                        AutoSizedText(text: 'Number', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'Code', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'City', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(
                            text: 'Customer Name', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'VIN', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.end,
                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(),
                        AutoSizedText(
                            text: 'Total Job', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.end,

                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'VAT', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.end,

                    label: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(),
                        AutoSizedText(text: 'NET', constraints: constraints),
                      ],
                    ),
                    // onSort: controller.onSort,
                  ),
                ],
                rows: _getOtherRows(
                    controller: controller,
                    constraints: constraints,
                    data: data),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 220,
          child: DataTable(
            headingRowHeight: 70,
            dataRowMaxHeight: 40,
            dataRowMinHeight: 30,
            columnSpacing: 0,
            showBottomBorder: true,
            dataTextStyle: regTextStyle,
            headingTextStyle: fontStyleForTableHeader,
            headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
            columns: const [
              DataColumn(
                label: SizedBox(),
              ),
            ],
            rows: _getActionRows(
                showHistoryButton: showHistoryButton,
                controller: controller,
                context: context,
                constraints: constraints,
                data: data),
          ),
        ),
      ],
    ),
  );
}

/// Generates rows for the fixed Action column.
List<DataRow> _getActionRows(
    {required JobCardController controller,
    required BuildContext context,
    required BoxConstraints constraints,
    required RxList<DocumentSnapshot> data,
    required bool showHistoryButton}) {
  final jobs = data;
  return jobs.map<DataRow>((job) {
    final jobData = job.data() as Map<String, dynamic>;
    final jobId = job.id;
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                showHistoryButton
                    ? historySection(controller, jobData)
                    : const SizedBox(),
                editSection(context, controller, jobData, constraints, jobId),
              ],
            ),
          ),
        ),
      ],
    );
  }).toList();
}

/// Generates rows for all columns except the Action column.
List<DataRow> _getOtherRows({
  required JobCardController controller,
  required BoxConstraints constraints,
  required RxList<DocumentSnapshot> data,
}) {
  final jobs = data;
  return jobs.map<DataRow>((job) {
    final jobData = job.data() as Map<String, dynamic>;
    return DataRow(
      cells: [
        DataCell(jobData['label'] == 'Draft'
                ? statusBox('D')
                : jobData['label'] == 'Returned'
                    ? statusBox('R')
                    : SizedBox()
            // textForDataRowInTable(
            //   text: '${jobData['label']}',
            //   color: jobData['label'] == 'New'
            //       ? Colors.green
            //       : jobData['label'] == 'Draft'
            //           ? Colors.blueGrey
            //           : Colors.red)
            ),
        DataCell(textForDataRowInTable(text: '${jobData['quotation_number']}')),
        DataCell(textForDataRowInTable(
            text: jobData['quotation_number'] != ''
                ? '${jobData['quotation_date']}'
                : '')),
        DataCell(jobData['quotation_status'] != ''
            ? statusBox('${jobData['quotation_status']}',
                hieght: 35, width: 100)
            : const SizedBox()),
        DataCell(textForDataRowInTable(text: '${jobData['job_number']}')),
        DataCell(textForDataRowInTable(
            text: jobData['job_number'] != '' ? '${jobData['job_date']}' : '')),
        // DataCell(jobData['job_status_1'] != ''
        //     ? statusBox('${jobData['job_status_1']}', hieght: 35, width: 100)
        //     : SizedBox()),
        DataCell(jobData['job_status_2'] != ''
            ? statusBox('${jobData['job_status_2']}', hieght: 35, width: 100)
            : const SizedBox()),
        DataCell(textForDataRowInTable(text: '${jobData['invoice_number']}')),
        DataCell(textForDataRowInTable(
            text: jobData['invoice_number'] != ''
                ? textToDate(jobData['invoice_date'])
                : '')),
        DataCell(SelectableText(
          '${jobData['lpo_number']}',
          maxLines: 1,
        )),
        DataCell(textForDataRowInTable(
            text: controller.getdataName(
                jobData['car_brand'], controller.allBrands))),
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
        DataCell(SelectableText(
          jobData['plate_code'],
          maxLines: 1,
        )),
        DataCell(
          FutureBuilder<String>(
            future: controller.getCityName(jobData['country'], jobData['city']),
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
        DataCell(
          textForDataRowInTable(
            maxWidth: null,
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
            child: StreamBuilder<double>(
              stream: controller.calculateAllTotals(job.id),
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
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: StreamBuilder<double>(
              stream: controller.calculateAllVATs(job.id),
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
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: StreamBuilder<double>(
              stream: controller.calculateAllNETs(job.id),
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
        ),
      ],
    );
  }).toList();
}

ElevatedButton editSection(context, JobCardController controller,
    Map<String, dynamic> jobData, constraints, jobId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        controller.currentCountryVAT.value = controller.getdataName(
            controller.companyDetails['contact_details']['country'],
            controller.allCountries,
            title: 'vat');
        controller.loadValues(jobData);
        editJobCardDialog(controller, jobData, jobId);
      },
      child: const Text('Edit'));
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
    JobCardController controller, Map<String, dynamic> jobData, jobId) {
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
                        topRight: Radius.circular(5)),
                    color: mainColor,
                  ),
                  padding: const EdgeInsets.all(16),
                  width: constraints.maxWidth,
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(
                        '${controller.getScreenName()}',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      GetX<JobCardController>(builder: (controller) {
                        return ElevatedButton(
                          onPressed: controller.addingNewValue.value
                              ? null
                              : () async {
                                  controller.addingNewValue.value = true;

                                  if (jobData['quotation_number'] == '' &&
                                      controller.isQuotationExpanded.isTrue) {
                                    controller.quotationStatus.value = 'New';
                                    controller.label.value = '';
                                    await controller
                                        .getCurrentQuotationCounterNumber();
                                  }
                                  if (jobData['job_number'] == '' &&
                                      controller.isJobCardExpanded.isTrue) {
                                    controller.jobStatus1.value = 'New';
                                    controller.jobStatus2.value = 'New';
                                    controller.label.value = '';
                                    await controller
                                        .getCurrentJobCardCounterNumber();
                                  }
                                  controller.editJobCardAndQuotation(jobId);
                                },
                          style: new2ButtonStyle,
                          child: controller.addingNewValue.value == false
                              ? const Text(
                                  'Save',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                        );
                      }),
                      ElevatedButton(
                          style: cancelJobButtonStyle,
                          onPressed: () {
                            if (controller.jobStatus1.value == 'New' ||
                                controller.jobStatus1.value == '' ||
                                controller.quotationStatus.value == 'New' ||
                                controller.quotationStatus.value == '') {
                              alertDialog(
                                  context: context,
                                  controller: controller,
                                  content: "Theis will be deleted permanently",
                                  onPressed: () {
                                    controller.deleteJobCard(jobId);
                                  });
                            } else {
                              showSnackBar('Can Not Delete',
                                  'Only New Cards Can be Deleted');
                            }
                          },
                          child: const Text('Delete',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      GetX<JobCardController>(builder: (controller) {
                        return ElevatedButton(
                            style: copyJobButtonStyle,
                            onPressed: () async {
                              var newData = await controller.copyJob(jobId);
                              Get.back();
                              controller.loadValues(newData['data']);
                              editJobCardDialog(controller, newData['data'],
                                  newData['newId']);
                            },
                            child: controller.loadingCopyJob.isFalse
                                ? const Text(
                                    'Copy',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ));
                      }),
                      ElevatedButton(
                          style: inspectionFormButtonStyle,
                          onPressed: () {
                            controller.loadInspectionFormValues(jobId, jobData);
                            Get.dialog(
                                barrierDismissible: false,
                                Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    insetPadding: const EdgeInsets.all(20),
                                    child: SizedBox(
                                      width: 600,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      topRight:
                                                          Radius.circular(5)),
                                              color: mainColor,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  '🚘 Inspection Form',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  icon: const Icon(Icons.close,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: buildInspectionReportBody(
                                                  context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )));
                          },
                          child: const Text(
                            'Inspection From',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      ElevatedButton(
                        style: internalNotesButtonStyle,
                        onPressed: () async {
                          internalNotesDialog(controller, constraints, jobId);
                        },
                        child: const Text(
                          'Internal Notes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        style: innvoiceItemsButtonStyle,
                        onPressed: () {
                          controller.getAllInvoiceItems(jobId);
                          Get.dialog(
                              barrierDismissible: true,
                              Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                insetPadding: const EdgeInsets.all(40),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: mainColor,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '💵 Invoice Items',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: invoiceItemsDialog(
                                              constraints: constraints,
                                              context: context,
                                              jobId: jobId),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ));
                        },
                        child: const Text('Invoice Items',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                          style: new2ButtonStyle,
                          onPressed: () {
                            EntityInformationsController otherController =
                                Get.put(EntityInformationsController());

                            otherController.clearAllVariables();
                            Get.dialog(
                                barrierDismissible: false,
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  insetPadding: const EdgeInsets.all(40),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        width: constraints.maxWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: mainColor,
                                        ),
                                        child: Row(
                                          spacing: 10,
                                          children: [
                                            const Spacer(),
                                            Obx(() => ElevatedButton(
                                                  onPressed: otherController
                                                          .addingNewEntity.value
                                                      ? null
                                                      : () async {
                                                          await otherController
                                                              .addNewEntity();
                                                        },
                                                  style: new2ButtonStyle,
                                                  child: otherController
                                                              .addingNewEntity
                                                              .value ==
                                                          false
                                                      ? const Text(
                                                          'Save',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                                )),
                                            closeButton
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: addNewEntityOrEdit(
                                            controller: otherController,
                                            constraints: constraints,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          },
                          child: const Text(
                            'New Customer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      closeButton
                    ],
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
          })));
}

ElevatedButton newJobCardButton(BuildContext context,
    BoxConstraints constraints, JobCardController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.quotationDate.value.text = textToDate(DateTime.now());
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
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: mainColor,
                      ),
                      padding: const EdgeInsets.all(16),
                      width: constraints.maxWidth,
                      child: Row(spacing: 10, children: [
                        Text(
                          '${controller.getScreenName()}',
                          style: fontStyleForScreenNameUsedInButtons,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: innvoiceItemsButtonStyle,
                          onPressed: () {
                            if (controller
                                .canAddInternalNotesAndInvoiceItems.isTrue) {
                              Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                insetPadding: const EdgeInsets.all(40),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: mainColor,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Invoice Items',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: invoiceItemsDialog(
                                              constraints: constraints,
                                              context: context,
                                              jobId: controller
                                                  .curreentJobCardId.value),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            } else {
                              showSnackBar('Alert', 'Please Save Job First');
                            }
                          },
                          child: const Text(
                            'Invoice Items',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          style: internalNotesButtonStyle,
                          onPressed: () {
                            if (controller
                                .canAddInternalNotesAndInvoiceItems.isTrue) {
                              internalNotesDialog(controller, constraints,
                                  controller.curreentJobCardId.value);
                            } else {
                              showSnackBar('Alert', 'Please Save Job First');
                            }
                          },
                          child: const Text(
                            'Internal Notes',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        GetX<JobCardController>(
                          builder: (controller) => ElevatedButton(
                            onPressed: () async {
                              await controller.addNewJobCardAndQuotation();
                            },
                            style: new2ButtonStyle,
                            child: controller.addingNewValue.value == false
                                ? const Text(
                                    'Save',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                          ),
                        ),
                        closeButton
                      ])),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: addNewJobCardOrEdit(
                      jobId: null,
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
