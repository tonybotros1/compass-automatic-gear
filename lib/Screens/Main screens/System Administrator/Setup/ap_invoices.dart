import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/ap_invoices_controller.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/ap_invoices_widgets/ap_invoice_dialog.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class ApInvoices extends StatelessWidget {
  const ApInvoices({super.key});

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
                  GetX<ApInvoicesController>(
                      init: ApInvoicesController(),
                      builder: (controller) {
                        bool isInvoiceTypesLoading =
                            controller.allInvoiceTypes.isEmpty;
                        bool isVendorsLoading = controller.allVendors.isEmpty;
                        return Row(
                          children: [
                            Expanded(
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: CustomDropdown(
                                      textcontroller:
                                          controller.invoiceTypeFilter.text,
                                      showedSelectedName: 'name',
                                      hintText: 'Invoice Type',
                                      items: isInvoiceTypesLoading
                                          ? {}
                                          : controller.allInvoiceTypes,
                                      onChanged: (key, value) {
                                        controller.invoiceTypeFilter.text =
                                            value['name'];
                                        controller.invoiceTypeFilterId.value =
                                            key;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      child: myTextFormFieldWithBorder(
                                    labelText: 'Reference NO.',
                                    controller:
                                        controller.referenceNumberFilter,
                                  )),
                                  Expanded(
                                    flex: 2,
                                    child: CustomDropdown(
                                      textcontroller:
                                          controller.vendorFilter.value.text,
                                      showedSelectedName: 'entity_name',
                                      hintText: 'Beneficiary',
                                      items: isVendorsLoading
                                          ? {}
                                          : controller.allVendors,
                                      onChanged: (key, value) async {
                                        controller.vendorFilter.value.text =
                                            key;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomDropdown(
                                      textcontroller:
                                          controller.statusFilter.value.text,
                                      showedSelectedName: 'name',
                                      hintText: 'Status',
                                      items: controller.allStatus,
                                      onChanged: (key, value) async {
                                        controller.statusFilter.value.text =
                                            value['name'];
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: SizedBox())
                          ],
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  GetBuilder<ApInvoicesController>(builder: (controller) {
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
                                    // controller.carBrand.clear();
                                    // controller.carModel.clear();
                                    // controller.carBrandId.value = '';
                                    // controller.carModelId.value = '';
                                    // controller.allModels.clear();
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
                        newInvoiceButton(context, constraints, controller)
                      ],
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  GetX<ApInvoicesController>(builder: (controller) {
                    return Container(
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          controller.isScreenLoding.value
                              ? Center(
                                  child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: loadingProcess,
                                ))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    width: constraints.maxWidth,
                                    child: tableOfScreens(
                                        scrollController: controller
                                            .scrollControllerFotTable1,
                                        constraints: constraints,
                                        context: context,
                                        controller: controller,
                                        data: controller.allApInvoices.isEmpty
                                            ? RxList()
                                            : controller.allApInvoices),
                                  ),
                                ),
                        ],
                      ),
                    );
                  }),
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
    required RxList<DocumentSnapshot> data,
    required ScrollController scrollController,
    required ApInvoicesController controller}) {
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
        horizontalMargin: horizontalMarginForTable,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        columnSpacing: 15,
        // showBottomBorder: true,
        // dataTextStyle: regTextStyle,
        // headingTextStyle: fontStyleForTableHeader,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          DataColumn(label: SizedBox()),
          DataColumn(
            label: AutoSizedText(
              text: 'Invoice Type',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              text: 'Status',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Reference No.',
            ),
            // onSort: controller.onS ort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Transaction Date',
            ),
            // onSort: controller.onS ort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Beneficiary',
            ),
            // onSort: controller.onS ort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Note',
            ),
            // onSort: controller.onS ort,
          ),
        ],
        source: dataSource,
      ),
    ),
  );
  // rows: controller.allApInvoices.map<DataRow>((type) {
  //   final typeData = type.data() as Map<String, dynamic>;
  //   final typeId = type.id;
  //   return dataRowForTheTable(
  //       typeData, context, constraints, typeId, controller);
  // }).toList());
}

