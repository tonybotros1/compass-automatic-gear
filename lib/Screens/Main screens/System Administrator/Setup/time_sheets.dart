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
                          customButton(
                              lable: 'PAUSE ALL',
                              onTap: () {
                                controller
                                    .pauseAllFunction(controller.allTimeSheets);
                              },
                              textColor: Colors.blue),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: GetX<TimeSheetsController>(builder: (controller) {
                      var crossAxisCount =
                          (MediaQuery.of(context).size.width ~/ 250)
                              .clamp(1, 5);
                      return controller.isScreenLoadingForTimesheets.isFalse &&
                              controller.allTimeSheets.isEmpty
                          ? const Center(
                              child: Text('Empty'),
                            )
                          : controller.isScreenLoadingForTimesheets.isTrue
                              ? Center(
                                  child: loadingProcess,
                                )
                              : GridView.count(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: 1.3,
                                  // padding: EdgeInsets.all(20.w),
                                  crossAxisSpacing: 40,
                                  mainAxisSpacing: 40,
                                  children: List.generate(
                                      controller.allTimeSheets.length, (index) {
                                    double cardWidth =
                                        constraints.maxWidth / crossAxisCount;
                                    final sheet =
                                        controller.allTimeSheets[index];
                                    final data =
                                        sheet.data() as Map<String, dynamic>? ??
                                            {};
                                    String sheetEmployeeName =
                                        '${getDocumentById(data['employee_id'], controller.allTechnician)?.get('name') ?? ''}';

                                    Map<String, String> sheetJob = controller
                                        .getjobInfosById(data['job_id']);

                                    String brand = sheetJob['brand'].toString();
                                    String model = sheetJob['model'].toString();
                                    String plateNumber =
                                        sheetJob['plate_number'].toString();
                                    String color = sheetJob['color'].toString();
                                    String logo = sheetJob['logo'].toString();

                                    DocumentSnapshot<Object?>? taskName =
                                        getDocumentById(data['task_id'],
                                            controller.allTasks);

                                    String sheetTimeTask =
                                        '${taskName?.get('name_en') ?? ''}  -  ${taskName?.get('name_ar') ?? ''}';

                                    final cardColor =
                                        cardColors[index % cardColors.length];

                                    final d =
                                        controller.sheetDurations[sheet.id] ??
                                            const Duration();
                                    final h = d.inHours;
                                    final m = d.inMinutes % 60;
                                    final s = d.inSeconds % 60;
                                    final periods = sheet['active_periods']
                                        as List<dynamic>;
                                    bool isPaused = periods.isNotEmpty &&
                                        periods.last['to'] != null;

                                    return
                                        //  CourseCard(
                                        //     course: Course(
                                        //         title: sheetJob,
                                        //         instructor: sheetEmployeeName,
                                        //         color: cardColor));
                                        EmployeeTaskCard(
                                      cardWidth: cardWidth,
                                      brand: brand,
                                      model: model,
                                      plateNumber: plateNumber,
                                      color: color,
                                      logo: logo,
                                      isPaused: isPaused,
                                      totalWorkTime:
                                          '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                                      name: sheetEmployeeName,
                                      task: sheetTimeTask,
                                      statusColor: cardColor,
                                      startedAt: textToDate(data['start_date'],
                                          withTime: true, monthNameFirst: true),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
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
        padding: const EdgeInsets.all(8),
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
  final String brand;
  final String model;
  final String plateNumber;
  final String color;
  final String task;
  final Color statusColor;
  final String startedAt;
  final String logo;
  final String totalWorkTime;
  final VoidCallback onPause;
  final VoidCallback onContinue;
  final VoidCallback onFinish;
  final bool isPaused;
  final double cardWidth;

  const EmployeeTaskCard({
    super.key,
    required this.name,
    required this.startedAt,
    required this.cardWidth,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.logo,
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

    final double baseWidth = 300.0; // Your reference width
    final double scaleFactor = widget.cardWidth / baseWidth;

    double scaledFont(double size) => size * scaleFactor.clamp(0.8, 1.2);
    double scaledPadding(double size) => size * scaleFactor.clamp(0.8, 1.5);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            Card(
              color: widget.statusColor,
              elevation: _isHovered ? 8.0 : 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        carLogo(widget.logo),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                '${widget.brand} ${widget.model}',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: scaledFont(14),
                                ),
                              ),
                              Text(
                                '${widget.plateNumber} - ${widget.color}',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: scaledFont(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: scaledPadding(20),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorForNameInCards,
                        fontSize: scaledFont(14),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.task.isNotEmpty
                                  ? widget.task
                                  : 'Not currently working',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: scaledFont(12),
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Text(
                              widget.startedAt.isNotEmpty
                                  ? widget.startedAt
                                  : 'N/A',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: scaledFont(12),
                                color: Colors.grey.shade900,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.totalWorkTime,
                            style: TextStyle(
                                fontSize: scaledFont(12),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700),
                          ),
                          const Spacer(),
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
                                size: scaledFont(16)),
                            label: Text(
                              isPaused ? 'Continue' : 'Pause',
                              style: TextStyle(
                                  fontSize: scaledFont(12),
                                  fontWeight: FontWeight.bold),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextButton.icon(
                            onPressed: widget.onFinish,
                            icon: Icon(Icons.check_circle_outline,
                                size: scaledFont(16)),
                            label: Text(
                              'Finish',
                              style: TextStyle(
                                  fontSize: scaledFont(12),
                                  fontWeight: FontWeight.bold),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              foregroundColor: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isPaused
                ? Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 200),
                          borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.pause,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
