import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:datahubai/Models/job%20tasks/job_tasks_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/time_sheets_controller.dart';
import '../../../consts.dart';
import '../first_main_screen_widgets/first_main_screen.dart';

Future<dynamic> taskDialog({
  required BoxConstraints constraints,
  required TimeSheetsController controller,
  required BuildContext context,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.all(8),
      child: SizedBox(
        // height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: mainColor,
              ),
              child: Row(
                spacing: 10,
                children: [
                  Text(
                    '⚒️ Job Tasks',
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  closeButton,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GetX<TimeSheetsController>(
                builder: (controller) {
                  return CustomSlidingSegmentedControl<int>(
                    height: 60,
                    fixedWidth: 100,
                    initialValue: 1,
                    children: controller.buildSegmentedButtons(
                      controller.allTasks.isEmpty
                          ? []
                          : controller.allTasks
                                .map((task) => task.category)
                                .toSet()
                                .toList(),
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.lightBackgroundGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    thumbDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(1),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                          offset: const Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInToLinear,
                    onValueChanged: (v) {
                      controller.onChooseForLabelPicker(v);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: GetX<TimeSheetsController>(
                builder: (controller) {
                  return Padding(
                    padding: const EdgeInsetsGeometry.all(16),
                    child:
                        controller.isScreenLodingForJobTasks.isFalse &&
                            controller.allTasks.isEmpty
                        ? const Center(child: Text('Empty'))
                        : controller.isScreenLodingForJobTasks.isTrue
                        ? Center(child: loadingProcess)
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              return GridView.count(
                                crossAxisCount: (constraints.maxWidth ~/ 250)
                                    .clamp(1, 5),
                                childAspectRatio: 1.5,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 40,
                                children: List.generate(
                                  controller.filteredTasks.isEmpty
                                      ? controller.allTasks.length
                                      : controller.filteredTasks.length,
                                  (index) {
                                    JobTasksModel task =
                                        controller.filteredTasks.isEmpty
                                        ? controller.allTasks[index]
                                        : controller.filteredTasks[index];
                                    String taskENName = task.nameEN ?? '';
                                    String taskARName = task.nameAR ?? '';

                                    final cardColor =
                                        cardColors[index % cardColors.length];

                                    return HoverCard(
                                      emoji: taskENName,
                                      name: taskARName,
                                      description: task.category ?? '',
                                      color: cardColor,
                                      onTap: () {
                                        controller.selectedTask.value =
                                            '$taskENName - $taskARName';
                                        controller.selectedTaskId.value =
                                            task.id;
                                        Get.back();
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
