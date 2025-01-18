import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompanyController extends GetxController {
  RxBool isScreenLoding = RxBool(true);
  TextEditingController companyName = TextEditingController();
  TextEditingController typeOfBusiness = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  final RxList<DocumentSnapshot> allCompanies = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCompanies =
      RxList<DocumentSnapshot>([]);

  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool warningForImage = RxBool(false);
  RxBool addingNewCompanyProcess = RxBool(false);
  Uint8List? imageBytes;
  RxList roleIDFromList = RxList([]);
  RxMap allRoles = RxMap({});
  RxList allCountries = RxList([]);
  RxList allCities = RxList([]);
  RxList filterdCitiesByCountry = RxList([]);

  @override
  void onInit() {
    getResponsibilities();
    getCountriesAndCities();
    getCompanies();
    search.value.addListener(() {
      filterCompanies();
    });
    super.onInit();
  }

  getCountriesAndCities() async {
    try {
      QuerySnapshot<Map<String, dynamic>> countries = await FirebaseFirestore.instance
          .collection('all_lists')
          .where('code', isEqualTo: 'COUNTRIES')
          .get();
      QuerySnapshot<Map<String, dynamic>> cities = await FirebaseFirestore.instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CITIES')
          .get();

      QueryDocumentSnapshot<Map<String, dynamic>> countriesDoc = countries.docs.first;
      QuerySnapshot<Map<String, dynamic>> countryValues = await countriesDoc.reference
          .collection('values')
          .where('available', isEqualTo: true)
          .get();
      QueryDocumentSnapshot<Map<String, dynamic>> citiesDoc = cities.docs.first;
      QuerySnapshot<Map<String, dynamic>> cityValues = await citiesDoc.reference
          .collection('values')
          .where('available', isEqualTo: true)
          .get();
      allCountries.value = [
        for (var country in countryValues.docs)
          {
            'name': country.data()['name'],
            'code': country.data()['code'],
            'restricted_by': country.data()['restricted_by'],
            'available': country.data()['available']
          }
      ];
      allCities.value = [
        for (var city in cityValues.docs)
          {
            'name': city.data()['name'],
            'code': city.data()['code'],
            'restricted_by': city.data()['restricted_by'],
            'available': city.data()['available']
          }
      ];
      update();
    } catch (e) {
      // print(e);
    }
  }

  onSelect(bool isCountry, String code) {
    if (isCountry) {
      filterdCitiesByCountry.clear();
      var query = code.toLowerCase();
      city.clear();
      filterdCitiesByCountry.assignAll(
        allCities.where((city) {
          return city['restricted_by'].toString().toLowerCase().contains(query);
        }).toList(),
      );
      update();
    }
  }

  // this function is to select an image for logo
  pickImage() async {
    try {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files.first;
          final reader = html.FileReader();

          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((event) async {
            if (reader.result != null) {
              imageBytes = reader.result as Uint8List;
              update();
            }
          });
        }
      });
    } catch (e) {
      //
    }
  }

  // this function is to remove a menu from the list
  removeMenuFromList(index) {
    roleIDFromList.removeAt(index);
  }

  // this function is to get Responsibilities
  getResponsibilities() async {
    var roles = await FirebaseFirestore.instance
        .collection('sys-roles')
        .where('is_shown_for_users', isEqualTo: true)
        .get();
    for (var role in roles.docs) {
      allRoles[role.id] = role.data()['role_name'];
    }
  }

  String getRoleName(String menuID) {
    try {
      // Find the entry with the matching key
      final matchingEntry = allRoles.entries.firstWhere(
        (entry) => entry.key == menuID,
        orElse: () => const MapEntry(
            '', 'Unknown'), // Handle cases where no match is found
      );
      final menuName =
          matchingEntry.value.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();

      return menuName;
    } catch (e) {
      print(e);
      return '';
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCompanies.sort((screen1, screen2) {
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCompanies.sort((screen1, screen2) {
        final String? value1 = screen1.get('routeName');
        final String? value2 = screen2.get('routeName');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 4) {
      allCompanies.sort((screen1, screen2) {
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

// this function is to get all companies registered in system
  getCompanies() {
    try {
      FirebaseFirestore.instance
          .collection('companies')
          .snapshots()
          .listen((company) {
        allCompanies.assignAll(company.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  // function to convert text to date and make the format dd-mm-yyyy
  textToDate(inputDate) {
    if (inputDate is String) {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(inputDate);
      String formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);

      return formattedDate;
    } else if (inputDate is DateTime) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(inputDate);

      return formattedDate;
    }
  }

  // this function is to filter the search results for web
  void filterCompanies() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCompanies.clear();
    } else {
      filteredCompanies.assignAll(
        allCompanies.where((company) {
          return company['company_name']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              company['added_date'].toString().toLowerCase().contains(query) ||
              company['contact_details']['country']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              company['contact_details']['city']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              company['contact_details']['phone']
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
