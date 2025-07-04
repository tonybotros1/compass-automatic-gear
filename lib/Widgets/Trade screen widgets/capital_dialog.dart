import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../Controllers/Trading Controllers/car_trading_controller.dart';
import 'add_or_edit_capital.dart';

Future<dynamic> capitalOrOutstandingOrGeneralExpensesDialog(
    {required CarTradingController controller,
    required bool canEdit,
    required String screenName,
    required RxList<DocumentSnapshot<Object?>> map,
    required RxList<DocumentSnapshot<Object?>> filteredMap,
    required String collection,
    required Rx<TextEditingController> search,
    required bool isGeneralExpenses}) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        insetPadding: EdgeInsets.all(8),
        child: LayoutBuilder(builder: (context, constraints) {
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
                        topRight: Radius.circular(5)),
                    color: mainColor,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(
                        screenName,
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      Spacer(),
                      closeButton
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
                      canEdit: canEdit),
                ))
              ],
            ),
          );
        }),
      ));
}
