import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auto_size_box.dart';

Widget addNewinvoiceForApInvoicesOrEdit({
  required ApInvoicesController controller,
  required BuildContext context,
  required BoxConstraints constraints,
}) {
  return SingleChildScrollView(
    child: SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetX<ApInvoicesController>(builder: (controller) {
                  bool isTransactionTypesLoading =
                      controller.allTransactionsTypes.isEmpty;
                  return CustomDropdown(
                    showedSelectedName: 'type',
                    textcontroller: controller.transactionType.text,
                    hintText: 'Transaction Type',
                    items: isTransactionTypesLoading
                        ? {}
                        : controller.allTransactionsTypes,
                    onChanged: (key, value) {
                      controller.transactionType.text = value['type'];
                      controller.transactionTypeId.value = key;
                    },
                  );
                }),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: myTextFormFieldWithBorder(
                          labelText: 'Amount',
                          isDouble: true,
                          controller: controller.amount),
                    ),
                    Expanded(
                      child: myTextFormFieldWithBorder(
                          labelText: 'VAT',
                          isDouble: true,
                          controller: controller.vat),
                    ),
                    Expanded(child: SizedBox())
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: myTextFormFieldWithBorder(
                          labelText: 'Invoice Number',
                          controller: controller.invoiceNumber),
                    ),
                    Expanded(
                        child: myTextFormFieldWithBorder(
                            isDate: true,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  selectDateContext(
                                      context, controller.invoiceDate);
                                },
                                icon: const Icon(Icons.date_range)),
                            controller: controller.invoiceDate,
                            onFieldSubmitted: (_) {
                              normalizeDate(controller.invoiceDate.value.text,
                                  controller.invoiceDate);
                            },
                            labelText: 'Invoice Date')),
                    Expanded(child: SizedBox())
                  ],
                ),
                GetX<ApInvoicesController>(builder: (controller) {
                  bool isVendorLoading = controller.allVendors.isEmpty;
                  return CustomDropdown(
                    textcontroller: controller.vendorForInvoice.text,
                    hintText: 'Vendor',
                    showedSelectedName: 'entity_name',
                    items: isVendorLoading ? {} : controller.allVendors,
                    onChanged: (key, value) {
                      controller.vendorForInvoice.text = value['entity_name'];
                      controller.vendorForInvoiceId.value = key;
                    },
                  );
                }),
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: myTextFormFieldWithBorder(
                            labelText: 'Job Number',
                            controller: controller.jobNumber)),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              controller.searchForJobCards.clear();
                              controller.getAllJobCards();
                              Get.dialog(
                                  barrierDismissible: false,
                                  Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: SizedBox(
                                      width: constraints.maxWidth / 1.5,
                                      height: 500,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15)),
                                              color: mainColor,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              spacing: 10,
                                              children: [
                                                Text(
                                                  '💳 Job Cards',
                                                  style:
                                                      fontStyleForScreenNameUsedInButtons,
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  height: 50,
                                                  child: SearchBar(
                                                    shape:
                                                        WidgetStateProperty.all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    hintText: 'Search...',
                                                    controller: controller
                                                        .searchForJobCards,
                                                    onChanged: (_) {
                                                      controller
                                                          .searchEngineForJobCards();
                                                    },
                                                  ),
                                                ),
                                                const Spacer(),
                                                closeButton
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding:
                                                EdgeInsetsGeometry.symmetric(
                                                    vertical: 16),
                                            child: GetX<ApInvoicesController>(
                                                builder: (controller) {
                                              return SingleChildScrollView(
                                                child: SizedBox(
                                                  width: constraints.maxWidth /
                                                      1.5,
                                                  child: controller
                                                          .loadingJobCards.value
                                                      ? Center(
                                                          child: loadingProcess)
                                                      : controller.loadingJobCards
                                                                  .isFalse &&
                                                              controller
                                                                  .allJobCards
                                                                  .isEmpty
                                                          ? Center(
                                                              child: Text(
                                                                  'No Data'),
                                                            )
                                                          : DataTable(
                                                              showCheckboxColumn:
                                                                  false,
                                                              horizontalMargin:
                                                                  horizontalMarginForTable,
                                                              dataRowMaxHeight:
                                                                  40,
                                                              dataRowMinHeight:
                                                                  30,
                                                              columnSpacing: 5,
                                                              showBottomBorder:
                                                                  true,
                                                              dataTextStyle:
                                                                  regTextStyle,
                                                              headingTextStyle:
                                                                  fontStyleForTableHeader,
                                                              headingRowColor:
                                                                  WidgetStatePropertyAll(
                                                                      Colors.grey[
                                                                          300]),
                                                              columns: [
                                                                DataColumn(
                                                                    label:
                                                                        AutoSizedText(
                                                                  constraints:
                                                                      constraints,
                                                                  text:
                                                                      'Job Number',
                                                                )),
                                                                DataColumn(
                                                                    label:
                                                                        AutoSizedText(
                                                                  constraints:
                                                                      constraints,
                                                                  text:
                                                                      'Car Brand',
                                                                )),
                                                                DataColumn(
                                                                    label:
                                                                        AutoSizedText(
                                                                  constraints:
                                                                      constraints,
                                                                  text:
                                                                      'Plate Number',
                                                                )),
                                                                DataColumn(
                                                                    label:
                                                                        AutoSizedText(
                                                                  constraints:
                                                                      constraints,
                                                                  text: 'VIN',
                                                                )),
                                                                DataColumn(
                                                                    label:
                                                                        AutoSizedText(
                                                                  constraints:
                                                                      constraints,
                                                                  text:
                                                                      'Customer',
                                                                )),
                                                              ],
                                                              rows: controller
                                                                          .filteredJobCards
                                                                          .isEmpty &&
                                                                      controller
                                                                          .searchForJobCards
                                                                          .value
                                                                          .text
                                                                          .isEmpty
                                                                  ? List<
                                                                      DataRow>.generate(
                                                                      controller
                                                                          .allJobCards
                                                                          .length,
                                                                      (index) {
                                                                        final job =
                                                                            controller.allJobCards[index];
                                                                        final jobData = job.data() as Map<
                                                                            String,
                                                                            dynamic>;
                                                                        final jobId =
                                                                            job.id;

                                                                        return dataRowForTheTable(
                                                                          jobData,
                                                                          context,
                                                                          constraints,
                                                                          jobId,
                                                                          controller,
                                                                          index,
                                                                        );
                                                                      },
                                                                    )
                                                                  : List<
                                                                      DataRow>.generate(
                                                                      controller
                                                                          .filteredJobCards
                                                                          .length,
                                                                      (index) {
                                                                        final job =
                                                                            controller.filteredJobCards[index];
                                                                        final jobData = job.data() as Map<
                                                                            String,
                                                                            dynamic>;
                                                                        final jobId =
                                                                            job.id;

                                                                        return dataRowForTheTable(
                                                                          jobData,
                                                                          context,
                                                                          constraints,
                                                                          jobId,
                                                                          controller,
                                                                          index,
                                                                        );
                                                                      },
                                                                    ),
                                                            ),
                                                ),
                                              );
                                            }),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                            child: Text(
                              'Select Job',
                              style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold),
                            ))),
                    Expanded(flex: 1, child: SizedBox())
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: myTextFormFieldWithBorder(
                  maxLines: 10,
                  labelText: 'Note',
                  controller: controller.invoiceNote))
        ],
      ),
    ),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> jobData, context, constraints,
    jobId, ApInvoicesController controller, int index) {
  return DataRow(
      onSelectChanged: (_) {
        Get.back();
        controller.jobNumber.text = jobData['job_number'];
      },
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          // Alternate row colors
          return index % 2 == 0 ? Colors.grey[200] : Colors.white;
        },
      ),
      cells: [
        DataCell(Text(
          jobData['job_number'] ?? '',
        )),
        DataCell(Text(
          (getdataName(jobData['car_brand'], controller.allBrands)),
        )),
        DataCell(Text(
          jobData['plate_number'] ?? '',
        )),
        DataCell(Text(
          jobData['vehicle_identification_number'] ?? '',
        )),
        DataCell(Text(
          getdataName(jobData['customer'], controller.allCustomers,
              title: 'entity_name'),
        )),
      ]);
}
