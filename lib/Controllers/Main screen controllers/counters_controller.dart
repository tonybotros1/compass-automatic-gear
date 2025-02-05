import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountersController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController prefix = TextEditingController();
  TextEditingController value = TextEditingController();
  TextEditingController length = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allCounters = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCounters =
      RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);

  @override
  void onInit() {
    getAllCounters();
    search.value.addListener(() {
      filterCounters();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCounters.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allCounters.sort((counter1, counter2) {
        final String? value1 = counter1.get('description');
        final String? value2 = counter2.get('description');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCounters.sort((counter1, counter2) {
        final String? value1 = counter1.get('prefix');
        final String? value2 = counter2.get('prefix');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allCounters.sort((counter1, counter2) {
        final String? value1 = counter1.get('value');
        final String? value2 = counter2.get('value');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 4) {
      allCounters.sort((counter1, counter2) {
        final String? value1 = counter1.get('added_date');
        final String? value2 = counter2.get('added_date');

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

  getAllCounters() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');

      FirebaseFirestore.instance
          .collection('counters')
          .where('company_id', isEqualTo: companyId)
          .snapshots()
          .listen((contres) {
        allCounters.assignAll(contres.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  addNewCounter() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');
      await FirebaseFirestore.instance.collection('counters').add({
        'code': code.text,
        'description': description.text,
        'prefix': prefix.text,
        'value': int.parse(value.text),
        'added_date': DateTime.now().toString(),
        'company_id': companyId,
        'length':int.parse(length.text),
        'status': true,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  deleteCounter(counterId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('counters')
          .doc(counterId)
          .delete();
    } catch (e) {
      //
    }
  }

  editCounter(counterId) async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance
          .collection('counters')
          .doc(counterId)
          .update({
        'code': code.text,
        'description': description.text,
        'prefix': prefix.text,
        'value': int.parse(value.text),
        'length':int.parse(length.text),

      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

// this functions is to change the counter status from active / inactive
  changeCounterStatus(counterId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('counters')
          .doc(counterId)
          .update({'status': status});
    } catch (e) {
      //
    }
  }

  // this function is to filter the search results for web
  void filterCounters() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCounters.clear();
    } else {
      filteredCounters.assignAll(
        allCounters.where((saleman) {
          return saleman['code'].toString().toLowerCase().contains(query) ||
              saleman['description'].toString().toLowerCase().contains(query) ||
              saleman['prefix'].toString().toLowerCase().contains(query) ||
              saleman['value'].toString().toLowerCase().contains(query) ||
              textToDate(saleman['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
