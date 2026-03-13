import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/daily_new_jobs_summary_model.dart';
import '../../../consts.dart';

Widget accountsSummaryTable() {
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
            headingRowHeight: 25,
            dataRowHeight: 25,
            showCheckboxColumn: false,
            horizontalMargin: horizontalMarginForTable,
            columnSpacing: 5,
            dividerThickness: .3,
            lmRatio: 2.4,
            dataTextStyle: controller.dataRowTextStyle,
            headingTextStyle: controller.headerRowTextStyle,
            columns: const [
              DataColumn2(size: ColumnSize.L, label: Text('ACCOUNT')),
              DataColumn2(
                size: ColumnSize.S,
                numeric: true,
                label: Text('NET'),
              ),
            ],
            rows: controller.newJobDailySummary.asMap().entries.map((entry) {
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
  NewJobsDailySummary data,
  int index,
  JobCardsDashboardController controller,
) {
  bool isLastRow = controller.jobDailySummary.length == index;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return isLastRow ? Colors.grey.shade200 : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: (data.totalNew?.toString() ?? '0'),
          formatDouble: false,
          color: Colors.black,
        ),
      ),
    ],
  );
}
