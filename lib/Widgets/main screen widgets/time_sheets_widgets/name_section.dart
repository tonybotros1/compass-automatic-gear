import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/time_sheets_controller.dart';
import '../../../consts.dart';
import '../first_main_screen_widgets/first_main_screen.dart';

Future<dynamic> nameDialog({
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
                    '🦺 Employee Names',
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
                        controller.isScreenLodingForTechnicians.isFalse &&
                            controller.allTechnician.isEmpty
                        ? const Center(child: Text('Empty'))
                        : controller.isScreenLodingForTechnicians.isTrue
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
                                  controller.allTechnician.length,
                                  (index) {
                                    final tec = controller.allTechnician.entries
                                        .elementAt(index);
                                    Map<String, dynamic> data = tec.value;
                                    String tecName = data.containsKey('name')
                                        ? data['name'] ?? ''
                                        : '';
                                    String tecJob = data.containsKey('job')
                                        ? data['job'] ?? ''
                                        : '';
                                    String tecid = tec.key;

                                    final cardColor =
                                        cardColors[index % cardColors.length];

                                    return HoverCard(
                                      emoji: tecName,
                                      name: tecJob,
                                      description: '',
                                      color: cardColor,
                                      onTap: () {
                                        if (controller.hasActiveTask(tecid) ==
                                            false) {
                                          controller
                                                  .selectedEmployeeName
                                                  .value =
                                              tecName;
                                          controller.selectedEmployeeId.value =
                                              tecid;
                                          Get.back();
                                        }
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
