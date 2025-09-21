import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import 'add_or_edit_capital.dart';

Future<dynamic> capitalOrOutstandingOrGeneralExpensesDialog({
  required CarTradingDashboardController controller,
  required bool canEdit,
  required String screenName,
  required RxList map,
  required RxList filteredMap,
  required String collection,
  required Rx<TextEditingController> search,
  required bool isGeneralExpenses,
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
                    child: addNewCapitalOrOutstandingOrGeneralExpensesOrEdit(
                      isGeneralExpenses: isGeneralExpenses,
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
