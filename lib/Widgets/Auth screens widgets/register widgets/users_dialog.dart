import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/users_controller.dart';
import '../../../consts.dart';
import 'add_new_user_and_view.dart';

Future<dynamic> usersDialog(
    {required BoxConstraints constraints,
    required UsersController controller,
    required context,
    required bool canEdit,
    required userExpiryDate,
    required void Function()? onPressed}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth / 2.5,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
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
                    Spacer(),
                    Obx(() => ElevatedButton(
                          onPressed: onPressed,
                          style: new2ButtonStyle,
                          child: controller.sigupgInProcess.value == false
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
                        )),
                    closeButton
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: addNewUserAndView(
                  canEdit: canEdit,
                  controller: controller,
                  constraints: constraints,
                  context: context,
                  userExpiryDate: userExpiryDate,
                ),
              ))
            ],
          ),
        ),
      ));
}
