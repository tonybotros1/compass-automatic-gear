import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_item.dart';

Future<dynamic> itemDialog({
  required CarTradingDashboardController controller,
  required bool canEdit,
  required bool isTrade,
  required bool isGeneralExpenses,
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
            height: 550,
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
                          onTap: isTrade && controller.addingNewValue.isTrue
                              ? null
                              : onPressed,
                          text: isTrade == true ? 'Ok' : 'Save',
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
                    child: addNewItemOrEdit(
                      isGeneralExpenses: isGeneralExpenses,
                      isTrade: isTrade,
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
