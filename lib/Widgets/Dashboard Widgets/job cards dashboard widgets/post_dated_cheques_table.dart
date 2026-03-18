import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/post_dated_cheques_model.dart';
import '../../../consts.dart';

Widget postDatedChequesTable() {
  return GetX<JobCardsDashboardController>(
    builder: (controller) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: PaginatedDataTable2(
          headingRowHeight: 25,
          dataRowHeight: 25,
          showCheckboxColumn: false,
          horizontalMargin: horizontalMarginForTable,
          columnSpacing: 5,
          dividerThickness: .3,
          dataTextStyle: controller.dataRowTextStyle,
          headingTextStyle: controller.headerRowTextStyle,
          autoRowsToHeight: true,
          lmRatio: 3,
          columns: const [
            DataColumn2(size: ColumnSize.M, label: Text('TYPE')),
            DataColumn2(size: ColumnSize.M, label: Text('NUMBER')),
            DataColumn2(size: ColumnSize.M, label: Text('DATE')),
            DataColumn2(size: ColumnSize.M, label: Text('BANK ACCOUNT')),
            DataColumn2(size: ColumnSize.L, label: Text('BENEFICIARY')),
            DataColumn2(size: ColumnSize.M, label: Text('CHEQUE DATE')),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('RECEIVED'),
            ),
            DataColumn2(size: ColumnSize.M, numeric: true, label: Text('PAID')),
          ],
          source: CardDataSource(
            cards: controller.postDatedChequesList.isEmpty
                ? []
                : controller.postDatedChequesList,
            controller: controller,
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  PostDatedChequesModel data,
  int index,
  JobCardsDashboardController controller,
) {
  bool isEven = index % 2 != 0;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return isEven ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.source?.toUpperCase() ?? '',
          color: data.source?.toLowerCase() == 'receipt'
              ? Colors.green
              : Colors.red,
        ),
      ),
      DataCell(textForDataRowInTable(text: data.counter?.toUpperCase() ?? '')),

      DataCell(textForDataRowInTable(text: textToDate(data.date))),
      DataCell(textForDataRowInTable(text: data.bankAccount?.toString() ?? '')),
      DataCell(
        textForDataRowInTable(text: data.beneficiaryName ?? '', maxWidth: null),
      ),
      DataCell(textForDataRowInTable(text: textToDate(data.chequeDate))),
      DataCell(
        textForDataRowInTable(
          text: data.received?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.paid?.toString() ?? '0',
          color: Colors.red,
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<PostDatedChequesModel> cards;
  final JobCardsDashboardController controller;

  CardDataSource({required this.cards, required this.controller});

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final card = cards[index];

    return dataRowForTheTable(card, index, controller);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