DataRow dataRowForTheTable(Map<String, dynamic> typeData, context, constraints,
    typeId, ApInvoicesController controller, int index) {
  return DataRow(cells: [
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        editSection(context, controller, typeData, constraints, typeId),
      ],
    )),
    DataCell(textForDataRowInTable(
      text: getdataName(typeData['invoice_type'] ?? '', controller.allInvoiceTypes),
    )),
    DataCell(
      statusBox(
        typeData['status'],
        hieght: 35,
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 5),
      ),
    ),
    DataCell(textForDataRowInTable(
      text: typeData['reference_number'] ?? '',
    )),
    DataCell(
      textForDataRowInTable(
        text: typeData['transaction_date'] != null &&
                typeData['transaction_date'] != ''
            ? textToDate(typeData['transaction_date'])
            : 'N/A',
      ),
    ),
    DataCell(textForDataRowInTable(
      text: getdataName(typeData['beneficiary'], controller.allVendors,
          title: 'entity_name'),
    )),
    DataCell(textForDataRowInTable(
      formatDouble: false,
      text: typeData['note'] ?? '',
    )),
  ]);
}

Widget editSection(context, ApInvoicesController controller,
    Map<String, dynamic> typeData, constraints, typeId) {
  return IconButton(
    tooltip: 'Edit',
    onPressed: () async {
      await controller.loadValues(typeId, typeData);
      apInvoiceDialog(
          id: typeId,
          context: context,
          constraints: constraints,
          controller: controller,
          canEdit: true,
          onPressedForDelete: null,
          onPressedForCancel: controller.cancellingapInvoice.isFalse
              ? () {
                  if (controller.status.value != 'Cancelled' &&
                      controller.status.value.isNotEmpty) {
                    controller.editCancelForApInvoices(typeId);
                  } else if (controller.status.value == 'Cancelled') {
                    showSnackBar('Alert', 'Quotation Already Cancelled');
                  } else if (controller.status.value.isEmpty) {
                    showSnackBar('Alert', 'Please Save The Quotation First');
                  }
                }
              : null,
          onPressedForPost: controller.postingapInvoice.isFalse
              ? () {
                  if (controller.status.value != 'Posted' &&
                      controller.status.value != 'Cancelled' &&
                      controller.status.value.isNotEmpty) {
                    controller.editPostForApInvoices(typeId);
                  } else if (controller.status.value == 'Posted') {
                    showSnackBar('Alert', 'Quotation is Already Posted');
                  } else if (controller.status.value == 'Cancelled') {
                    showSnackBar('Alert', 'Quotation is Cancelled');
                  } else if (controller.status.value.isEmpty) {
                    showSnackBar('Alert', 'Please Save The Quotation First');
                  }
                }
              : null,
          onPressedForSave: controller.addingNewValue.value
              ? null
              : () {
                  controller.editApInvoice(typeId);
                });
    },
    icon: const Icon(
      Icons.edit_note_rounded,
      color: Colors.blue,
    ),
  );
}

ElevatedButton newInvoiceButton(BuildContext context,
    BoxConstraints constraints, ApInvoicesController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.invoiceType.clear();
      controller.invoiceTypeId.value = '';
      controller.referenceNumber.clear();
      controller.transactionDate.clear();
      controller.vendor.clear();
      controller.vendorId.value = '';
      controller.note.clear();
      controller.allInvoices.clear();
      controller.status.value = '';
      controller.canAddInvoice.value = false;
      apInvoiceDialog(
          onPressedForCancel: null,
          id: controller.currentApInvoiceId.value,
          constraints: constraints,
          controller: controller,
          canEdit: true,
          onPressedForSave: controller.addingNewValue.value
              ? null
              : () async {
                  await controller.addNewApInvoice();
                },
          onPressedForDelete: null,
          onPressedForPost: controller.postingapInvoice.isFalse
              ? () {
                  if (controller.status.value != 'Posted' &&
                      controller.status.value != 'Cancelled' &&
                      controller.status.value.isNotEmpty) {
                    controller.editPostForApInvoices(
                        controller.currentApInvoiceId.value);
                  } else if (controller.status.value == 'Posted') {
                    showSnackBar('Alert', 'Quotation is Already Posted');
                  } else if (controller.status.value == 'Cancelled') {
                    showSnackBar('Alert', 'Quotation is Cancelled');
                  } else if (controller.status.value.isEmpty) {
                    showSnackBar('Alert', 'Please Save The Quotation First');
                  }
                }
              : null,
          context: context);
    },
    style: newButtonStyle,
    child: const Text('New Invoice'),
  );
}

class CardDataSource extends DataTableSource {
  final List<DocumentSnapshot> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final ApInvoicesController controller;

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
