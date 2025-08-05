import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_screen_contro.dart';

class ReceivingController extends GetxController {
  RxString status = RxString('');
  Rx<TextEditingController> receivingNumber = TextEditingController().obs;
  Rx<TextEditingController> referenceNumber = TextEditingController().obs;
  Rx<TextEditingController> vendorNameIdFilterName =
      TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  RxString vendorNameIdFilter = RxString('');
  RxMap allVendors = RxMap({});
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  final ScrollController scrollControllerFotTable1 = ScrollController();
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxInt numberOfReceivingDocs = RxInt(0);
  RxDouble allReceivingVATS = RxDouble(0.0);
  RxDouble allReceivingTotals = RxDouble(0.0);
  RxDouble allReceivingNET = RxDouble(0.0);
  RxBool isScreenLoding = RxBool(false);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allReceivingDocs =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString curreentReceivingId = RxString('');

  @override
  void onInit() {
    super.onInit();
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }
}
