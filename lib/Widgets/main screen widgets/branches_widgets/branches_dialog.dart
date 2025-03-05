import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/branches_controller.dart';
import '../../../consts.dart';
import 'add_new_branch_or_edit.dart';

Future<dynamic> branchesDialog(
    {required BoxConstraints constraints,
    required BranchesController controller,
    required bool canEdit,
    required void Function()? onPressed}) {
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
                    GetX<BranchesController>(
                        builder: (controller) => ElevatedButton(
                              onPressed: onPressed,
                              style:new2ButtonStyle,
                              child: controller.addingNewValue.value == false
                                  ? const Text(
                                      'Save',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  : SizedBox(
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
                child: addNewBranchOrEdit(
                    controller: controller, canEdit: canEdit),
              ))
            ],
          ),
        ),
      ));
}
