import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/daily_jobs_summary_model.dart';
import '../../../consts.dart';

Widget jobsMonthlySummaryTable() {
  return GetX<JobCardsDashboardController>(
    builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: DataTable2(
            headingRowHeight: 30,
            dataRowHeight: 35,
            showCheckboxColumn: false,
            horizontalMargin: horizontalMarginForTable,
            columnSpacing: 5,
            dividerThickness: .3,
            columns: const [
              DataColumn2(size: ColumnSize.L, label: Text('Branch')),
              DataColumn2(
                size: ColumnSize.S,
                label: Text('No. Of Jobs'),
                numeric: true,
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('Total'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('Net'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('Paid'),
              ),
            ],
            rows: controller.jobMonthlySummary.asMap().entries.map((entry) {
              final index = entry.key + 1; // 1-based index
              final data = entry.value;
              return dataRowForTheTable(data, index, controller);
            }).toList(),
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  JobsDailySummary data,
  int index,
  JobCardsDashboardController controller,
) {
  bool isLastRow = controller.jobMonthlySummary.length == index;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return isLastRow ? Colors.grey.shade200 : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(text: data.name ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.jobCounts?.toString() ?? '0',
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: data.totalItemsAmount?.toString() ?? '0',
          color: Colors.blue,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalItemsNet?.toString() ?? '0',
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalItemsPaid?.toString() ?? '0',
          color: Colors.red,
        ),
      ),
    ],
  );
}
