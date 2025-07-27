import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/time_sheets_controller.dart';
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
                          headerBoxLine(
                              labelColor:
                                  controller.selectedEmployeeName.value.isEmpty
                                      ? Colors.red
                                      : Colors.green,
                              lable:
                                  controller.selectedEmployeeName.value.isEmpty
                                      ? 'NAME'
                                      : controller.selectedEmployeeName.value
                                          .toUpperCase(),
                              onTapForLabel: () {
                                nameDialog(
                                    constraints: constraints,
                                    controller: controller,
                                    context: context);
                              },
                              onTapForIcon: () {
                                controller.selectedEmployeeId.value = '';
                                controller.selectedEmployeeName.value = '';
                              }),
                          headerBoxLine(
                              flex: 2,
                              lable: controller.selectedJob.value.isEmpty
                                  ? 'CAR'
                                  : controller.selectedJob.value.toUpperCase(),
                              labelColor: controller.selectedJob.value.isEmpty
                                  ? Colors.red
                                  : Colors.green,
                              onTapForLabel: () {
                                jobsDialog(
                                    constraints: constraints,
                                    controller: controller,
                                    context: context);
                              },
                              onTapForIcon: () {
                                controller.selectedJob.value = '';
                                controller.selectedJobId.value = '';
                              }),
                          headerBoxLine(
                              lable: controller.selectedTask.value.isEmpty
                                  ? 'TASK'
                                  : controller.selectedTask.value.toUpperCase(),
                              labelColor: controller.selectedTask.value.isEmpty
                                  ? Colors.red
                                  : Colors.green,
                              onTapForLabel: () {
                                taskDialog(
                                    constraints: constraints,
                                    controller: controller,
                                    context: context);
                              },
                              onTapForIcon: () {
                                controller.selectedTask.value = '';
                                controller.selectedTaskId.value = '';
                              }),
                          customButton(
                              lable: 'START',
                              onTap: controller.startSheet.isFalse
                                  ? () {
                                      if (controller.selectedEmployeeId.value
                                              .isEmpty ||
                                          controller
                                              .selectedJobId.value.isEmpty ||
                                          controller
                                              .selectedTaskId.value.isEmpty) {
                                        showSnackBar('Alert',
                                            'Please Select all Fields');
                                      } else {
                                        controller.startFunction();
                                      }
                                    }
                                  : null,
                              backgroundcolor: controller.startSheet.isFalse
                                  ? Colors.green
                                  : Colors.grey,
                              textColor: Colors.white)
                        ],
                      );
                    }),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: GetX<TimeSheetsController>(builder: (controller) {
                      return controller.isScreenLoadingForTimesheets.isFalse &&
                              controller.allTimeSheets.isEmpty
                          ? Center(
                              child: Text('Empty'),
                            )
                          : controller.isScreenLoadingForTimesheets.isTrue
                              ? Center(
                                  child: loadingProcess,
                                )
                              : GridView.count(
                                  crossAxisCount:
                                      (MediaQuery.of(context).size.width ~/ 300)
                                          .clamp(1, 4),
                                  childAspectRatio: 1.3,
                                  // padding: EdgeInsets.all(20.w),
                                  crossAxisSpacing: 40,
                                  mainAxisSpacing: 40,
                                  children: List.generate(
                                      controller.allTimeSheets.length, (index) {
                                    final sheet =
                                        controller.allTimeSheets[index];
                                    final data =
                                        sheet.data() as Map<String, dynamic>? ??
                                            {};
                                    String sheetEmployeeName =
                                        '${controller.getDocumentById(data['employee_id'], controller.allTechnician)?.get('name') ?? ''}';

                                    String sheetJob = controller
                                        .getjobInfosById(data['job_id']);

                                    DocumentSnapshot<Object?>? taskName =
                                        controller.getDocumentById(
                                            data['task_id'],
                                            controller.allTasks);

                                    String sheetTimeTask =
                                        '${taskName?.get('name_en') ?? ''}  -  ${taskName?.get('name_ar') ?? ''}';

                                    final cardColor =
                                        cardColors[index % cardColors.length];

                                    final d =
                                        controller.sheetDurations[sheet.id] ??
                                            Duration();
                                    final h = d.inHours;
                                    final m = d.inMinutes % 60;
                                    final s = d.inSeconds % 60;
                                    final periods = sheet['active_periods']
                                        as List<dynamic>;
                                    bool isPaused = periods.isNotEmpty &&
                                        periods.last['to'] != null;

                                    return EmployeeTaskCard(
                                      isPaused: isPaused,
                                      totalWorkTime:
                                          '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                                      name: sheetEmployeeName,
                                      job: sheetJob,
                                      task: sheetTimeTask,
                                      statusColor: cardColor,
                                      startedAt: textToDate(data['start_date'],
                                          withTime: true),
                                      onContinue: () {
                                        controller.continueFunction(sheet);
                                      },
                                      onFinish: () {
                                        controller.finishFunction(sheet);
                                      },
                                      onPause: () {
                                        controller.pauseFunction(sheet);
                                      },
                                    );
                                  }),
                                );
                    }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customButton(
                        lable: 'PERFORMANCE',
                        onTap: () {},
                        textColor: Colors.blueGrey),
                    GetBuilder<TimeSheetsController>(builder: (controller) {
                      return customButton(
                          lable: 'PAUSE ALL',
                          onTap: () {
                          controller.pauseAllFunction(controller.allTimeSheets);
                          },
                          textColor: Colors.blue);
                    }),
                  ],
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
        spacing: 10,
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: onTapForLabel,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
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
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.close_rounded,
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell customButton(
      {required String lable,
      void Function()? onTap,
      Color? backgroundcolor,
      Color? textColor}) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: backgroundcolor ?? Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5),
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

class EmployeeTaskCard extends StatefulWidget {
  final String name;
  final String job;
  final String task;
  final Color statusColor;
  final String startedAt;
  final String totalWorkTime;
  final VoidCallback onPause;
  final VoidCallback onContinue;
  final VoidCallback onFinish;
  final bool isPaused;

  const EmployeeTaskCard({
    super.key,
    required this.name,
    required this.startedAt,
    required this.job,
    required this.task,
    required this.totalWorkTime,
    required this.onPause,
    required this.isPaused,
    required this.onContinue,
    required this.onFinish,
    this.statusColor = Colors.blue,
  });

  @override
  State<EmployeeTaskCard> createState() => _EmployeeTaskCardState();
}

class _EmployeeTaskCardState extends State<EmployeeTaskCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isPaused = widget.isPaused;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          color: widget.statusColor,
          elevation: _isHovered ? 8.0 : 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.job,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.task.isNotEmpty
                              ? widget.task
                              : 'Not currently working',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: colorForNameInCards,
                          ),
                        ),
                        // _buildInfoRow(
                        //   context,
                        //   label: 'Started at:',
                        //   value: widget.startedAt.isNotEmpty
                        //       ? widget.startedAt
                        //       : 'N/A',
                        // ),
                      ],
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.totalWorkTime,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700),
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() => isPaused = !isPaused);
                        if (isPaused) {
                          widget.onPause();
                        } else {
                          widget.onContinue();
                        }
                      },
                      icon: Icon(
                        isPaused ? Icons.play_arrow : Icons.pause,
                      ),
                      label: Text(
                        isPaused ? 'Continue' : 'Pause',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: widget.onFinish,
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: Text(
                        'Finish',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required String label, required String value}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorForNameInCards,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.grey.shade900,
            ),
          ),
        ),
      ],
    );
  }
}
