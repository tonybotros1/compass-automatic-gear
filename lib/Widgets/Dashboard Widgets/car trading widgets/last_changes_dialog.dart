import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'last_changes_screen.dart';

Future<dynamic> lastChangesDialog() {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: mainColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🔍 Last Changes',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      closeIcon(),
                    ],
                  ),
                ),
                Expanded(
                  child: lastChangesScreen(
                    constraints: constraints,
                    context: context,
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
