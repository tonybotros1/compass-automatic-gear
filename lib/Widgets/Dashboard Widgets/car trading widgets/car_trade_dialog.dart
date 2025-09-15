import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import 'add_or_edit_car_trade.dart';

Future<dynamic> carTradesDialog({
  required CarTradingDashboardController controller,
  required bool canEdit,
  required String tradeID,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: mainColor,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(
                        'Car Trading',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      GetX<CarTradingDashboardController>(
                        builder: (controller) {
                          return controller.status.value != ''
                              ? statusBox(controller.status.value)
                              : const SizedBox();
                        },
                      ),
                      const Spacer(),
                      tradeID != ''
                          ? ElevatedButton(
                              style: closeButtonStyle,
                              onPressed: () {
                                alertDialog(
                                  context: context,
                                  content:
                                      "The trade will be deleted permanently",
                                  onPressed: () {
                                    // controller.deleteTrade(tradeID);
                                  },
                                );
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : const SizedBox(),
                      GetX<CarTradingDashboardController>(
                        builder: (controller) {
                          return controller.currentTradId.value != ''
                              ? ElevatedButton(
                                  style: postButtonStyle,
                                  onPressed: () {
                                    // controller.changeStatus(
                                    //   controller.currentTradId.value,
                                    //   'Sold',
                                    // );
                                    // controller.status.value = 'Sold';
                                  },
                                  child: const Text(
                                    'Sold',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                      GetX<CarTradingDashboardController>(
                        builder: (controller) => ElevatedButton(
                          onPressed: onPressed,
                          style: new2ButtonStyle,
                          child: controller.addingNewValue.value == false
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
                        ),
                      ),
                      closeButton,
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: addNewCarTradeOrEdit(
                      constraints: constraints,
                      context: context,
                      controller: controller,
                      canEdit: canEdit,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
