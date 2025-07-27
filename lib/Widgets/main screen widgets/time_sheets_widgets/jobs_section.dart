import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/time_sheets_controller.dart';
import '../../../consts.dart';
import '../first_main_screen_widgets/first_main_screen.dart';

Future<dynamic> jobsDialog(
    {required BoxConstraints constraints,
    required TimeSheetsController controller,
    required BuildContext context}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        insetPadding: EdgeInsets.all(8.w),
        child: SizedBox(
          // height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r)),
                  color: mainColor,
                ),
                child: Row(
                  spacing: 10.w,
                  children: [
                    Text(
                      '💳 Approved Jobs',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    const Spacer(),
                    closeButton
                  ],
                ),
              ),
              Expanded(child: GetX<TimeSheetsController>(builder: (controller) {
                return Padding(
                  padding: EdgeInsetsGeometry.all(16.w),
                  child: controller.isScreenLodingForJobs.isFalse &&
                          controller.allTechnician.isEmpty
                      ? Center(
                          child: Text('Empty'),
                        )
                      : controller.isScreenLodingForJobs.isTrue
                          ? Center(
                              child: loadingProcess,
                            )
                          : GridView.count(
                              crossAxisCount:
                                  (MediaQuery.of(context).size.width ~/ 250)
                                      .clamp(1, 5),
                              childAspectRatio: 1.5,
                              padding: EdgeInsets.all(20.w),
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 40,
                              children: List.generate(
                                  controller.allJobCards.length, (index) {
                                final data = controller.allJobCards[index];

                                final cardColor =
                                    cardColors[index % cardColors.length];

                                return HoverCard(
                                  emoji:
                                      '${data['car_brand']} ${data['car_model']}',
                                  name:
                                      '${data['plate_number']}  |  ${data['color']}',
                                  description: data['job_number'],
                                  color: cardColor,
                                  onTap: () {
                                    controller.selectedJob.value =
                                        '${data['car_brand']} ${data['car_model']} - ${data['plate_number']} - ${data['color']}';
                                    controller.selectedJobId.value = data['id'];
                                    Get.back();
                                  },
                                );
                              }),
                            ),
                );
              }))
            ],
          ),
        ),
      ));
}
