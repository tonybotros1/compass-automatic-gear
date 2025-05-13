import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/cash_management_widgets/receipt_dialog.dart';
import '../../../../consts.dart';

class CashManagement extends StatelessWidget {
  const CashManagement({super.key});

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
                  GetX<CashManagementController>(
                    init: CashManagementController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        // controller: controller,
                        title: 'Search for cashes',
                        button:
                            newReceiptButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CashManagementController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value &&
                            controller.allCashsManagements.isEmpty) {
                          return Center(
                            child: loadingProcess,
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
                                data: controller
                                            .filteredCashsManagements.isEmpty &&
                                        controller.search.value.text.isEmpty
                                    ? controller.allCashsManagements
                                    : controller.filteredCashsManagements,
                                scrollController: controller.scrollController),
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

Widget tableOfScreens({
  required constraints,
  required context,
  required CashManagementController controller,
  required RxList<DocumentSnapshot> data,
  required ScrollController scrollController,
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
        showFirstLastButtons: true,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        columnSpacing: 5,
        rowsPerPage: 5,
        horizontalMargin: horizontalMarginForTable,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          DataColumn(label: SizedBox()
              // onSort: controller.onSort,
              ),
          DataColumn(
            label: AutoSizedText(
              text: 'Receipt Number',
              constraints: constraints,
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Status',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Date',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Customer Name',
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Receipt Type',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Account',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Bank Name',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Cheque Number',
            ),
          ),
          DataColumn(
            label: AutoSizedText(
              constraints: constraints,
              text: 'Date',
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.end,
            label: AutoSizedText(
              constraints: constraints,
              text: 'Received',
            ),
            // onSort: controller.onSort,
          ),
        ],
        source: dataSource,
      ),
    ),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> cashManagementData,
    context,
    constraints,
    cashManagementId,
    CashManagementController controller,
    int index) {
  return DataRow(cells: [
    DataCell(editSection(context, controller, cashManagementData, constraints,
        cashManagementId)),
    DataCell(Text(
      cashManagementData['receipt_number'] ?? '',
    )),
    DataCell(cashManagementData['status'] != ''
        ? statusBox(cashManagementData['status'],
            width: 60, padding: EdgeInsets.all(0))
        : SizedBox()),
    DataCell(Text(
      cashManagementData['receipt_date'] != null &&
              cashManagementData['receipt_date'] != ''
          ? textToDate(cashManagementData['receipt_date']) //
          : 'N/A',
    )),
    DataCell(
      Text(getdataName(cashManagementData['customer'], controller.allCustomers,
          title: 'entity_name')),
    ),
    DataCell(
      Text(getdataName(
        cashManagementData['receipt_type'],
        controller.allReceiptTypes,
      )),
    ),
    DataCell(
      Text(getdataName(cashManagementData['account'], controller.allAccounts,
          title: 'account_number')),
    ),
    DataCell(
      Text(getdataName(
        cashManagementData['bank_name'],
        controller.allBanks,
      )),
    ),
    DataCell(
      Text(cashManagementData['cheque_number']),
    ),
    DataCell(Text(
      cashManagementData['cheque_date'] != null &&
              cashManagementData['cheque_date'] != ''
          ? textToDate(cashManagementData['cheque_date']) //
          : 'N/A',
    )),
    DataCell(
      Align(
        alignment: Alignment.centerRight,
        child: FutureBuilder<double>(
          future: controller.getReceiptReceivedAmount(cashManagementId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return textForDataRowInTable(
                color: Colors.green,
                isBold: true,
                text: '${snapshot.data}',
              );
            }
          },
        ),
      ),
    ),
  ]);
}

Widget editSection(context, CashManagementController controller,
    Map<String, dynamic> cashManagementData, constraints, cashManagementId) {
  return GetX<CashManagementController>(builder: (controller) {
    bool isLoading = controller.buttonLoadingStates[cashManagementId] ?? false;

    return IconButton(
        onPressed: controller.buttonLoadingStates[cashManagementId] == null ||
                isLoading == false
            ? () async {
                controller.setButtonLoading(cashManagementId, true);

                await controller.loadValues(cashManagementData);
                controller.setButtonLoading(cashManagementId, false);

                receiptDialog(
                  context: context,
                  canEdit: true,
                  constraints: constraints,
                  controller: controller,
                  onPressedForPost: controller.postingReceipts.isTrue
                      ? null
                      : () {
                          controller.postReceipt(cashManagementId);
                        },
                  onPressedForSave: controller.addingNewValue.value
                      ? null
                      : () {
                          if (controller.status.value == 'Posted') {
                            showSnackBar(
                                'Alert', 'Only New Receipts Can be Edited');
                            return;
                          }
                          controller.editReceipt(cashManagementId);
                        },
                  onPressedForDelete: () {
                    alertDialog(
                        context: context,
                        controller: controller,
                        content: "This will be deleted permanently",
                        onPressed: () {
                          controller.deleteReceipt(cashManagementId);
                        });
                  },
                );
              }
            : null,
        icon: isLoading ? loadingProcess : editIcon);
  });
}

ElevatedButton newReceiptButton(BuildContext context,
    BoxConstraints constraints, CashManagementController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      receiptDialog(
          onPressedForDelete: null,
          context: context,
          canEdit: true,
          constraints: constraints,
          controller: controller,
          onPressedForPost: controller.postingReceipts.isTrue
              ? null
              : () {
                  controller.postReceipt(controller.currentReceiptID.value);
                },
          onPressedForSave: controller.addingNewValue.value
              ? null
              : () {
                  controller.addNewReceipts();
                });
    },
    style: newButtonStyle,
    child: const Text('New Receipt'),
  );
}

class CardDataSource extends DataTableSource {
  final List<DocumentSnapshot> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final CashManagementController controller;

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
