import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/car_brands_controller.dart';
import '../../../consts.dart';
import 'add_new_brand_or_edit.dart';

Future<dynamic> carBrandsDialog(
    {required BoxConstraints constraints,
    required CarBrandsController controller,
    required void Function()? onPressed}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          height: 350,
          width: constraints.maxWidth / 2.5,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: mainColor,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      controller.getScreenName(),
                      style: fontStyleForScreenNameUsedInButtons,
                    ),
                    const Spacer(),
                    GetX<CarBrandsController>(
                        builder: (controller) => ElevatedButton(
                              onPressed: onPressed,
                              style: new2ButtonStyle,
                              child: controller.addingNewValue.value == false
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
                    closeButton,
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: addNewBrandOrEdit(
                  controller: controller,
                ),
              ))
            ],
          ),
        ),
      ));
}
