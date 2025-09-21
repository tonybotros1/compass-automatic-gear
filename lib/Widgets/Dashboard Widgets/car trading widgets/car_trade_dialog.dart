import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
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

                      GetX<CarTradingDashboardController>(
                        builder: (controller) {
                          return controller.currentTradId.value != ''
                              ? Row(
                                  spacing: 10,
                                  children: [
                                    separator(),

                                    ClickableHoverText(
                                      onTap: () {
                                        controller.status.value = 'Sold';
                                        controller.carModified.value = true;
                                      },
                                      text: 'Sold',
                                    ),
                                    point(),
                                    ClickableHoverText(
                                      onTap: () {
                                        controller.status.value = 'New';
                                        controller.carModified.value = true;
                                      },
                                      text: 'New',
                                    ),
                                  ],
                                )
                              : const SizedBox();
                        },
                      ),
                      separator(),
                      Row(
                        spacing: tradeID != '' ? 10 : 0,
                        children: [
                          GetX<CarTradingDashboardController>(
                            builder: (controller) {
                              return ClickableHoverText(
                                onTap: onPressed,
                                text: controller.addingNewValue.value == false
                                    ? 'Save'
                                    : "...",
                              );
                            },
                          ),
                          tradeID != ''
                              ? Row(
                                  spacing: 10,
                                  children: [
                                    point(),

                                    ClickableHoverText(
                                      onTap: () {
                                        alertDialog(
                                          context: context,
                                          content:
                                              "The trade will be deleted permanently",
                                          onPressed: () {
                                            controller.deleteTrade(tradeID);
                                          },
                                        );
                                      },
                                      text: "Delete",
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                      separator(),
                      closeIcon(),
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
