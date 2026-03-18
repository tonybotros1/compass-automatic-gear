import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/daily_new_jobs_summary_model.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'job_cards_dialog_for_dashoboard.dart';

Widget newJobsDialySummaryTable() {
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
            columns: [
              const DataColumn2(size: ColumnSize.L, label: Text('BRANCH')),
              const DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: Text('JOB NO.'),
              ),
              DataColumn2(
                size: ColumnSize.M,
                numeric: true,
                label: ClickableHoverText(
                  text: 'Not APPRO.',
                  onTap: () {
                    controller.jonCardController.allJobCards.clear();
                    controller.jonCardController.searchEngine({
                      'status': 'not approved',
                    });
                    jobsDialog();
                  },
                  color1: Colors.blueGrey,
                  color2: Colors.blue,
                ),
              ),
              DataColumn2(
                size: ColumnSize.M,

                numeric: true,
                label: ClickableHoverText(
                  text: 'APPRO.',
                  onTap: () {
                    controller.jonCardController.allJobCards.clear();
                    controller.jonCardController.searchEngine({
                      'status': 'Approved',
                    });
                    jobsDialog();
                  },
                  color1: Colors.blueGrey,
                  color2: Colors.blue,
                ),
              ),
              DataColumn2(
                size: ColumnSize.M,

                numeric: true,
                label: ClickableHoverText(
                  text: 'READY',
                  onTap: () {
                    controller.jonCardController.allJobCards.clear();
                    controller.jonCardController.searchEngine({
                      'status': 'Ready',
                    });
                    jobsDialog();
                  },
                  color1: Colors.blueGrey,
                  color2: Colors.blue,
                ),
              ),
              DataColumn2(
                size: ColumnSize.M,

                numeric: true,
                label: ClickableHoverText(
                  text: 'RETURNED',
                  onTap: () {
                    controller.jonCardController.allJobCards.clear();
                    controller.jonCardController.searchEngine({
                      'label': 'Returned',
                    });
                    jobsDialog();
                  },
                  color1: Colors.blueGrey,
                  color2: Colors.blue,
                ),
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
      DataCell(
        textForDataRowInTable(
          text: data.totalNotApproved?.toString() ?? '0',
          formatDouble: false,
          color: Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalApproved?.toString() ?? '0',
          color: const Color(0xffD2665A).withAlpha(alpha),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalReady?.toString() ?? '0',
          color: const Color(0xff7886C7).withAlpha(alpha),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalReturned?.toString() ?? '0',
          color: Colors.redAccent.withAlpha(alpha),
          formatDouble: false,
        ),
      ),
    ],
  );
}
