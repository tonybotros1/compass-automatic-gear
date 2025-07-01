import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApPaymentTypeController extends GetxController {
  TextEditingController type = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allApPaymentTypes =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredApPaymentTypes =
      RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString companyId = RxString('');
  RxBool addingNewValue = RxBool(false);

  @override
  void onInit() async {
    await getCompanyId();
    getAllApPayementTypes();
    search.value.addListener(() {
      filterTypes();
    });
    super.onInit();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  getAllApPayementTypes() {
    try {
      FirebaseFirestore.instance
          .collection('ap_payment_types')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((types) {
        allApPaymentTypes.assignAll(List<DocumentSnapshot>.from(types.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      //
    }
  }

  addNewType() {
    try {
      addingNewValue.value = true;
      FirebaseFirestore.instance.collection('ap_payment_types').add({
        'type': type.text,
        'added_date': DateTime.now(),
        'company_id': companyId.value
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      showSnackBar('Alert', 'Something Went Wrong Please Try Again Later');
    }
  }

  editType(id) {
    try {
      Get.back();

      FirebaseFirestore.instance
          .collection('ap_payment_types')
          .doc(id)
          .update({'type': type.text});
    } catch (e) {
      showSnackBar('Alert', 'Something Went Wrong Please Try Again Later');
    }
  }

  deleteType(id) {
    try {
      Get.back();

      FirebaseFirestore.instance
          .collection('ap_payment_types')
          .doc(id)
          .delete();
    } catch (e) {
      showSnackBar('Alert', 'Something Went Wrong Please Try Again Later');
    }
  }

  // this function is to filter the search results for web
  void filterTypes() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredApPaymentTypes.clear();
    } else {
      filteredApPaymentTypes.assignAll(
        allApPaymentTypes.where((type) {
          return type['type'].toString().toLowerCase().contains(query) ||
              textToDate(type['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
