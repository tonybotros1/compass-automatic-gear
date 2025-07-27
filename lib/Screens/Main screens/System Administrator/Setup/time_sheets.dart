import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/time_sheets_controller.dart';
import '../../../../Widgets/main screen widgets/time_sheets_widgets/jobs_section.dart';
import '../../../../Widgets/main screen widgets/time_sheets_widgets/name_section.dart';
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
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    spacing: 10.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetX<TimeSheetsController>(
                          init: TimeSheetsController(),
                          builder: (controller) {
                            return Row(
                              spacing: 20.w,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headerBoxLine(
                                    labelColor: controller
                                            .selectedEmployeeName.value.isEmpty
                                        ? Colors.red
                                        : Colors.green,
                                    lable: controller
                                            .selectedEmployeeName.value.isEmpty
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
                                      controller.selectedEmployeeName.value =
                                          '';
                                    }),
                                headerBoxLine(
                                    flex: 2,
                                    lable: controller.selectedJob.value.isEmpty
                                        ? 'CAR'
                                        : controller.selectedJob.value
                                            .toUpperCase(),
                                    labelColor:
                                        controller.selectedJob.value.isEmpty
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
                                        : controller.selectedTask.value
                                            .toUpperCase(),
                                    labelColor:
                                        controller.selectedTask.value.isEmpty
                                            ? Colors.red
                                            : Colors.green,
                                    onTapForLabel: () {},
                                    onTapForIcon: () {
                                      controller.selectedTask.value = '';
                                      controller.selectedTaskId.value = '';
                                    }),
                                customButton(
                                    lable: 'START',
                                    onTap: () {},
                                    backgroundcolor: Colors.green,
                                    textColor: Colors.white)
                              ],
                            );
                          }),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customButton(
                              lable: 'PERFORMANCE',
                              onTap: () {},
                              textColor: Colors.blueGrey),
                          customButton(
                              lable: 'PAUSE ALL',
                              onTap: () {},
                              textColor: Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
        spacing: 10.w,
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(5.r),
              onTap: onTapForLabel,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                alignment: Alignment.centerLeft,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: FittedBox(
                  child: Text(
                    lable,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: labelColor,
                        fontSize: 20.sp),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(5.r),
            onTap: onTapForIcon,
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 30.sp,
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
      borderRadius: BorderRadius.circular(5.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        alignment: Alignment.centerLeft,
        height: 50.h,
        decoration: BoxDecoration(
          color: backgroundcolor ?? Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Text(
          lable,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.grey.shade800,
              fontSize: 20.sp),
        ),
      ),
    );
  }
}
