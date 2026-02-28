import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../text_button.dart';
import 'add_new_sales_agreement_item_or_edit.dart';

Future<dynamic> salesAgreementItemDialog({
  required CarTradingDashboardController controller,
  required bool canEdit,
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
            height: 850,
            width: 1000,
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
                        '🧾 Sales Agreement Items',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      GetX<CarTradingDashboardController>(
                        builder: (controller) => ClickableHoverText(
                          onTap: controller.addingPurchaseAgreement.isFalse
                              ? onPressed
                              : null,
                          text: controller.addingPurchaseAgreement.isFalse
                              ? 'Save'
                              : '•••',
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
                    child: addNewSalesAgreementItemOrEdit(
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
