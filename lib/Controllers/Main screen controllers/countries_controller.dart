import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts.dart';

class CountriesController extends GetxController {
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  TextEditingController currency = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  TextEditingController cityCode = TextEditingController();
  TextEditingController countryName = TextEditingController();
  TextEditingController cityName = TextEditingController();
  TextEditingController countryCallingCode = TextEditingController();
  TextEditingController currencyRate = TextEditingController();
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allCountries = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allCities = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCities = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCountries =
      RxList<DocumentSnapshot>([]);
  RxString queryForCities = RxString('');
  Rx<TextEditingController> searchForCities = TextEditingController().obs;
  RxBool loadingcities = RxBool(false);
  final GlobalKey<FormState> formKeyForAddingNewvalue = GlobalKey<FormState>();

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxMap allCurrencies = RxMap({});
  RxString currencyId = RxString('');
  RxBool addingNewCityValue = RxBool(false);
  RxString countryIdToWorkWith = RxString('');
  RxBool flagSelectedError = RxBool(false);
  Rx<Uint8List> imageBytes = Uint8List(0).obs;
  RxString flagUrl = RxString('');

  @override
  void onInit() {
    getCurrencies();
    getAllCountries();
    search.value.addListener(() {
      filterCountries();
    });
    searchForCities.value.addListener(() {
      filterCities();
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
    } else if (columnIndex == 2) {
      allCountries.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 4) {
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

  void onSortForCities(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCities.sort((screen1, screen2) {
        final String? value1 = screen1.get('code');
        final String? value2 = screen2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allCities.sort((screen1, screen2) {
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCities.sort((screen1, screen2) {
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
        allCountries.assignAll(List<DocumentSnapshot>.from(countries.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  editCountries(countryId) async {
    try {
      addingNewValue.value = true;
      var newData = {
        'code': countryCode.text,
        'name': countryName.text,
        'calling_code': countryCallingCode.text,
        'based_currency': currencyId.value,
      };
      if (imageBytes.value.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'brands_logos/${formatPhrase(countryName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes.value,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          flagUrl.value = await storageRef.getDownloadURL();
          newData['flag'] = flagUrl.value;
        });
      }
      await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .update(newData);
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  String formatPhrase(String phrase) {
    return phrase.replaceAll(' ', '_');
  }

  addNewCountry() async {
    try {
      addingNewValue.value = true;
      if (imageBytes.value.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'brands_logos/${formatPhrase(countryName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes.value,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          flagUrl.value = await storageRef.getDownloadURL();
        });
      }
      FirebaseFirestore.instance.collection('all_countries').add({
        'code': countryCode.text,
        'name': countryName.text,
        'calling_code': countryCallingCode.text,
        'based_currency': currencyId.value,
        'status': true,
        'added_date': DateTime.now().toString(),
        'flag': flagUrl.value,
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

  getCurrencyCodeName(String currencyId) {
    try {
      final currency = allCurrencies.entries.firstWhere(
        (currency) => currency.key == currencyId,
      );
      return currency.value;
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

  // this function is to filter the search results for web
  void filterCities() {
    queryForCities.value = searchForCities.value.text.toLowerCase();
    if (queryForCities.value.isEmpty) {
      filteredCities.clear();
    } else {
      filteredCities.assignAll(
        allCities.where((city) {
          return city['code']
                  .toString()
                  .toLowerCase()
                  .contains(queryForCities.value) ||
              city['name']
                  .toString()
                  .toLowerCase()
                  .contains(queryForCities.value) ||
              textToDate(city['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(queryForCities.value);
        }).toList(),
      );
    }
  }

  getCitiesValues(countryId) {
    try {
      loadingcities.value = true;

      FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .collection('values')
          .orderBy('name', descending: false)
          .snapshots()
          .listen((values) {
        allCities.assignAll(List<DocumentSnapshot>.from(values.docs));
        loadingcities.value = false;
      });
    } catch (e) {
      loadingcities.value = false;
    }
  }

  addNewCity(countryId) async {
    try {
      addingNewCityValue.value = true;
      await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .collection('values')
          .add({
        'code': cityCode.text,
        'name': cityName.text,
        'added_date': DateTime.now().toString(),
        'available': true,
      });
      addingNewCityValue.value = false;
      Get.back();
    } catch (e) {
      addingNewCityValue.value = false;
    }
  }

  deleteCity(countryId, cityId) {
    try {
      Get.back();
      FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .collection('values')
          .doc(cityId)
          .delete();
    } catch (e) {
      //
    }
  }

  editHideOrUnhide(countryId, cityId, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .collection('values')
          .doc(cityId)
          .update({
        'available': status,
      });
    } catch (e) {
//
    }
  }

  editcity(countryId, cityId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .collection('values')
          .doc(cityId)
          .update({
        'code': cityCode.text,
        'name': cityName.text,
      });
    } catch (e) {
//
    }
  }

  // this function is to select an image for logo
  pickImage() async {
    ImagePickerService.pickImage(imageBytes, flagSelectedError);
  }
}
