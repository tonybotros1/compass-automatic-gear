import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  RxMap filterdCitiesByCountry = RxMap({});
  RxMap allCities = RxMap({});

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');

  @override
  void onInit() {
    getCompanyId();
    getCountriesAndCities().then((_) {
      getAllBranches();
    });
    search.value.addListener(() {
      filterBranches();
    });
    super.onInit();
  }

  getCompanyId() async {
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

  getCountriesAndCities() async {
    try {
      QuerySnapshot<Map<String, dynamic>> countries = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'COUNTRIES')
          .get();
      QuerySnapshot<Map<String, dynamic>> cities = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CITIES')
          .get();

      var countriesId = countries.docs.first.id;
      var citiesId = cities.docs.first.id;

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(countriesId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((countries) {
        allCountries.value = {
          for (var doc in countries.docs) doc.id: doc.data()
        };
      });

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(citiesId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((cities) {
        allCities.value = {for (var doc in cities.docs) doc.id: doc.data()};
      });
      update();
    } catch (e) {
      // print(e);
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

  String? getCityName(String cityId) {
    try {
      final city = allCities.entries.firstWhere(
        (city) => city.key == cityId,
      );
      return city.value['name'];
    } catch (e) {
      return '';
    }
  }

  void onSelect(String selectedId) {
    filterdCitiesByCountry.clear();
    filterdCitiesByCountry.addAll(
      Map.fromEntries(
        allCities.entries.where((entry) {
          return entry.value['restricted_by']
              .toString()
              .toLowerCase()
              .contains(selectedId.toLowerCase());
        }),
      ),
    );
  }

  getAllBranches() {
    try {
      FirebaseFirestore.instance
          .collection('branches')
          .snapshots()
          .listen((branches) {
        allBranches.assignAll(branches.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  addNewBranch() async {
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

  deleteBranch(branchId) async {
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
  changeBranchStatus(branchId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('branches')
          .doc(branchId)
          .update({'status': status});
    } catch (e) {
      //
    }
  }

  editBranch(branchId) async {
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
