import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/time_sheets_controller.dart';
import '../../../consts.dart';
import '../first_main_screen_widgets/first_main_screen.dart';

Future<dynamic> jobsDialog({
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
                    '💳 Approved Jobs',
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  closeButton,
                ],
              ),
            ),
            Expanded(
              child: GetX<TimeSheetsController>(
                builder: (controller) {
                  return Padding(
                    padding: const EdgeInsetsGeometry.all(16),
                    child:
                        controller.isScreenLodingForJobs.isFalse &&
                            controller.allJobCards.isEmpty
                        ? const Center(child: Text('Empty'))
                        : controller.isScreenLodingForJobs.isTrue
                        ? Center(child: loadingProcess)
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount =
                                  (constraints.maxWidth ~/ 250).clamp(1, 5);
                              return GridView.count(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 1.5,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 40,
                                children: List.generate(
                                  controller.allJobCards.length,
                                  (index) {
                                    final data = controller.allJobCards[index];
                                    final cardColor =
                                        cardColors[index % cardColors.length];

                                    return HoverCard(
                                      emoji: '${data.brand} ${data.model}',
                                      name:
                                          '${data.platNumber ?? ''} - ${data.plateCode ?? ''}',
                                      description: data.color ?? '',
                                      color: cardColor,
                                      onTap: () {
                                        controller.selectedJob.value =
                                            '${data.brand} ${data.model} - ${data.platNumber} - ${data.color}';
                                        controller.selectedJobId.value =
                                            data.id ?? '';
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
