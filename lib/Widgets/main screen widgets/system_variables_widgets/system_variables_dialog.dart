import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/system_variables_controller.dart';
import '../../../consts.dart';
import 'add_new_variable_or_edit.dart';

Future<dynamic> systemVariablesDialog(
    {required BoxConstraints constraints,
    required SystemVariablesController controller,
    required void Function()? onPressed,
    required bool canEdit}) {
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
                    ElevatedButton(
                      onPressed: onPressed,
                      style: new2ButtonStyle,
                      child: controller.addingNewValue.value == false
                          ? const Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
                    closeButton
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: addNewVariableOrEdit(
                  controller: controller,
                  canEdit: canEdit,
                ),
              ))
            ],
          ),
        ),
      ));
}
