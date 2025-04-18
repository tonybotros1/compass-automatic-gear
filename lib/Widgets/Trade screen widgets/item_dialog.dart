import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../Controllers/Trading Controllers/car_trading_controller.dart';
import 'add_new_item.dart';

Future<dynamic> itemDialog(
    {required CarTradingController controller,
    required bool canEdit,
    required void Function()? onPressed}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        insetPadding: EdgeInsets.all(8),
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            height: 550,
            width: constraints.maxWidth / 2.5,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: mainColor,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(
                        '🧾 Items',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      GetX<CarTradingController>(
                          builder: (controller) => ElevatedButton(
                                onPressed: onPressed,
                                style: new2ButtonStyle,
                                child: controller.addingNewValue.value == false
                                    ? const Text(
                                        'Ok',
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
                  padding: const EdgeInsets.all(16),
                  child: addNewItemOrEdit(
                    constraints: constraints,
                      context: context,
                      controller: controller,
                      canEdit: canEdit),
                ))
              ],
            ),
          );
        }),
      ));
}
