import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_transfer_item_or_edit.dart';

Future<dynamic> transferItemDialog({
  required CarTradingDashboardController controller,
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
            height: 600,
            width: 500,
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
                        '🧾 Items',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      GetBuilder<CarTradingDashboardController>(
                        builder: (controller) => ClickableHoverText(
                          onTap: controller.addingNewTransferValue.isTrue
                              ? null
                              : onPressed,
                          text: controller.addingNewTransferValue.isTrue
                              ? '•••'
                              : 'Save',
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
                    child: addNewTransferItemOrEdit(
                      constraints: constraints,
                      context: context,
                      controller: controller,
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
