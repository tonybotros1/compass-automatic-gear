
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../../consts.dart';
import 'add_or_edit_new_value_for_lists.dart';

Future<dynamic> valuesDialog(
    {required BoxConstraints constraints,
    required ListOfValuesController controller,
    required void Function()? onPressed}) {
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
                      '📃 Values',
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    Spacer(),
                    GetX<ListOfValuesController>(
                        builder: (controller) => ElevatedButton(
                              onPressed: onPressed,
                              style: new2ButtonStyle,
                              child:
                                  controller.addingNewListValue.value == false
                                      ? const Text(
                                          'Save',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                      child: addNewValueOrEdit(
                        controller: controller,
                      )))
            ],
          ),
        ),
      ));
}
