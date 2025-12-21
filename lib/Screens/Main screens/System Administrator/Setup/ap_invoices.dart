import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/ap_invoices_controller.dart';
import '../../../../Models/ar receipts and ap payments/ap_invoices_model.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
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
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth - 28,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 10,
                            children: [
                              Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomDropdown(
                                    width: 150,
                                    textcontroller:
                                        controller.invoiceTypeFilter.text,
                                    showedSelectedName: 'name',
                                    hintText: 'Invoice Type',
                                    onChanged: (key, value) {
                                      controller.invoiceTypeFilter.text =
                                          value['name'];
                                      controller.invoiceTypeFilterId.value =
                                          key;
                                    },
                                    onDelete: () {
                                      controller.invoiceTypeFilter.clear();
                                      controller.invoiceTypeFilterId.value = '';
                                    },
                                    onOpen: () {
                                      return controller.getInvoiceTypes();
                                    },
                                  ),
                                  myTextFormFieldWithBorder(
                                    width: 150,
                                    labelText: 'Reference NO.',
                                    controller:
                                        controller.referenceNumberFilter,
                                  ),
                                  CustomDropdown(
                                    width: 300,
                                    textcontroller:
                                        controller.vendorFilter.value.text,
                                    showedSelectedName: 'entity_name',
                                    hintText: 'Vendor',
                                    onChanged: (key, value) async {
                                      controller.vendorFilter.value.text =
                                          value['entity_name'];
                                      controller.vendorFilterId.value = key;
                                    },
                                    onDelete: () {
                                      controller.vendorFilter.value.clear();
                                      controller.vendorFilterId.value = '';
                                    },
                                    onOpen: () {
                                      return controller.getAllVendors();
                                    },
                                  ),
                                  CustomDropdown(
                                    width: 200,
                                    textcontroller:
                                        controller.statusFilter.value.text,
                                    showedSelectedName: 'name',
                                    hintText: 'Status',
                                    items: allStatus,
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
                              Row(
                                spacing: 10,
                                children: [
                                  myTextFormFieldWithBorder(
                                    width: 120,
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
                                    width: 120,
                                    controller: controller.toDate.value,
                                    labelText: 'To Date',
                                    onFieldSubmitted: (_) async {
                                      normalizeDate(
                                        controller.toDate.value.text,
                                        controller.toDate.value,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  GetX<ApInvoicesController>(
                    builder: (controller) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth - 28,
                          ),
                          child: Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  newInvoiceButton(
                                    context,
                                    constraints,
                                    controller,
                                  ),

                                  CustomSlidingSegmentedControl<int>(
                                    height: 30,
                                    initialValue: 1,
                                    children: const {
                                      1: Text('ALL'),
                                      2: Text('TODAY'),
                                      3: Text('THIS MONTH'),
                                      4: Text('THIS YEAR'),
                                    },
                                    decoration: BoxDecoration(
                                      color:
                                          CupertinoColors.lightBackgroundGray,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    thumbDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(1),
                                          blurRadius: 4.0,
                                          spreadRadius: 1.0,
                                          offset: const Offset(0.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInToLinear,
                                    onValueChanged: (v) {
                                      controller.onChooseForDatePicker(v);
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  ElevatedButton(
                                    style: findButtonStyle,
                                    onPressed: controller.isScreenLoding.isFalse
                                        ? () {
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
                                    },
                                    child: Text(
                                      'Clear',
                                      style: fontStyleForElevatedButtons,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  GetX<ApInvoicesController>(
                    builder: (controller) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              spacing: 10,
                              children: [
                                customBox(
                                  title: 'NUMBER OF RECEIPTS',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: mainColor,
                                    isBold: true,
                                    text:
                                        '${controller.numberOfAPInvoices.value}',
                                    formatDouble: false,
                                  ),
                                ),
                                customBox(
                                  title: 'AMOUNT',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.green,
                                    isBold: true,
                                    text:
                                        '${controller.totalAmountForAPInvoices.value}',
                                  ),
                                ),
                                customBox(
                                  title: 'VAT',
                                  value: textForDataRowInTable(
                                    fontSize: 16,
                                    color: Colors.red,
                                    isBold: true,
                                    text:
                                        '${controller.totalVATForAPInvoices.value}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  GetX<ApInvoicesController>(
                    builder: (controller) {
                      return Container(
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: tableOfScreens(
                                  scrollController:
                                      controller.scrollControllerFotTable1,
                                  constraints: constraints,
                                  context: context,
                                  controller: controller,
                                  data: controller.allApInvoices.isEmpty
                                      ? RxList()
                                      : controller.allApInvoices,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
  required RxList<ApInvoicesModel> data,
  required ScrollController scrollController,
  required ApInvoicesController controller,
}) {
  bool isAPInvoicesLoading = data.isEmpty;

  return DataTableTheme(
    data: DataTableThemeData(
      // headingTextStyle: fontStyleForTableHeader,
      // dataTextStyle: regTextStyle,
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
        horizontalMargin: horizontalMarginForTable,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        columnSpacing: 15,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        // headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          const DataColumn(label: SizedBox()),
          DataColumn(
            label: AutoSizedText(
              text: 'Invoice Type',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(text: 'Status', constraints: constraints),
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
            label: AutoSizedText(constraints: constraints, text: 'Vendor'),
            // onSort: controller.onS ort,
          ),
          DataColumn(
            label: AutoSizedText(constraints: constraints, text: 'Description'),
            // onSort: controller.onS ort,
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Amount'),
            // onSort: controller.onS ort,
          ),
          DataColumn(
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'VAT'),
            // onSort: controller.onS ort,
          ),
        ],
        source: CardDataSource(
          cards: isAPInvoicesLoading ? [] : data,
          context: context,
          constraints: constraints,
          controller: controller,
        ),
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  ApInvoicesModel typeData,
  context,
  constraints,
  typeId,
  ApInvoicesController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            editSection(context, controller, typeData, constraints, typeId),
          ],
        ),
      ),
      DataCell(textForDataRowInTable(text: typeData.invoiceTypeName ?? '')),
      DataCell(
        statusBox(
          typeData.status ?? '',
          hieght: 35,
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),
      DataCell(textForDataRowInTable(text: typeData.referenceNumber ?? '')),
      DataCell(
        textForDataRowInTable(text: textToDate(typeData.transactionDate)),
      ),
      DataCell(textForDataRowInTable(text: typeData.vendorName ?? '')),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: typeData.description ?? '',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: true,
          text: typeData.totalAmount.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: true,
          text: typeData.totalVat.toString(),
          color: Colors.red,
          isBold: true,
        ),
      ),
    ],
  );
}

Widget editSection(
  BuildContext context,
  ApInvoicesController controller,
  ApInvoicesModel typeData,
  constraints,
  typeId,
) {
  return IconButton(
    tooltip: 'Edit',
    onPressed: () async {
      await controller.loadValues(typeData);
      apInvoiceDialog(
        id: typeId,
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressedForDelete: controller.deletingapInvoice.isTrue
            ? null
            : () {
                if (controller.status.value != 'New') {
                  showSnackBar('Alert', 'Only New AP Invoices Can be Deleted');
                } else {
                  alertDialog(
                    context: context,
                    content: 'This will be deleted permanently',
                    onPressed: () {
                      controller.deleteAPInvoice(typeId);
                    },
                  );
                }
              },
        onPressedForCancel: controller.cancellingapInvoice.isFalse
            ? () {
                if (controller.status.value != 'Cancelled' &&
                    controller.status.value.isNotEmpty) {
                  controller.editCancelForApInvoices(typeId);
                } else if (controller.status.value == 'Cancelled') {
                  showSnackBar('Alert', 'AP Invoice Already Cancelled');
                } else if (controller.status.value.isEmpty) {
                  showSnackBar('Alert', 'Please Save The AP Invoice First');
                }
              }
            : null,
        onPressedForPost: () {
          controller.editPostForApInvoices(typeId);
        },
        onPressedForSave: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewApInvoice();
              },
      );
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}

ElevatedButton newInvoiceButton(
  BuildContext context,
  BoxConstraints constraints,
  ApInvoicesController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      apInvoiceDialog(
        onPressedForCancel: null,
        id: controller.currentApInvoiceId.value,
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressedForSave: controller.addingNewValue.isTrue
            ? null
            : () async {
                await controller.addNewApInvoice();
              },
        onPressedForDelete: null,
        onPressedForPost: () {
          controller.editPostForApInvoices(controller.currentApInvoiceId.value);
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Invoice'),
  );
}

class CardDataSource extends DataTableSource {
  final List<ApInvoicesModel> cards;
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

    final invoice = cards[index];
    final invoiceId = invoice.id;

    return dataRowForTheTable(
      invoice,
      context,
      constraints,
      invoiceId,
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
