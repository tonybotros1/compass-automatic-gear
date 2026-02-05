import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/time_sheets_controller.dart';
import '../../../../Models/time sheets/time_sheets_model.dart';
import '../../../../Widgets/main screen widgets/time_sheets_widgets/jobs_section.dart';
import '../../../../Widgets/main screen widgets/time_sheets_widgets/name_section.dart';
import '../../../../Widgets/main screen widgets/time_sheets_widgets/task_section.dart';
import '../../../../consts.dart';

class TimeSheets extends StatelessWidget {
  const TimeSheets({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenPadding,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetX<TimeSheetsController>(
                  init: TimeSheetsController(),
                  builder: (controller) {
                    return Row(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customButton(
                          lable: controller.pausingAllOpenTimeSheets.isFalse
                              ? 'PAUSE ALL'
                              : "Pausing",
                          onTap: () {
                            controller.pauseAllFunction();
                          },
                          textColor: Colors.blue,
                          backgroundcolor: Colors.white,
                          borderColor: Colors.blue,
                        ),
                        headerBoxLine(
                          labelColor:
                              controller.selectedEmployeeName.value.isEmpty
                              ? Colors.red
                              : Colors.green,
                          lable: controller.selectedEmployeeName.value.isEmpty
                              ? 'NAME'
                              : controller.selectedEmployeeName.value
                                    .toUpperCase(),
                          onTapForLabel: () {
                            controller.getAllTechnicians();
                            nameDialog(
                              constraints: constraints,
                              controller: controller,
                              context: context,
                            );
                          },
                          onTapForIcon: () {
                            controller.selectedEmployeeId.value = '';
                            controller.selectedEmployeeName.value = '';
                          },
                        ),
                        headerBoxLine(
                          flex: 2,
                          lable: controller.selectedJob.value.isEmpty
                              ? 'CAR'
                              : controller.selectedJob.value.toUpperCase(),
                          labelColor: controller.selectedJob.value.isEmpty
                              ? Colors.red
                              : Colors.green,
                          onTapForLabel: () {
                            controller.getApprovedJobs();
                            jobsDialog(
                              constraints: constraints,
                              controller: controller,
                              context: context,
                            );
                          },
                          onTapForIcon: () {
                            controller.selectedJob.value = '';
                            controller.selectedJobId.value = '';
                          },
                        ),
                        headerBoxLine(
                          lable: controller.selectedTask.value.isEmpty
                              ? 'TASK'
                              : controller.selectedTask.value.toUpperCase(),
                          labelColor: controller.selectedTask.value.isEmpty
                              ? Colors.red
                              : Colors.green,
                          onTapForLabel: () {
                            controller.gettAllJobTasks();
                            taskDialog(
                              constraints: constraints,
                              controller: controller,
                              context: context,
                            );
                          },
                          onTapForIcon: () {
                            controller.selectedTask.value = '';
                            controller.selectedTaskId.value = '';
                          },
                        ),
                        customButton(
                          lable: 'START',
                          onTap: controller.startSheet.isFalse
                              ? () {
                                  if (controller
                                          .selectedEmployeeId
                                          .value
                                          .isEmpty ||
                                      controller.selectedJobId.value.isEmpty ||
                                      controller.selectedTaskId.value.isEmpty) {
                                    alertMessage(
                                      context: Get.context!,
                                      content: 'Please Select all Fields',
                                    );
                                  } else {
                                    controller.startFunction();
                                  }
                                }
                              : null,
                          backgroundcolor: controller.startSheet.isFalse
                              ? Colors.white
                              : Colors.grey,
                          textColor: Colors.green,
                          borderColor: Colors.green,
                        ),
                      ],
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: GetX<TimeSheetsController>(
                      builder: (controller) {
                        return controller
                                    .isScreenLoadingForTimesheets
                                    .isFalse &&
                                controller.allTimeSheets.isEmpty
                            ? const Center(child: Text('Empty'))
                            : controller.isScreenLoadingForTimesheets.isTrue
                            ? Center(child: loadingProcess)
                            : ListView.builder(
                                itemCount: controller.allTimeSheets.length,
                                itemBuilder: (context, i) {
                                  TimeSheetsModel sheet =
                                      controller.allTimeSheets[i];
                                  final d =
                                      controller.sheetDurations[sheet.id] ??
                                      const Duration();
                                  final h = d.inHours;
                                  final m = d.inMinutes % 60;
                                  final s = d.inSeconds % 60;
                                  final periods =
                                      sheet.activePeriods
                                          as List<ActivePeriods>;
                                  bool isPaused =
                                      periods.isNotEmpty &&
                                      periods.last.to != null;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: i % 2 == 0
                                            ? coolColor
                                            : Colors.white,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 5,
                                              children: [
                                                Text(
                                                  sheet.employeeName ?? '',
                                                  style:
                                                      fontStyleForTimeSheetsMainInfo,
                                                ),
                                                Text(
                                                  sheet.employeeJobTitle ?? '',
                                                  style:
                                                      fontStyleForTimeSheetsHeader,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 5,
                                              children: [
                                                Text(
                                                  '${sheet.brandName ?? ''} ${sheet.modelName ?? ''} - ${sheet.color ?? ''}',
                                                  style:
                                                      fontStyleForTimeSheetsMainInfo,
                                                ),
                                                Text(
                                                  '${sheet.plateNumber} - ${sheet.plateCode}',
                                                  style:
                                                      fontStyleForTimeSheetsHeader,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 5,
                                              children: [
                                                Text(
                                                  sheet.taskEnName ?? '',
                                                  style:
                                                      fontStyleForTimeSheetsMainInfo,
                                                ),
                                                Text(
                                                  sheet.taskArName ?? '',
                                                  style:
                                                      fontStyleForTimeSheetsHeader,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 5,
                                              children: [
                                                Text(
                                                  textToDate(
                                                    sheet.startDate,
                                                    withTime: true,
                                                    monthNameFirst: true,
                                                  ),
                                                  style:
                                                      fontStyleForTimeSheetsMainInfo,
                                                ),
                                                Text(
                                                  'Start Date',
                                                  style:
                                                      fontStyleForTimeSheetsHeader,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 5,
                                              children: [
                                                Text(
                                                  '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',

                                                  style:
                                                      fontStyleForTimeSheetsMainInfo,
                                                ),
                                                Text(
                                                  'Elapsed',
                                                  style:
                                                      fontStyleForTimeSheetsHeader,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: i % 2 == 0
                                                  ? Colors.white
                                                  : coolColor,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),

                                            child: Text(
                                              isPaused
                                                  ? 'Paused'.toUpperCase()
                                                  : 'Running'.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isPaused
                                                    ? Colors.orange
                                                    : Colors.green,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              spacing: 25,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),

                                                    color: i % 2 == 0
                                                        ? Colors.white
                                                        : coolColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      !isPaused
                                                          ? Icons.pause_rounded
                                                          : Icons
                                                                .play_arrow_rounded,
                                                      color: !isPaused
                                                          ? Colors.orange
                                                          : Colors.green,
                                                    ),
                                                    color: CupertinoColors
                                                        .systemGrey,
                                                    onPressed: () {
                                                      if (isPaused) {
                                                        controller
                                                            .continueFunction(
                                                              sheet.id,
                                                            );
                                                      } else {
                                                        controller
                                                            .pauseFunction(
                                                              sheet.id,
                                                            );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),

                                                    color: i % 2 == 0
                                                        ? Colors.white
                                                        : coolColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      controller.finishFunction(
                                                        sheet.id,
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.task_alt_rounded,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Expanded headerBoxLine({
    int? flex,
    required String lable,
    Color? labelColor,
    void Function()? onTapForLabel,
    void Function()? onTapForIcon,
  }) {
    return Expanded(
      flex: flex ?? 1,
      child: Row(
        spacing: 5,
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: onTapForLabel,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  // color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FittedBox(
                  child: Text(
                    lable,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: onTapForIcon,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                // color: Colors.grey.shade300,
                border: Border.all(color: Colors.grey),

                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }

  InkWell customButton({
    required String lable,
    void Function()? onTap,
    Color? backgroundcolor,
    Color? textColor,
    Color? borderColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: backgroundcolor ?? Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: borderColor ?? Colors.grey),
        ),
        child: Text(
          lable,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}
