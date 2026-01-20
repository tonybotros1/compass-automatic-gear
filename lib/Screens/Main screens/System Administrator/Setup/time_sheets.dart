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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey.shade200,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),

                                            child: Text(
                                              isPaused ? 'Paused' : 'Running',
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
                                                    color: Colors.grey.shade200,
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
                                                    color: Colors.grey.shade200,
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

  // var crossAxisCount =
  //                           (MediaQuery.of(context).size.width ~/ 250).clamp(
  //                             1,
  //                             5,
  //                           );

  // GridView.count(
  //                               crossAxisCount: crossAxisCount,
  //                               childAspectRatio: 1.3,
  //                               // padding: EdgeInsets.all(20.w),
  //                               crossAxisSpacing: 40,
  //                               mainAxisSpacing: 40,
  //                               children: List.generate(
  //                                 controller.allTimeSheets.length,
  //                                 (index) {
  //                                   double cardWidth =
  //                                       constraints.maxWidth / crossAxisCount;
  //                                   final sheet =
  //                                       controller.allTimeSheets[index];
  //                                   String sheetEmployeeName =
  //                                       sheet.employeeName ?? '';
  //                                   String brand = sheet.brandName.toString();
  //                                   String model = sheet.modelName.toString();
  //                                   String plateNumber = sheet.plateNumber
  //                                       .toString();
  //                                   String color = sheet.color.toString();
  //                                   String logo = sheet.logo.toString();
  //                                   String sheetTimeTask =
  //                                       '${sheet.taskEnName ?? ''}  -  ${sheet.taskArName ?? ''}';
  //                                   final cardColor =
  //                                       cardColors[index % cardColors.length];
  //                                   final d =
  //                                       controller.sheetDurations[sheet.id] ??
  //                                       const Duration();
  //                                   final h = d.inHours;
  //                                   final m = d.inMinutes % 60;
  //                                   final s = d.inSeconds % 60;
  //                                   final periods =
  //                                       sheet.activePeriods
  //                                           as List<ActivePeriods>;
  //                                   bool isPaused =
  //                                       periods.isNotEmpty &&
  //                                       periods.last.to != null;

  //                                   return
  //                                   EmployeeTaskCard(
  //                                     cardWidth: cardWidth,
  //                                     brand: brand,
  //                                     model: model,
  //                                     plateNumber: plateNumber,
  //                                     color: color,
  //                                     logo: logo,
  //                                     isPaused: isPaused,
  //                                     totalWorkTime:
  //                                         '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
  //                                     name: sheetEmployeeName,
  //                                     task: sheetTimeTask,
  //                                     statusColor: cardColor,
  //                                     startedAt: textToDate(
  //                                       sheet.startDate,
  //                                       withTime: true,
  //                                       monthNameFirst: true,
  //                                     ),
  //                                     onContinue: () {
  //                                       controller.continueFunction(sheet.id);
  //                                     },
  //                                     onFinish: () {
  //                                       controller.finishFunction(sheet.id);
  //                                     },
  //                                     onPause: () {
  //                                       controller.pauseFunction(sheet.id);
  //                                     },
  //                                   );
  //                                 },
  //                               ),
  //                             );

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

// class EmployeeTaskCard extends StatefulWidget {
//   final String name;
//   final String brand;
//   final String model;
//   final String plateNumber;
//   final String color;
//   final String task;
//   final Color statusColor;
//   final String startedAt;
//   final String logo;
//   final String totalWorkTime;
//   final VoidCallback onPause;
//   final VoidCallback onContinue;
//   final VoidCallback onFinish;
//   final bool isPaused;
//   final double cardWidth;

//   const EmployeeTaskCard({
//     super.key,
//     required this.name,
//     required this.startedAt,
//     required this.cardWidth,
//     required this.brand,
//     required this.model,
//     required this.plateNumber,
//     required this.color,
//     required this.logo,
//     required this.task,
//     required this.totalWorkTime,
//     required this.onPause,
//     required this.isPaused,
//     required this.onContinue,
//     required this.onFinish,
//     this.statusColor = Colors.blue,
//   });

//   @override
//   State<EmployeeTaskCard> createState() => _EmployeeTaskCardState();
// }

// class _EmployeeTaskCardState extends State<EmployeeTaskCard> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     bool isPaused = widget.isPaused;

//     final double baseWidth = 300.0; // Your reference width
//     final double scaleFactor = widget.cardWidth / baseWidth;

//     double scaledFont(double size) => size * scaleFactor.clamp(0.8, 1.2);
//     double scaledPadding(double size) => size * scaleFactor.clamp(0.8, 1.5);

//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: AnimatedScale(
//         scale: _isHovered ? 1.03 : 1.0,
//         duration: const Duration(milliseconds: 200),
//         child: Stack(
//           children: [
//             Card(
//               color: widget.statusColor,
//               elevation: _isHovered ? 8.0 : 4.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       spacing: 10,
//                       children: [
//                         carLogo(widget.logo),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             spacing: 4,
//                             children: [
//                               Text(
//                                 '${widget.brand} ${widget.model}',
//                                 style: TextStyle(
//                                   color: Colors.grey.shade800,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: scaledFont(14),
//                                 ),
//                               ),
//                               Text(
//                                 '${widget.plateNumber} - ${widget.color}',
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: scaledFont(12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: scaledPadding(20)),
//                     Text(
//                       textAlign: TextAlign.center,
//                       widget.name,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: colorForNameInCards,
//                         fontSize: scaledFont(14),
//                       ),
//                     ),
//                     const Divider(),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           spacing: 20,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               widget.task.isNotEmpty
//                                   ? widget.task
//                                   : 'Not currently working',
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: scaledFont(12),
//                                 color: Colors.grey.shade800,
//                               ),
//                             ),
//                             Text(
//                               widget.startedAt.isNotEmpty
//                                   ? widget.startedAt
//                                   : 'N/A',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: scaledFont(12),
//                                 color: Colors.grey.shade900,
//                               ),
//                             ),
//                             // _buildInfoRow(
//                             //   context,
//                             //   label: 'Started at:',
//                             //   value: widget.startedAt.isNotEmpty
//                             //       ? widget.startedAt
//                             //       : 'N/A',
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         // mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             widget.totalWorkTime,
//                             style: TextStyle(
//                               fontSize: scaledFont(12),
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                           const Spacer(),
//                           TextButton.icon(
//                             onPressed: () {
//                               setState(() => isPaused = !isPaused);
//                               if (isPaused) {
//                                 widget.onPause();
//                               } else {
//                                 widget.onContinue();
//                               }
//                             },
//                             icon: Icon(
//                               isPaused ? Icons.play_arrow : Icons.pause,
//                               size: scaledFont(16),
//                             ),
//                             label: Text(
//                               isPaused ? 'Continue' : 'Pause',
//                               style: TextStyle(
//                                 fontSize: scaledFont(12),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             style: TextButton.styleFrom(
//                               foregroundColor: colorScheme.primary,
//                               padding: EdgeInsets.zero,
//                               minimumSize: const Size(0, 0),
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           TextButton.icon(
//                             onPressed: widget.onFinish,
//                             icon: Icon(
//                               Icons.check_circle_outline,
//                               size: scaledFont(16),
//                             ),
//                             label: Text(
//                               'Finish',
//                               style: TextStyle(
//                                 fontSize: scaledFont(12),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.zero,
//                               minimumSize: const Size(0, 0),
//                               foregroundColor: Colors.green.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             isPaused
//                 ? Positioned(
//                     top: 10,
//                     right: 10,
//                     child: Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         // color: Colors.black.withValues(alpha: 200),
//                         color: Colors.orange.shade200,
//                         // borderRadius: BorderRadius.circular(12),
//                         shape: BoxShape.circle,
//                       ),
//                       alignment: Alignment.center,
//                       child: const Icon(
//                         Icons.pause,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 : const SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }
