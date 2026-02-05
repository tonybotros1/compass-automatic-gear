import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../../Models/job cards dashboard/daily_new_jobs_summary_model.dart';
import '../../../consts.dart';
import '../../text_button.dart';

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
            headingRowHeight: 30,
            dataRowHeight: 35,
            showCheckboxColumn: false,
            horizontalMargin: horizontalMarginForTable,
            columnSpacing: 5,
            dividerThickness: .3,
            columns: [
              const DataColumn2(size: ColumnSize.L, label: Text('Branch')),
              const DataColumn2(
                size: ColumnSize.S,
                numeric: true,
                label: Text('No Of Jobs'),
              ),
              DataColumn2(
                size: ColumnSize.S,

                numeric: true,
                label: ClickableHoverText(
                  text: 'Not Approved',
                  onTap: () {
                    if (controller.isNotApprovedSelected.isFalse) {
                      controller.isNotApprovedSelected.value = true;
                      controller.isApprovedSelected.value = false;
                      controller.isReadySelected.value = false;
                      controller.isReturnedSelected.value = false;
                      controller.isPostedSelected.value = false;
                      controller.isNewSelected.value = false;
                    } else {
                      controller.isNotApprovedSelected.value = false;
                    }
                    controller.jonCardController.searchEngine({
                      'status': 'not approved',
                    });
                  },
                  color1: Colors.blueGrey,
                  color2: controller.isNotApprovedSelected.isFalse
                      ? Colors.blue
                      : Colors.red,
                ),
              ),
              DataColumn2(
                size: ColumnSize.S,

                numeric: true,
                label: ClickableHoverText(
                  text: 'Approved',
                  onTap: () {
                    if (controller.isApprovedSelected.isFalse) {
                      controller.isApprovedSelected.value = true;
                      controller.isNotApprovedSelected.value = false;
                      controller.isReadySelected.value = false;
                      controller.isReturnedSelected.value = false;
                      controller.isPostedSelected.value = false;
                      controller.isNewSelected.value = false;
                    } else {
                      controller.isApprovedSelected.value = false;
                    }
                    controller.jonCardController.searchEngine({
                      'status': 'Approved',
                    });
                  },
                  color1: Colors.blueGrey,
                  color2: controller.isApprovedSelected.isFalse
                      ? Colors.blue
                      : Colors.red,
                ),
              ),
              DataColumn2(
                size: ColumnSize.S,

                numeric: true,
                label: ClickableHoverText(
                  text: 'Ready',
                  onTap: () {
                    if (controller.isReadySelected.isFalse) {
                      controller.isReadySelected.value = true;
                      controller.isApprovedSelected.value = false;
                      controller.isNotApprovedSelected.value = false;
                      controller.isReturnedSelected.value = false;
                      controller.isPostedSelected.value = false;
                      controller.isNewSelected.value = false;
                    } else {
                      controller.isReadySelected.value = false;
                    }
                    controller.jonCardController.searchEngine({
                      'status': 'Ready',
                    });
                  },
                  color1: Colors.blueGrey,
                  color2: controller.isReadySelected.isFalse
                      ? Colors.blue
                      : Colors.red,
                ),
              ),
              DataColumn2(
                size: ColumnSize.S,

                numeric: true,
                label: ClickableHoverText(
                  text: 'Returned',
                  onTap: () {
                    if (controller.isReturnedSelected.isFalse) {
                      controller.isReturnedSelected.value = true;
                      controller.isReadySelected.value = false;
                      controller.isApprovedSelected.value = false;
                      controller.isNotApprovedSelected.value = false;
                      controller.isPostedSelected.value = false;
                      controller.isNewSelected.value = false;
                    } else {
                      controller.isReturnedSelected.value = false;
                    }
                    controller.jonCardController.searchEngine({
                      'label': 'Returned',
                    });
                  },
                  color1: Colors.blueGrey,
                  color2: controller.isReturnedSelected.isFalse
                      ? Colors.blue
                      : Colors.red,
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
        textForDataRowInTable(text: data.name ?? '', formatDouble: false),
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
