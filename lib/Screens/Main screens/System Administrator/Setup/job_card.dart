import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/entity_informations_controller.dart'
    show EntityInformationsController;
import '../../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
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
                children: [
                  Expanded(
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
                                      constraints: constraints,
                                      context: context,
                                      controller: controller,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
  required JobCardController controller,
}) {
  return Scrollbar(
    trackVisibility: true,
    scrollbarOrientation: ScrollbarOrientation.top,
    interactive: true,
    controller: controller.scrollControllerFotTable,
    thumbVisibility: true,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: controller.scrollControllerFotTable,
            child: Container(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth - 30,
              ),
              child: DataTable(
                dataRowMaxHeight: 40,
                dataRowMinHeight: 30,
                columnSpacing: 5,
                showBottomBorder: true,
                dataTextStyle: regTextStyle,
                headingTextStyle: fontStyleForTableHeader,
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.isAscending.value,
                headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
                columns: [
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Quotation No.', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Quotation Date', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Job No.', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Job Date', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Invoice No.', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Inv Date', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Job Status 1', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Job Status 2', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Quotation Status', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'LPO No.', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Car Brand', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Plate Number', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(
                        text: 'Customer Name', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    label: AutoSizedText(text: 'VIN', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.end,
                    label: AutoSizedText(
                        text: 'Total Job', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.end,

                    label: AutoSizedText(text: 'VAT', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.end,

                    label: AutoSizedText(text: 'NET', constraints: constraints),
                    // onSort: controller.onSort,
                  ),
                ],
                rows: _getOtherRows(controller, context, constraints),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: DataTable(
            dataRowMaxHeight: 40,
            dataRowMinHeight: 30,
            columnSpacing: 0,
            showBottomBorder: true,
            dataTextStyle: regTextStyle,
            headingTextStyle: fontStyleForTableHeader,
            headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
            columns: [
              DataColumn(
                headingRowAlignment: MainAxisAlignment.center,
                label: AutoSizedText(constraints: constraints, text: ''),
              ),
            ],
            rows: _getActionRows(controller, context, constraints),
          ),
        ),
      ],
    ),
  );
}

/// Generates rows for the fixed Action column.
List<DataRow> _getActionRows(JobCardController controller, BuildContext context,
    BoxConstraints constraints) {
  final jobs = controller.filteredJobCards.isEmpty &&
          controller.search.value.text.isEmpty
      ? controller.allJobCards
      : controller.filteredJobCards;
  return jobs.map<DataRow>((job) {
    final jobData = job.data() as Map<String, dynamic>;
    final jobId = job.id;
    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              editSection(context, controller, jobData, constraints, jobId),
            ],
          ),
        ),
      ],
    );
  }).toList();
}

