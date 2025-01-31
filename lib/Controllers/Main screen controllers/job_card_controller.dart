import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobCardController extends GetxController {
  TextEditingController jobCardCounter = TextEditingController();
  TextEditingController plateNumber = TextEditingController();
  TextEditingController carCode = TextEditingController();
  TextEditingController carBrand = TextEditingController();
  TextEditingController carModel = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  RxString carBrandId = RxString('');
  RxString carModelId = RxString('');
  RxString countryId = RxString('');
  RxString cityId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allJobCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredJobCards =
      RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  RxMap allCountries = RxMap({});
  RxMap filterdCitiesByCountry = RxMap({});
  RxMap allCities = RxMap({});

  RxMap allBrands = RxMap({});
  RxMap filterdModelsByBrands = RxMap({});
  RxMap allModels = RxMap({});

  @override
  void onInit() async {
    super.onInit();
    await getCompanyId();
    await getCurrentJobCardCounterNumber();
    getCarsModelsAndBrands();
    getCountriesAndCities();
    getAllJobCards();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  getCurrentJobCardCounterNumber() async {
    try {
      var jcnId = '';
      var jcnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'JCN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (jcnDoc.docs.isEmpty) {
        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'JCN',
          'description': 'Job Card Number',
          'prefix': '',
          'value': 0,
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
          'status': true,
        });
        jcnId = newCounter.id;
      } else {
        jcnId = jcnDoc.docs.first.id;
      }
      FirebaseFirestore.instance
          .collection('counters')
          .doc(jcnId)
          .snapshots()
          .listen((jcnCounter) {
        jobCardCounter.text = (jcnCounter.data()!['value'] ?? '').toString();
      });
    } catch (e) {
      //
    }
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
    } catch (e) {
      // print(e);
    }
  }

  getCarsModelsAndBrands() async {
    try {
      QuerySnapshot<Map<String, dynamic>> brands = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CAR_BRANDS')
          .get();
      QuerySnapshot<Map<String, dynamic>> models = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CAR_MODELS')
          .get();

      var brandsId = brands.docs.first.id;
      var modelsId = models.docs.first.id;

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(brandsId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((models) {
        allBrands.value = {for (var doc in models.docs) doc.id: doc.data()};
      });

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(modelsId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((brands) {
        allModels.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      // print(e);
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allJobCards.sort((counter1, counter2) {
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

  getAllJobCards() {
    try {
      FirebaseFirestore.instance
          .collection('job_cards')
          .snapshots()
          .listen((jobCards) {
        allJobCards.assignAll(jobCards.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  void onSelectForBrandsAndModels(String selectedId) {
    filterdModelsByBrands.assignAll(
      Map.fromEntries(
        allModels.entries.where((entry) {
          return entry.value['restricted_by']
              .toString()
              .toLowerCase()
              .contains(selectedId.toLowerCase());
        }),
      ),
    );
    print(filterdModelsByBrands);
  }
}
