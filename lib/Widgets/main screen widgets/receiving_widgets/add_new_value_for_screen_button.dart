import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';

Future<dynamic> addNewValueToScreenButtonDialog({
  required String screenName,
  required Widget widget,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  color: mainColor,
                ),
                padding: const EdgeInsets.all(16),
                width: constraints.maxWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth - 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          screenName,
                          style: fontStyleForScreenNameUsedInButtons,
                        ),
                        closeIcon(),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: widget,
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
