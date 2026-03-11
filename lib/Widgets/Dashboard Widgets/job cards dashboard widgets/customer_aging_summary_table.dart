import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/customer_aging_model.dart';
import '../../../consts.dart';

Widget customerAgingTable({required BuildContext context}) {
  return GetX<JobCardsDashboardController>(
    builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: PaginatedDataTable2(
            headingRowHeight: 30,
            dataRowHeight: 35,
            showCheckboxColumn: false,
            horizontalMargin: horizontalMarginForTable,
            columnSpacing: 5,
            dividerThickness: .3,
            columns: const [
              DataColumn2(size: ColumnSize.L, label: Text('Group Name')),
              DataColumn2(
                size: ColumnSize.M,
                label: Text('Total Out.'),
                numeric: true,
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('0 To 30'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('31 To 60'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('61 To 90'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('0 To 90'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('91 To 120'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('121 To 150'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('151 To 180'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('91 To 180'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('181 To 460'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('+ 360'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('Last Pay-Date'),
              ),
            ],
            source: CardDataSource(
              cards: controller.customerAgingSummary.isEmpty
                  ? []
                  : controller.customerAgingSummary,
              context: context,
              controller: controller,
            ),
            // rows: controller.customerAgingSummary.asMap().entries.map((entry) {
            //   final index = entry.key + 1; // 1-based index
            //   final data = entry.value;
            //   return dataRowForTheTable(data, index, controller);
            // }).toList(),
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  CustomerAgingModel data,
  int index,
  JobCardsDashboardController controller,
) {
  bool isLastRow = controller.jobSalesmanSummary.length == index;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return isLastRow ? Colors.grey.shade200 : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(text: data.groupName ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalOutstanding?.toString() ?? '0',
          formatDouble: true,
          color: Colors.blue,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: data.i0To30Days?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.i31To60Days?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.i61To90Days?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.i0To90Days?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.i91To120Days?.toString() ?? '0',
          color: Colors.orange,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.i121To150Days?.toString() ?? '0',
          color: Colors.orange,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.i151To180Days?.toString() ?? '0',
          color: Colors.orange,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.i91To180Days?.toString() ?? '0',
          color: Colors.orange,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.d181To360Days?.toString() ?? '0',
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.moreThan360Days?.toString() ?? '0',
          color: Colors.black,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.lastPaymentDate),
          color: Colors.black,
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<CustomerAgingModel> cards;
  final BuildContext context;
  final JobCardsDashboardController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.controller,
  });

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
