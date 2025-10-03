import 'package:datahubai/Controllers/Main%20screen%20controllers/banks_and_others_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../text_button.dart';
import 'add_or_edit_new_bank.dart';

Future<dynamic> banksDialog({
  required BoxConstraints constraints,
  required BanksAndOthersController controller,
  required bool canEdit,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 400,
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
                  GetX<BanksAndOthersController>(
                    builder: (controller) => ClickableHoverText(
                      onTap: onPressed,
                      text: controller.addingNewValue.value == false
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
                child: addNewBankOrEdit(
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
