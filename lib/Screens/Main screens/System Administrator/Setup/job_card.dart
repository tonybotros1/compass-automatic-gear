import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/add_new_job_card_or_edit.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/job_card_buttons.dart';
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
                                // controller: controller,
                                title: 'Search for job cards',
                                button: newJobCardButton(
                                    context, constraints, controller),
                              );
                            },
                          ),
                          GetX<JobCardController>(
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
                              return SizedBox(
                                width: constraints.maxWidth,
                                child: tableOfScreens(
                                    showHistoryButton: true,
                                    scrollController:
                                        controller.scrollControllerFotTable1,
                                    constraints: constraints,
                                    context: context,
                                    controller: controller,
                                    data: controller.filteredJobCards.isEmpty &&
                                            controller.search.value.text.isEmpty
                                        ? controller.allJobCards
                                        : controller.filteredJobCards),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
    child: PaginatedDataTable(
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
        DataColumn(label: columnForTable(constraints, '', 'Code')
            // onSort: controller.onSort,
            ),
        DataColumn(label: columnForTable(constraints, '', 'City')
            // onSort: controller.onSort,
            ),
        DataColumn(label: columnForTable(constraints, '', 'Customer Name')
            // onSort: controller.onSort,
            ),
        DataColumn(label: columnForTable(constraints, '', 'VIN')
            // onSort: controller.onSort,
            ),
        DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: columnForTable(constraints, '', 'Total Job')
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
                    : SizedBox()
            // textForDataRowInTable(
            //   text: '${jobData['label']}',
            //   color: jobData['label'] == 'New'
            //       ? Colors.green
            //       : jobData['label'] == 'Draft'
            //           ? Colors.blueGrey
            //           : Colors.red)
            ),

        DataCell(textForDataRowInTable(text: '${jobData['job_number']}')),
        DataCell(textForDataRowInTable(
            text: jobData['job_number'] != '' ? '${jobData['job_date']}' : '')),
        // DataCell(jobData['job_status_1'] != ''
        //     ? statusBox('${jobData['job_status_1']}', hieght: 35, width: 100)
        //     : SizedBox()),
        //   if (isBeforeToday(jobWarrentyEndDate.value.text)) {
        //   status2 = 'Closed';
        // } else {
        //   status2 = 'Warranty';
        // }
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

        // DataCell(jobData['job_status_2'] != ''
        //     ? statusBox('${jobData['job_status_2']}', hieght: 35, width: 100)
        //     : const SizedBox()),
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
              stream: controller.calculateAllTotals(jobId),
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
              stream: controller.calculateAllVATs(jobId),
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
              stream: controller.calculateAllNETs(jobId),
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

                  await editJobCardDialog(controller, jobData, jobId);
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
    {String screenName = ''}) {
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
                color: mainColor,
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
                          creatQuotationButton(controller),
                          point(),
                          inspectionFormButton(
                              controller, jobId, jobData, context),
                          point(),
                          internalNotesButton(controller, constraints, jobId),
                          separator(),
                          saveJobButton(() => controller.editJobCard(jobId)),
                          point(),
                          copyJobButton(jobId),
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
                                      creatQuotationButton(controller),
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
