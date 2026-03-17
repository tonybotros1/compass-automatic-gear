import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/cashflow_summary_model.dart';
import '../../../consts.dart';

Widget cashflowSummaryTable() {
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
            DataColumn2(size: ColumnSize.L, label: Text('ACCOUNT')),

            DataColumn2(size: ColumnSize.M, numeric: true, label: Text('NET')),
            DataColumn2(size: ColumnSize.M, numeric: true, label: Text('CR')),
            DataColumn2(size: ColumnSize.M, numeric: true, label: Text('DR')),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('TRANS. IN'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('TRANS. OUT'),
            ),
          ],
          source: CardDataSource(
            cards: controller.cashflowDialySummaryList.isEmpty
                ? []
                : controller.cashflowDialySummaryList,
            controller: controller,
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  CashflowSummaryModel data,
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
      DataCell(SelectableText(data.accountNumber ?? '', maxLines: 1)),

      DataCell(
        textForDataRowInTable(
          text: data.net?.toString() ?? '0',
          color: Colors.orange,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalReceived?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalPaid?.toString() ?? '0',
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalTransIn?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalTransOut?.toString() ?? '0',
          color: Colors.red,
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<CashflowSummaryModel> cards;
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
