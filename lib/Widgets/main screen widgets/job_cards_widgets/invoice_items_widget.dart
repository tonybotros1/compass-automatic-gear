import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';
import 'add_new_invoice_item_or_edit.dart';

Widget invoiceItemsDialog(
    {required BuildContext context, required BoxConstraints constraints, required jobId}) {
  return Container(
    width: constraints.maxWidth,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        GetX<JobCardController>(
          builder: (controller) {
            return searchBar(
              search: controller.searchForInvoiceItems,
              constraints: constraints,
              context: context,
              controller: controller,
              title: 'Search for invoices',
              button: newinvoiceItemsButton(context, constraints, controller),
            );
          },
        ),
        Expanded(
          child: GetX<JobCardController>(
            builder: (controller) {
              if (controller.loadingInvoiceItems.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.allInvoiceItems.isEmpty) {
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
  );
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
          constraints: constraints,
          text: 'Code',
        ),
        onSort: controller.onSortForInvoiceItems,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Name',
        ),
        onSort: controller.onSortForInvoiceItems,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSortForInvoiceItems,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
    ],
    rows: controller.filteredInvoiceItems.isEmpty &&
            controller.searchForInvoiceItems.value.text.isEmpty
        ? controller.allInvoiceItems.map<DataRow>((invoiceItems) {
            final invoiceItemsData =
                invoiceItems.data() as Map<String, dynamic>;
            final invoiceItemsId = invoiceItems.id;
            return dataRowForTheTable(invoiceItemsData, context, constraints,
                invoiceItemsId, controller);
          }).toList()
        : controller.filteredInvoiceItems.map<DataRow>((invoiceItems) {
            final invoiceItemsData =
                invoiceItems.data() as Map<String, dynamic>;
            final invoiceItemsId = invoiceItems.id;
            return dataRowForTheTable(invoiceItemsData, context, constraints,
                invoiceItemsId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> invoiceItemsData, context,
    constraints, String invoiceItemsId, JobCardController controller) {
  return DataRow(cells: [
    DataCell(
      Text(
        invoiceItemsData['code'] ?? 'no code',
      ),
    ),
    DataCell(
      Text(
        invoiceItemsData['name'] ?? 'no invoiceItems',
      ),
    ),
    DataCell(
      Text(
        invoiceItemsData['added_date'] != null
            ? textToDate(invoiceItemsData['added_date'])
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        editSection(
            controller, invoiceItemsData, context, constraints, invoiceItemsId),
        deleteSection(context, controller, invoiceItemsId),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    context, JobCardController controller, invoiceItemsId) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: 'The invoiceItems will be deleted permanently',
            onPressed: () {
              // controller.deleteinvoiceItems(
              //     controller.countryIdToWorkWith.value, invoiceItemsId);
            });
      },
      child: const Text('Delete'));
}

ElevatedButton editSection(
    JobCardController controller,
    Map<String, dynamic> invoiceItemsData,
    context,
    constraints,
    String invoiceItemsId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        // controller.invoiceItemsName.text = invoiceItemsData['name'];
        // controller.invoiceItemsCode.text = invoiceItemsData['code'];
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addNewinvoiceItemsOrEdit(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  // isEnabled: false,
                ),
                actions: [
                  GetX<JobCardController>(
                      builder: (controller) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed:
                                  controller.addingNewinvoiceItemsValue.value
                                      ? null
                                      : () async {
                                          // if (!controller.formKeyForAddingNewvalue
                                          //     .currentState!
                                          //     .validate()) {
                                          // } else {
                                          //   controller.editinvoiceItems(
                                          //       controller
                                          //           .countryIdToWorkWith.value,
                                          //       invoiceItemsId);
                                          // }
                                        },
                              style: saveButtonStyle,
                              child:
                                  controller.addingNewinvoiceItemsValue.value ==
                                          false
                                      ? const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
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
                          )),
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
              );
            });
      },
      child: Text('Edit'));
}

ElevatedButton newinvoiceItemsButton(BuildContext context,
    BoxConstraints constraints, JobCardController controller) {
  return ElevatedButton(
    onPressed: () {
      // controller.invoiceItemsName.clear();
      // controller.invoiceItemsCode.clear();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewinvoiceItemsOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
                // isEnabled: true,
              ),
              actions: [
                GetX<JobCardController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed:
                                controller.addingNewinvoiceItemsValue.value
                                    ? null
                                    : () async {
                                        // if (!controller
                                        //     .formKeyForAddingNewvalue.currentState!
                                        //     .validate()) {
                                        // } else {
                                        //   await controller.addNewinvoiceItems(
                                        //       controller.countryIdToWorkWith.value);
                                        // }
                                      },
                            style: saveButtonStyle,
                            child:
                                controller.addingNewinvoiceItemsValue.value ==
                                        false
                                    ? const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
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
                        )),
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
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New invoice'),
  );
}
