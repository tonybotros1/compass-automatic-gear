import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/customer_aging_model.dart';
import '../../../consts.dart';

Widget customerAgingTable({required BuildContext context}) {
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
            DataColumn2(size: ColumnSize.L, label: Text('GROUP NAME')),
            DataColumn2(
              size: ColumnSize.M,
              label: Text('TOTAL OUT.'),
              numeric: true,
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('0 TO 30'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('31 TO 60'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('61 TO 90'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('0 TO 90'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('91 TO 120'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('121 TO 150'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('151 TO 180'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('91 TO 180'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('181 TO 360'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('+ 360'),
            ),
            DataColumn2(
              size: ColumnSize.M,
              numeric: true,
              label: Text('LAST PAY-DATE'),
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
      );
    },
  );
}

DataRow dataRowForTheTable(
  CustomerAgingModel data,
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
      DataCell(SelectableText(data.groupName ?? '', maxLines: 1)),
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
          color: textColorDependingOnDateTime(
            data.lastPaymentDate,
            30,
            Colors.red,
          ),
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
