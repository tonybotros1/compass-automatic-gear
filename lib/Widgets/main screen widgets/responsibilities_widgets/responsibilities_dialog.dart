import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/responsibilities_controller.dart';
import '../../../../Widgets/main screen widgets/responsibilities_widgets/add_new_responsibilities_or_view.dart';
import '../../../../consts.dart';

Future<dynamic> responsibilitiesDialog(
    {required BoxConstraints constraints,
    required ResponsibilitiesController controller,
    required void Function()? onPressed}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          height: 250,
          width: constraints.maxWidth / 2.5,
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
                      controller.getScreenName(),
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    const Spacer(),
                    GetX<ResponsibilitiesController>(builder: (controller) {
                      return ElevatedButton(
                        onPressed: onPressed,
                        style: new2ButtonStyle,
                        child: controller
                                    .addingNewResponsibilityProcess.value ==
                                false
                            ? const Text(
                                'Save',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                      );
                    }),
                    closeButton,
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewResponsibilityOrView(
                  controller: controller,
                ),
              ))
            ],
          ),
        ),
      ));
}
