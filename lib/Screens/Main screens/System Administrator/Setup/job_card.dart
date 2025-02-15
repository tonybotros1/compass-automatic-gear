import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/add_new_job_card_or_edit.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/internal_notes_widget.dart';
import '../../../../Widgets/main screen widgets/job_cards_widgets/invoice_items_widget.dart';
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
            child: Container(
              width: constraints.maxWidth,
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
                        button:
                            newJobCardButton(context, constraints, controller),
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
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
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
          );
        },
      ),
    );
  }
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required JobCardController controller}) {
  return DataTable(
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
          text: 'Job No.',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Job Date',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'LPO No.',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Car Brand',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Plate No.',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Code',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'City',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Customer Name',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Invoice No.',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Inv Date',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
    ],
    rows: controller.filteredJobCards.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allJobCards.map<DataRow>((job) {
            final jobData = job.data() as Map<String, dynamic>;
            final jobId = job.id;
            return dataRowForTheTable(
                jobData, context, constraints, jobId, controller);
          }).toList()
        : controller.filteredJobCards.map<DataRow>((job) {
            final jobData = job.data() as Map<String, dynamic>;
            final jobId = job.id;
            return dataRowForTheTable(
                jobData, context, constraints, jobId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> jobData, context, constraints,
    jobId, JobCardController controller) {
  return DataRow(cells: [
    DataCell(textForDataRowInTable(text: '${jobData['job_number']}')),
    DataCell(textForDataRowInTable(text: '${textToDate(jobData['job_date'])}')),
    DataCell(textForDataRowInTable(text: '${jobData['lpo_number']}')),
    DataCell(textForDataRowInTable(
        text:
            '${controller.getdataName(jobData['car_brand'], controller.allBrands)}')),
    DataCell(
      Text(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        '${jobData['plate_number']}',
      ),
    ),
    DataCell(textForDataRowInTable(text: '${jobData['plate_code']}')),
    DataCell(
      FutureBuilder<String>(
        future: controller.getCityName(jobData['country'], jobData['city']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return textForDataRowInTable(text: '${snapshot.data}');
          }
        },
      ),
    ),
    DataCell(textForDataRowInTable(
        text:
            '${controller.getdataName(jobData['customer'], controller.allCustomers, title: 'entity_name')}')),
    DataCell(textForDataRowInTable(text: '${jobData['invoice_number']}')),
    DataCell(
        textForDataRowInTable(text: '${textToDate(jobData['invoice_date'])}')),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        editSection(context, controller, jobData, constraints, jobId),
      ],
    )),
  ]);
}

ElevatedButton editSection(context, JobCardController controller,
    Map<String, dynamic> jobData, constraints, jobId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.loadValues(jobData);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewJobCardOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                ),
                actions: [
                  Row(
                    spacing: 10,
                    children: [
                      ElevatedButton(
                        style: internalNotesButtonStyle,
                        onPressed: () async {
                          internalNotesDialog(controller, constraints, jobId);
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
                                  actionsPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  content: invoiceItemsDialog(
                                      constraints: constraints,
                                      context: context,
                                      jobId: jobId),
                                  actions: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: cancelButtonStyle,
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text('Invoice Items'),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: controller.addingNewValue.value
                              ? null
                              : () {
                                  controller.editJobCardAndQuotation(jobId);
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
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
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
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ],
              );
            });
      },
      child: const Text('Edit'));
}

ElevatedButton newJobCardButton(BuildContext context,
    BoxConstraints constraints, JobCardController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.country.text = controller.getdataName(
          controller.companyDetails['contact_details']['country'],
          controller.allCountries)!;
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
      controller.jobCardDate.value.text = DateTime.now().toString();
      controller.invoiceDate.value.text = DateTime.now().toString();
      controller.startDate.value.text = DateTime.now().toString();
      controller.clearValues();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                    ElevatedButton(
                      style: innvoiceItemsButtonStyle,
                      onPressed: controller
                              .canAddInternalNotesAndInvoiceItems.isTrue
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
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            style: cancelButtonStyle,
                                            child: const Text(
                                              'Cancel',
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
                    ),
                    Spacer(),
                    GetX<JobCardController>(
                      builder: (controller) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: controller.canSaveJobCard.isTrue
                              ? controller.addingNewValue.value
                                  ? null
                                  : () async {
                                      await controller
                                          .addNewJobCardAndQuotation();
                                    }
                              : null,
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
                        'Cancel',
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
