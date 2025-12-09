import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../../consts.dart';
import 'add_or_edit_new_value_for_lists.dart';

Future<dynamic> valuesDialog({
  required BoxConstraints constraints,
  required ListOfValuesController controller,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 300,
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
                  Text('📃 Values', style: fontStyleForScreenNameUsedInButtons),
                  const Spacer(),
                  GetX<ListOfValuesController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.addingNewListValue.value == false
                          ? 'Save'
                          : '•••',
                    ),
                  ),
                  separator(),
                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewValueOrEdit(controller: controller),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
