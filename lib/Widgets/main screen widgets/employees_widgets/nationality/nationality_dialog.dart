import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import 'add_new_nationality_or_edit.dart';

Future<dynamic> nationalityDialog({
  required EmployeesController controller,
  required bool canEdit,
  required BuildContext context,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 350,
        width: 500,
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
                    'Nationality',
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  ClickableHoverText(onTap: onPressed, text: 'Ok'),
                  separator(),
                  closeIcon(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewNationalityOrEdit(
                  controller: controller,
                  canEdit: canEdit,
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
