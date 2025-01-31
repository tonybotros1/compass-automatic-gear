import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allCurrencies = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCurrencies =
      RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');

  @override
  void onInit() {
    getCompanyId().then((_) {
      getAllCurrencies();
    });
    search.value.addListener(() {
      filterCurrencies();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCurrencies.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allCurrencies.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCurrencies.sort((counter1, counter2) {
        final String? value1 = counter1.get('rate');
        final String? value2 = counter2.get('rate');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allCurrencies.sort((counter1, counter2) {
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

  getAllCurrencies() {
    try {
      FirebaseFirestore.instance
          .collection('currencies')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((currencies) {
        allCurrencies.assignAll(currencies.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  addNewCurrency() async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance.collection('currencies').add({
        'code': code.text,
        'name': name.text,
        'rate': double.parse(rate.text),
        'added_date': DateTime.now().toString(),
        'company_id': companyId.value,
        'status': true,
      });
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  editCurrency(currencyId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('currencies')
          .doc(currencyId)
          .update({
        'code': code.text,
        'name': name.text,
        'rate': double.parse(rate.text),
      });
    } catch (e) {
        //
    }
  }

// this functions is to change the counter status from active / inactive
  changeCurrencyStatus(currencyId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('currencies')
          .doc(currencyId)
          .update({'status': status});
    } catch (e) {
      //
    }
  }

  deleteCurrency(currencyId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('currencies')
          .doc(currencyId)
          .delete();
    } catch (e) {
      //
    }
  }

  // this function is to filter the search results for web
  void filterCurrencies() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCurrencies.clear();
    } else {
      filteredCurrencies.assignAll(
        allCurrencies.where((saleman) {
          return saleman['code'].toString().toLowerCase().contains(query) ||
              saleman['name'].toString().toLowerCase().contains(query) ||
              saleman['rate'].toString().toLowerCase().contains(query) ||
              saleman['added_date'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
