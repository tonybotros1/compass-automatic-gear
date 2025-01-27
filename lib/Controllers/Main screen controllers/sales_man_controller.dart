import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesManController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController target = TextEditingController();

  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allSalesMan = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredSalesMan =
      RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);

  @override
  void onInit() {
    getSalesMan();
    search.value.addListener(() {
      filterSalesMan();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allSalesMan.sort((screen1, screen2) {
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allSalesMan.sort((screen1, screen2) {
        final String? value1 = screen1.get('target');
        final String? value2 = screen2.get('target');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allSalesMan.sort((screen1, screen2) {
        final String? value1 = screen1.get('added_date');
        final String? value2 = screen2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  getSalesMan() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');

      FirebaseFirestore.instance
          .collection('sales_man')
          .where('company_id', isEqualTo: companyId)
          .snapshots()
          .listen((salesman) {
        allSalesMan.assignAll(salesman.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  deleteSaleman(salemanId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('sales_man')
          .doc(salemanId)
          .delete();
    } catch (e) {
      //
    }
  }

  addNewSaleMan() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');

      await FirebaseFirestore.instance.collection('sales_man').add({
        'name': name.text,
        'target': int.parse(target.text),
        'added_date': DateTime.now().toString(),
        'company_id': companyId,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  editSaleMan(saleManId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('sales_man')
          .doc(saleManId)
          .update({
        'name': name.text,
        'target': int.parse(target.text),
      });

    } catch (e) {
      //
    }
  }

  // this function is to filter the search results for web
  void filterSalesMan() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredSalesMan.clear();
    } else {
      filteredSalesMan.assignAll(
        allSalesMan.where((saleman) {
          return saleman['name'].toString().toLowerCase().contains(query) ||
              saleman['target'].toString().toLowerCase().contains(query) ||
              saleman['added_date'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