/// Generates rows for all columns except the Action column.
List<DataRow> _getOtherRows(JobCardController controller, BuildContext context,
    BoxConstraints constraints) {
  final jobs = controller.filteredJobCards.isEmpty &&
          controller.search.value.text.isEmpty
      ? controller.allJobCards
      : controller.filteredJobCards;
  return jobs.map<DataRow>((job) {
    final jobData = job.data() as Map<String, dynamic>;
    return DataRow(
      cells: [
        DataCell(textForDataRowInTable(text: '${jobData['quotation_number']}')),
        DataCell(textForDataRowInTable(text: '${jobData['quotation_date']}')),
        DataCell(textForDataRowInTable(text: '${jobData['job_number']}')),
        DataCell(textForDataRowInTable(text: '${jobData['job_date']}')),
        DataCell(textForDataRowInTable(text: '${jobData['invoice_number']}')),
        DataCell(textForDataRowInTable(text: '${jobData['invoice_date']}')),
        DataCell(
            statusBox('${jobData['job_status_1']}', hieght: 35, width: 100)),
        DataCell(
            statusBox('${jobData['job_status_2']}', hieght: 35, width: 100)),
        DataCell(statusBox('${jobData['quotation_status']}',
            hieght: 35, width: 100)),
        DataCell(textForDataRowInTable(text: '${jobData['lpo_number']}')),
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
                  text:
                      '${controller.getdataName(jobData['car_brand'], controller.allBrands)}-${snapshot.data}',
                );
              }
            },
          ),
        ),
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
                  text:
                      '${jobData['plate_number']}-${jobData['plate_code']}-${snapshot.data}',
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
        DataCell(
          textForDataRowInTable(
            maxWidth: null,
            text: jobData['vehicle_identification_number'],
          ),
        ),
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
        Get.dialog(
            barrierDismissible: false,
            Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                insetPadding: EdgeInsets.all(8),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: addNewJobCardOrEdit(
                            controller: controller,
                            constraints: constraints,
                            context: context,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        height: null,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      ElevatedButton(
                                        style: internalNotesButtonStyle,
                                        onPressed: () async {
                                          internalNotesDialog(
                                              controller, constraints, jobId);
                                        },
                                        child: Text('Internal Notes'),
                                      ),
                                      ElevatedButton(
                                        style: innvoiceItemsButtonStyle,
                                        onPressed: () {
                                          controller.getAllInvoiceItems(jobId);
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  actionsPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                  content: invoiceItemsDialog(
                                                      constraints: constraints,
                                                      context: context,
                                                      jobId: jobId),
                                                  actions: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        style:
                                                            cancelButtonStyle,
                                                        child: const Text(
                                                          'Exit',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text('Invoice Items'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                          style: new2ButtonStyle,
                                          onPressed: () {
                                            EntityInformationsController
                                                otherController = Get.put(
                                                    EntityInformationsController());

                                            otherController.clearAllVariables();

                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    actionsPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20),
                                                    content: addNewEntityOrEdit(
                                                      controller:
                                                          otherController,
                                                      constraints: constraints,
                                                      context: context,
                                                    ),
                                                    actions: [
                                                      Obx(() => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        16),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  otherController
                                                                          .addingNewEntity
                                                                          .value
                                                                      ? null
                                                                      : () async {
                                                                          await otherController
                                                                              .addNewEntity();
                                                                        },
                                                              style:
                                                                  saveButtonStyle,
                                                              child: otherController
                                                                          .addingNewEntity
                                                                          .value ==
                                                                      false
                                                                  ? const Text(
                                                                      'Save',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  : SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .white,
                                                                        strokeWidth:
                                                                            2,
                                                                      ),
                                                                    ),
                                                            ),
                                                          )),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          style:
                                                              cancelButtonStyle,
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text('New Customer')),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      GetX<JobCardController>(
                                          builder: (controller) {
                                        return ElevatedButton(
                                            style: new2ButtonStyle,
                                            onPressed:
                                                controller.jobStatus1.value ==
                                                            'New' &&
                                                        controller.jobStatus2
                                                                .value !=
                                                            'New'
                                                    ? () {
                                                        controller
                                                            .editNewForJobCard(
                                                                jobId, 'New');
                                                      }
                                                    : null,
                                            child: Text('New'));
                                      }),
                                      GetX<JobCardController>(
                                          builder: (controller) {
                                        return ElevatedButton(
                                            style: approveButtonStyle,
                                            onPressed: controller
                                                            .jobStatus1.value ==
                                                        'New' &&
                                                    controller
                                                            .jobStatus2.value !=
                                                        'Approved'
                                                ? () {
                                                    controller.approvalDate
                                                            .value.text =
                                                        textToDate(
                                                            DateTime.now());
                                                    controller.jobStatus2
                                                        .value = 'Approved';
                                                    controller
                                                        .editApproveForJobCard(
                                                            jobId, 'Approved');
                                                  }
                                                : null,
                                            child: Text('Approve'));
                                      }),
                                      GetX<JobCardController>(
                                          builder: (controller) {
                                        return ElevatedButton(
                                            style: readyButtonStyle,
                                            onPressed:
                                                controller.jobStatus1.value ==
                                                            'New' &&
                                                        controller.jobStatus2
                                                                .value !=
                                                            'Ready'
                                                    ? () {
                                                        controller.finishDate
                                                                .value.text =
                                                            textToDate(
                                                                DateTime.now());
                                                        controller.jobStatus2
                                                            .value = 'Ready';
                                                        controller
                                                            .editReadyForJobCard(
                                                                jobId, 'Ready');
                                                      }
                                                    : null,
                                            child: Text('Ready'));
                                      }),
                                    ],
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      GetX<JobCardController>(
                                          builder: (controllerr) {
                                        return ElevatedButton(
                                            style: postButtonStyle,
                                            onPressed:
                                                controllerr.jobStatus1.value !=
                                                            'Posted' &&
                                                        controllerr
                                                            .jobWarrentyEndDate
                                                            .value
                                                            .text
                                                            .isNotEmpty &&
                                                        controllerr.jobStatus1
                                                                .value !=
                                                            'Canceled'
                                                    ? () {
                                                        controllerr
                                                            .editPostForJobCard(
                                                                jobId);
                                                      }
                                                    : null,
                                            child:
                                                controllerr.postingJob.isFalse
                                                    ? Text('Post Job')
                                                    : SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                      ));
                                      }),
                                      GetX<JobCardController>(
                                          builder: (controller) {
                                        return ElevatedButton(
                                            style: cancelJobButtonStyle,
                                            onPressed: controller
                                                            .jobStatus1.value !=
                                                        'Canceled' &&
                                                    controller
                                                            .jobStatus2.value !=
                                                        'Canceled' &&
                                                    controller
                                                            .jobStatus1.value !=
                                                        ''
                                                ? () {
                                                    controller
                                                        .editCancelForJobCard(
                                                            jobId, 'Canceled');
                                                  }
                                                : null,
                                            child: Text('Cancel Job'));
                                      }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GetX<JobCardController>(
                                      builder: (controller) {
                                    return ElevatedButton(
                                        style: postButtonStyle,
                                        onPressed: controller.quotationStatus
                                                        .value !=
                                                    'Posted' &&
                                                controller.quotationStatus
                                                        .value !=
                                                    'Canceled' &&
                                                controller.quotationStatus.value
                                                    .isNotEmpty
                                            ? () {
                                                controller.editPostForQuotation(
                                                    jobId);
                                              }
                                            : null,
                                        child: Text('Post Quotation'));
                                  }),
                                  GetX<JobCardController>(
                                      builder: (controller) {
                                    return ElevatedButton(
                                        style: cancelJobButtonStyle,
                                        onPressed:
                                            controller.quotationStatus.value !=
                                                        'Canceled' &&
                                                    controller.quotationStatus
                                                        .value.isNotEmpty
                                                ? () {
                                                    controller
                                                        .editCancelForQuotation(
                                                            jobId);
                                                  }
                                                : null,
                                        child: Text('Cancel Quotation'));
                                  }),
                                ],
                              ),
                            ),
                            ElevatedButton(
                                style: deleteButtonStyle,
                                onPressed: () {
                                  alertDialog(
                                      context: context,
                                      controller: controller,
                                      content:
                                          "Theis will be deleted permanently",
                                      onPressed: () {
                                        controller.deleteJobCard(jobId);
                                      });
                                },
                                child: Text('Delete')),
                            Spacer(),
                            GetX<JobCardController>(builder: (controller) {
                              return ElevatedButton(
                                onPressed: controller.addingNewValue.value
                                    ? null
                                    : () async {
                                        controller.addingNewValue.value = true;

                                        if (jobData['quotation_number'] == '' &&
                                            controller
                                                .isQuotationExpanded.isTrue) {
                                          controller.quotationStatus.value =
                                              'New';
                                          await controller
                                              .getCurrentQuotationCounterNumber();
                                        }
                                        if (jobData['job_number'] == '' &&
                                            controller
                                                .isJobCardExpanded.isTrue) {
                                          controller.jobStatus1.value = 'New';
                                          controller.jobStatus2.value = 'New';
                                          await controller
                                              .getCurrentJobCardCounterNumber();
                                        }
                                        controller
                                            .editJobCardAndQuotation(jobId);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: controller.addingNewValue.value == false
                                    ? const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : SizedBox(
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
                                onPressed: () {
                                  Get.back();
                                },
                                style: cancelButtonStyle,
                                child: const Text(
                                  'Exit',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      )
                    ],
                  );
                })));
      },
      child: const Text('Edit'));
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
      controller.clearValues();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
              content: addNewJobCardOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetX<JobCardController>(builder: (controller) {
                      return ElevatedButton(
                        style: internalNotesButtonStyle,
                        onPressed:
                            controller.canAddInternalNotesAndInvoiceItems.isTrue
                                ? () async {
                                    internalNotesDialog(controller, constraints,
                                        controller.curreentJobCardId.value);
                                  }
                                : null,
                        child: Text('Internal Notes'),
                      );
                    }),
                    GetX<JobCardController>(builder: (controller) {
                      return ElevatedButton(
                        style: innvoiceItemsButtonStyle,
                        onPressed:
                            controller.canAddInternalNotesAndInvoiceItems.isTrue
                                ? () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actionsPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20),
                                            content: invoiceItemsDialog(
                                                constraints: constraints,
                                                context: context,
                                                jobId: controller
                                                    .curreentJobCardId.value),
                                            actions: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  style: cancelButtonStyle,
                                                  child: const Text(
                                                    'Exit',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                : null,
                        child: Text('Invoice Items'),
                      );
                    }),
                    Spacer(),
                    GetX<JobCardController>(
                      builder: (controller) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.addNewJobCardAndQuotation();
                          },
                          style: saveButtonStyle,
                          child: controller.addingNewValue.value == false
                              ? const Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                )
                              : SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: cancelButtonStyle,
                      child: const Text(
                        'Exit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New Card'),
  );
}
