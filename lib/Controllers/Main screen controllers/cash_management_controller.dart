import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_screen_contro.dart';

class CashManagementController extends GetxController {
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allCashsManagements =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCashsManagements =
      RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  final GlobalKey<FormState> formKeyForAddingNewvalue = GlobalKey<FormState>();
  RxBool addingNewValue = RxBool(false);

  @override
  void onInit() {
    getAllCashes();
    search.value.addListener(() {
      // filterCities();
    });
    super.onInit();
  }

    getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  getAllCashes() {
    try {
      // FirebaseFirestore.instance
      //     .collection('all_countries')
      //     .snapshots()
      //     .listen((countries) {
      //   allCountries.assignAll(List<DocumentSnapshot>.from(countries.docs));
      //   isScreenLoding.value = false;
      // });
      isScreenLoding.value = false;

    } catch (e) {
      isScreenLoding.value = false;
    }
  }
}
