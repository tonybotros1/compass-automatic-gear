import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen_contro.dart';

class BranchesController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController line = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  RxString countryId = RxString('');
  RxString cityId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allBranches = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredBranches =
      RxList<DocumentSnapshot>([]);
  RxMap allCountries = RxMap({});
  RxMap allCities = RxMap({});

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');

  @override
  void onInit() async {
    await getCompanyId();
    getAllBranches();
    getCountries();
    search.value.addListener(() {
      filterBranches();
    });
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<void> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allBranches.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allBranches.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allBranches.sort((counter1, counter2) {
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

  // getCountriesAndCities() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> countries = await FirebaseFirestore
  //         .instance
  //         .collection('all_lists')
  //         .where('code', isEqualTo: 'COUNTRIES')
  //         .get();
  //     QuerySnapshot<Map<String, dynamic>> cities = await FirebaseFirestore
  //         .instance
  //         .collection('all_lists')
  //         .where('code', isEqualTo: 'CITIES')
  //         .get();

  //     var countriesId = countries.docs.first.id;
  //     var citiesId = cities.docs.first.id;

  //     FirebaseFirestore.instance
  //         .collection('all_lists')
  //         .doc(countriesId)
  //         .collection('values')
  //         .where('available', isEqualTo: true)
  //         .snapshots()
  //         .listen((countries) {
  //       allCountries.value = {
  //         for (var doc in countries.docs) doc.id: doc.data()
  //       };
  //     });

  //     FirebaseFirestore.instance
  //         .collection('all_lists')
  //         .doc(citiesId)
  //         .collection('values')
  //         .where('available', isEqualTo: true)
  //         .snapshots()
  //         .listen((cities) {
  //       allCities.value = {for (var doc in cities.docs) doc.id: doc.data()};
  //     });
  //     update();
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

  void getCountries() {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .snapshots()
          .listen((countries) {
        allCountries.value = {
          for (var doc in countries.docs) doc.id: doc.data()
        };
      });
    } catch (e) {
      //
    }
  }

  void getCitiesByCountryID(String countryID) {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryID)
          .collection('values')
          .snapshots()
          .listen((cities) {
        allCities.value = {for (var doc in cities.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  String? getCountryName(String countryId) {
    try {
      final country = allCountries.entries.firstWhere(
        (country) => country.key == countryId,
      );
      return country.value['name'];
    } catch (e) {
      return '';
    }
  }

  Future<String?> getCityName(String countryId, String cityId) async {
    try {
      var cities = await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .collection('values')
          .where(FieldPath.documentId, isEqualTo: cityId)
          .get();
      String cityName = cities.docs.first.data()['name'];

      return cityName;
    } catch (e) {
      return '';
    }
  }

  void getAllBranches() {
    try {
      FirebaseFirestore.instance
          .collection('branches')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((branches) {
        allBranches.assignAll(List<DocumentSnapshot>.from(branches.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewBranch() async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance.collection('branches').add({
        'code': code.text,
        'name': name.text,
        'line': line.text,
        'country_id': countryId.value,
        'city_id': cityId.value,
        'added_date': DateTime.now().toString(),
        'company_id': companyId.value,
        'status': true,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> deleteBranch(String branchId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('branches')
          .doc(branchId)
          .delete();
    } catch (e) {
      //
    }
  }

// this functions is to change the counter status from active / inactive
  Future<void> changeBranchStatus(String branchId,bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('branches')
          .doc(branchId)
          .update({'status': status});
    } catch (e) {
      //
    }
  }

  Future<void> editBranch(String branchId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('branches')
          .doc(branchId)
          .update({
        'code': code.text,
        'name': name.text,
        'line': line.text,
        'country_id': countryId.value,
        'city_id': cityId.value,
      });
    } catch (e) {
      //
    }
  }

  // this function is to filter the search results for web
  void filterBranches() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredBranches.clear();
    } else {
      filteredBranches.assignAll(
        allBranches.where((saleman) {
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
