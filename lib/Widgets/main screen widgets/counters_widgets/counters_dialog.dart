import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/counters_controller.dart';
import '../../../consts.dart';
import 'add_new_counter_or_edit.dart';

Future<dynamic> countersDialog({
  required BoxConstraints constraints,
  required CountersController controller,
  required bool canEdit,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 410,
        width: constraints.maxWidth / 2.5,
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
                    controller.getScreenName(),
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  GetX<CountersController>(
                    builder: (controller) => ElevatedButton(
                      onPressed: onPressed,
                      style: new2ButtonStyle,
                      child: controller.addingNewValue.value == false
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
                    ),
                  ),
                  closeButton,
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewConterOrEdit(
                  controller: controller,
                  canEdit: canEdit,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
