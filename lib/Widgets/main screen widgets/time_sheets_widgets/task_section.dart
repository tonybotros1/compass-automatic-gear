import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/time_sheets_controller.dart';
import '../../../consts.dart';
import '../first_main_screen_widgets/first_main_screen.dart';

Future<dynamic> taskDialog(
    {required BoxConstraints constraints,
    required TimeSheetsController controller,
    required BuildContext context}) {
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
                      topRight: Radius.circular(15)),
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
                    closeButton
                  ],
                ),
              ),
              Expanded(child: GetX<TimeSheetsController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsetsGeometry.all(16),
                  child: controller.isScreenLoding.isFalse &&
                          controller.allTechnician.isEmpty
                      ? const Center(
                          child: Text('Empty'),
                        )
                      : controller.isScreenLoding.isTrue
                          ? Center(
                              child: loadingProcess,
                            )
                          : LayoutBuilder(builder: (context, constraints) {
                              return GridView.count(
                                crossAxisCount: (constraints.maxWidth ~/ 250)
                                    .clamp(1, 5)
                                  ,
                                childAspectRatio: 1.5,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 40,
                                children: List.generate(
                                    controller.allTasks.length, (index) {
                                  final tec = controller.allTasks[index];
                                  final data =
                                      tec.data() as Map<String, dynamic>? ?? {};
                                  String taskENName = data['name_en'] ?? '';
                                  String taskARName = data['name_ar'] ?? '';

                                  final cardColor =
                                      cardColors[index % cardColors.length];

                                  return HoverCard(
                                    emoji: taskENName,
                                    name: taskARName,
                                    description: '',
                                    color: cardColor,
                                    onTap: () {
                                      controller.selectedTask.value =
                                          '$taskENName - $taskARName';
                                      controller.selectedTaskId.value = tec.id;
                                      Get.back();
                                    },
                                  );
                                }),
                              );
                            }),
                );
              }))
            ],
          ),
        ),
      ));
}
