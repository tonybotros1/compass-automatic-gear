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
      child: FocusTraversalGroup(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetX<ApInvoicesController>(
              builder: (controller) {
                bool isTransactionTypesLoading =
                    controller.allTransactionsTypes.isEmpty;
                return CustomDropdown(
                  focusNode: controller.focusNode1,
                  nextFocusNode: controller.focusNode2,
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
              },
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    focusNode: controller.focusNode2,
                    onEditingComplete: () {
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.focusNode3);
                    },
                    textInputAction: TextInputAction.next,
                    labelText: 'Amount',
                    isDouble: true,
                    controller: controller.amount,
                  ),
                ),
                Expanded(
                  child: myTextFormFieldWithBorder(
                    focusNode: controller.focusNode3,
                    onEditingComplete: () {
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.focusNode4);
                    },
                    textInputAction: TextInputAction.next,
                    labelText: 'VAT',
                    isDouble: true,
                    controller: controller.vat,
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
            // Row(
            //   spacing: 10,
            //   children: [
            //     Expanded(
            //       child: myTextFormFieldWithBorder(
            //           focusNode: controller.focusNode4,
            //           onEditingComplete: () {
            //             FocusScope.of(context)
            //                 .requestFocus(controller.focusNode5);
            //           },
            //           textInputAction: TextInputAction.next,
            //           labelText: 'Invoice Number',
            //           controller: controller.invoiceNumber),
            //     ),
            //     Expanded(
            //         child: myTextFormFieldWithBorder(
            //             focusNode: controller.focusNode5,
            //             onEditingComplete: () {
            //               FocusScope.of(context)
            //                   .requestFocus(controller.focusNode6);
            //             },
            //             isDate: true,
            //             suffixIcon: IconButton(
            //                 focusNode: FocusNode(skipTraversal: true),
            //                 onPressed: () {
            //                   selectDateContext(
            //                       context, controller.invoiceDate);
            //                 },
            //                 icon: const Icon(Icons.date_range)),
            //             controller: controller.invoiceDate,
            //             onFieldSubmitted: (_) {
            //               normalizeDate(controller.invoiceDate.value.text,
            //                   controller.invoiceDate);
            //             },
            //             labelText: 'Invoice Date')),
            //     Expanded(child: SizedBox())
            //   ],
            // ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Expanded(
            //       child: GetX<ApInvoicesController>(builder: (controller) {
            //         bool isVendorLoading = controller.allVendors.isEmpty;
            //         return CustomDropdown(
            //           focusNode: controller.focusNode6,
            //           nextFocusNode: controller.focusNode7,
            //           textcontroller: controller.vendorForInvoice.text,
            //           hintText: 'Vendor',
            //           showedSelectedName: 'entity_name',
            //           items: isVendorLoading ? {} : controller.allVendors,
            //           onChanged: (key, value) {
            //             controller.vendorForInvoice.text = value['entity_name'];
            //             controller.vendorForInvoiceId.value = key;
            //           },
            //         );
            //       }),
            //     ),
            //     addNewEntityButton()
            //   ],
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: myTextFormFieldWithBorder(
                    focusNode: controller.focusNode7,
                    onEditingComplete: () {
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.focusNode8);
                    },
                    labelText: 'Job Number',
                    controller: controller.jobNumber,
                  ),
                ),
                IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    controller.searchForJobCards.clear();
                    controller.getAllJobCards();
                    Get.dialog(
                      barrierDismissible: false,
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SizedBox(
                          width: constraints.maxWidth / 1.5,
                          height: 500,
                          child: Column(
                            children: [
                              // Header
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  color: mainColor,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Text(
                                      '💳 Job Cards',
                                      style:
                                          fontStyleForScreenNameUsedInButtons,
                                    ),
                                    const Spacer(),
                                    closeButton,
                                  ],
                                ),
                              ),
                              // Content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 10,
                                  ),
                                  child: GetX<ApInvoicesController>(
                                    builder: (controller) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Full-width Search Bar
                                          SizedBox(
                                            width: 400,
                                            height: 50,
                                            child: SearchBar(
                                              // elevation: WidgetStateProperty.all(0),
                                              trailing: [
                                                IconButton(
                                                  onPressed: () {
                                                    controller.searchForJobCards
                                                        .clear();
                                                    controller
                                                        .searchEngineForJobCards();
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                              leading: const Icon(
                                                Icons.search,
                                                color: Colors.grey,
                                              ),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              hintText: 'Search for jobs',
                                              hintStyle:
                                                  WidgetStateProperty.all(
                                                    const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                              controller:
                                                  controller.searchForJobCards,
                                              onChanged: (_) {
                                                controller
                                                    .searchEngineForJobCards();
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          // Full-width Scrollable Table
                                          Expanded(
                                            child:
                                                controller.loadingJobCards.value
                                                ? Center(child: loadingProcess)
                                                : controller
                                                          .loadingJobCards
                                                          .isFalse &&
                                                      controller
                                                          .allJobCards
                                                          .isEmpty
                                                ? const Center(
                                                    child: Text('No Data'),
                                                  )
                                                : SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                          minWidth:
                                                              constraints
                                                                      .maxWidth /
                                                                  1.5 -
                                                              20,
                                                        ),
                                                        child: DataTable(
                                                          showCheckboxColumn:
                                                              false,
                                                          horizontalMargin:
                                                              horizontalMarginForTable,
                                                          dataRowMaxHeight: 40,
                                                          dataRowMinHeight: 30,
                                                          columnSpacing: 5,
                                                          showBottomBorder:
                                                              true,
                                                          dataTextStyle:
                                                              regTextStyle,
                                                          headingTextStyle:
                                                              fontStyleForTableHeader,
                                                          headingRowColor:
                                                              WidgetStatePropertyAll(
                                                                Colors
                                                                    .grey[300],
                                                              ),
                                                          columns: [
                                                            DataColumn(
                                                              label: AutoSizedText(
                                                                constraints:
                                                                    constraints,
                                                                text:
                                                                    'Job Number',
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: AutoSizedText(
                                                                constraints:
                                                                    constraints,
                                                                text:
                                                                    'Car Brand',
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: AutoSizedText(
                                                                constraints:
                                                                    constraints,
                                                                text:
                                                                    'Plate Number',
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: AutoSizedText(
                                                                constraints:
                                                                    constraints,
                                                                text: 'VIN',
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: AutoSizedText(
                                                                constraints:
                                                                    constraints,
                                                                text:
                                                                    'Customer',
                                                              ),
                                                            ),
                                                          ],
                                                          rows:
                                                              (controller
                                                                      .filteredJobCards
                                                                      .isEmpty &&
                                                                  controller
                                                                      .searchForJobCards
                                                                      .value
                                                                      .text
                                                                      .isEmpty)
                                                              ? List<
                                                                  DataRow
                                                                >.generate(
                                                                  controller
                                                                      .allJobCards
                                                                      .length,
                                                                  (index) {
                                                                    final job =
                                                                        controller
                                                                            .allJobCards[index];
                                                                    final jobData =
                                                                        job.data()
                                                                            as Map<
                                                                              String,
                                                                              dynamic
                                                                            >;
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
                                                                  DataRow
                                                                >.generate(
                                                                  controller
                                                                      .filteredJobCards
                                                                      .length,
                                                                  (index) {
                                                                    final job =
                                                                        controller
                                                                            .filteredJobCards[index];
                                                                    final jobData =
                                                                        job.data()
                                                                            as Map<
                                                                              String,
                                                                              dynamic
                                                                            >;
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
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.more_vert_rounded, color: mainColor),
                ),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
            myTextFormFieldWithBorder(
              focusNode: controller.focusNode8,
              maxLines: 6,
              labelText: 'Note',
              controller: controller.invoiceNote,
            ),
          ],
        ),
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  Map<String, dynamic> jobData,
  context,
  constraints,
  jobId,
  ApInvoicesController controller,
  int index,
) {
  return DataRow(
    onSelectChanged: (_) {
      Get.back();
      controller.jobNumber.text = jobData['job_number'];
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      // Alternate row colors
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(Text(jobData['job_number'] ?? '')),
      DataCell(Text((getdataName(jobData['car_brand'], controller.allBrands)))),
      DataCell(Text(jobData['plate_number'] ?? '')),
      DataCell(Text(jobData['vehicle_identification_number'] ?? '')),
      DataCell(
        Text(
          getdataName(
            jobData['customer'],
            controller.allCustomers,
            title: 'entity_name',
          ),
        ),
      ),
    ],
  );
}
