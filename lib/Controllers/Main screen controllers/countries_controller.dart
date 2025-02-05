import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts.dart';

class CountriesController extends GetxController {
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  TextEditingController currency = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  TextEditingController countryName = TextEditingController();
  TextEditingController countryCallingCode = TextEditingController();
  TextEditingController currencyRate = TextEditingController();
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allCountries = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCountries =
      RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxMap allCurrencies = RxMap({});
  RxString currencyId = RxString('');

  @override
  void onInit() {
    getCurrencies();
    getAllCountries();
    search.value.addListener(() {
      filterCountries();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCountries.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allCountries.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allCountries.sort((counter1, counter2) {
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

  getCurrencies() {
    FirebaseFirestore.instance
        .collection('currencies')
        .snapshots()
        .listen((branches) {
      allCurrencies.value = {for (var doc in branches.docs) doc.id: doc.data()};
    });
  }

  getAllCountries() {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .snapshots()
          .listen((countries) {
        allCountries.assignAll(countries.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  editCountries(countryId) async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .update({
        'code': countryCode.text,
        'name': countryName.text,
        'calling_code': countryCallingCode.text,
        'basd_currency': currencyId.value,
        'rate': currencyRate.text,
      });
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;

    }
  }

  addNewCountry() async {
    try {
      addingNewValue.value = true;
      FirebaseFirestore.instance.collection('all_countries').add({
        'code': countryCode.text,
        'name': countryName.text,
        'calling_code': countryCallingCode.text,
        'basd_currency': currencyId.value,
        'rate': currencyRate.text,
        'status': true,
        'added_date': DateTime.now().toString(),
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

// this functions is to change the counter status from active / inactive
  changeCountryStatus(countryId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .update({'status': status});
    } catch (e) {
      //
    }
  }

  deleteCountry(countryId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .delete();
    } catch (e) {
      //
    }
  }

  String? getCurrencyCodeName(String ccurrencyId) {
    try {
      final currency = allCurrencies.entries.firstWhere(
        (currency) => currency.key == currencyId,
      );
      return currency.value['code'];
    } catch (e) {
      return '';
    }
  }

  // this function is to filter the search results for web
  void filterCountries() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCountries.clear();
    } else {
      filteredCountries.assignAll(
        allCountries.where((saleman) {
          return saleman['code'].toString().toLowerCase().contains(query) ||
              saleman['name'].toString().toLowerCase().contains(query) ||
              textToDate(saleman['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
