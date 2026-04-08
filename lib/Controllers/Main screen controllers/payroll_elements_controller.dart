import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_screen_contro.dart';

class PayrollElementsController extends GetxController {
  RxBool isScreenLoding = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  TextEditingController elementName = TextEditingController();
  TextEditingController elementType = TextEditingController();
  TextEditingController elementPriority = TextEditingController();
  TextEditingController elementKey = TextEditingController();
  RxBool allowOverride = RxBool(false);
  RxBool recurring = RxBool(false);
  RxBool entryValue = RxBool(false);
  RxBool standardLink = RxBool(false);

  RxInt initTypePickersValue = RxInt(1);

  RxMap elementTypes = RxMap({
    '1': {'name': 'Earning'},
    '2': {'name': 'Deduction'},
    '3': {'name': 'Information'},
  });

  @override
  void onInit() async {
    // connectWebSocket();
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }
}
