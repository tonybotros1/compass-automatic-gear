import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/capitals_outstanding_model.dart';
import '../../../consts.dart';
import 'add_new_capital_outstanding.dart';

Future<dynamic> capitalOrOutstanding({
  required CarTradingDashboardController controller,
  required bool canEdit,
  required String screenName,
  required RxList<CapitalsAndOutstandingModel> map,
  required RxList<CapitalsAndOutstandingModel> filteredMap,
  required String collection,
  required Rx<TextEditingController> search,
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
                        screenName,
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      closeIcon(),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: addNewCapitalOrOutstandingOrEdit(
                      search: search,
                      collection: collection,
                      map: map,
                      filteredMap: filteredMap,
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
