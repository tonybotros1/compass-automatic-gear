import 'package:datahubai/Controllers/Main%20screen%20controllers/technician_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_technician_or_edit.dart';

Future<dynamic> technicianDialog(
    {required BoxConstraints constraints,
    required TechnicianController controller,
    required bool canEdit,
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
                    GetX<TechnicianController>(
                        builder: (controller) => ClickableHoverText(
                              onTap: onPressed,
                              text: controller.addingNewValue.value == false
                                  ? 'Save' : "•••"
                            )),
                            separator(),
                    closeIcon()
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: addNewTechnicianOrEdit(
                    controller: controller, canEdit: canEdit),
              ))
            ],
          ),
        ),
      ));
}
