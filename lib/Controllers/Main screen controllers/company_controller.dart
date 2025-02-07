import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts.dart';

class CompanyController extends GetxController {
  RxBool isScreenLoding = RxBool(true);
  TextEditingController companyName = TextEditingController();
  TextEditingController industry = TextEditingController();
  RxString industryId = RxString('');
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  final RxList<DocumentSnapshot> allCompanies = RxList<DocumentSnapshot>([]);
  RxMap userDetails = RxMap({});
  final RxList<DocumentSnapshot> filteredCompanies =
      RxList<DocumentSnapshot>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool warningForImage = RxBool(false);
  RxBool addingNewCompanyProcess = RxBool(false);
  Uint8List? imageBytes = Uint8List(8);
  RxList roleIDFromList = RxList([]);
  RxMap allRoles = RxMap({});
  RxMap allCountries = RxMap({});
  RxMap allCities = RxMap({});
  // RxMap filterdCitiesByCountry = RxMap({});
  RxString selectedCountryId = RxString('');
  RxString selectedCityId = RxString('');
  RxString logoUrl = RxString('');
  RxMap industryMap = RxMap({});

  @override
  void onInit() {
    getCountries();
    getIndustries();
    getResponsibilities();
    getCompanies();

    search.value.addListener(() {
      filterCompanies();
    });
    super.onInit();
  }

// this function is to get industries
  getIndustries() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'INDUSTRIES')
        .get();

    var typrId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typrId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((business) {
      industryMap.value = {for (var doc in business.docs) doc.id: doc.data()};
    });
  }

  deletCompany(companyId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .delete();

      var users = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('company_id', isEqualTo: companyId)
          .get();

      for (var user in users.docs) {
        await user.reference.delete();
      }
    } catch (e) {
      //
    }
  }

  editActiveOrInActiveStatus(companyId, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .update({
        'status': status,
      });
    } catch (e) {
//
    }
  }

  addNewCompany() async {
    try {
      addingNewCompanyProcess.value = true;

      var userDataSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('email', isEqualTo: email.text) // Check for existing email
          .get();

      if (userDataSnapshot.docs.isNotEmpty) {
        addingNewCompanyProcess.value = false;
        showSnackBar(
            'Email already in use', 'This email is already registered');
        return;
      }

      if (imageBytes != null && imageBytes!.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'images/${formatPhrase(companyName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes!,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          logoUrl.value = await storageRef.getDownloadURL();
        });
      }

      var bytes = utf8.encode(password.text);
      var digest = sha256.convert(bytes);
      String hashedPassword = digest.toString();

      var newCompany =
          await FirebaseFirestore.instance.collection('companies').add({
        'company_logo': logoUrl.value,
        'company_name': companyName.text,
        'industry': industryId.value,
        'added_date': DateTime.now().toString(),
        'status': true,
        'contact_details': {
          'address': address.text,
          'city': selectedCityId.value,
          'country': selectedCountryId.value,
          'phone': phoneNumber.text,
        },
      });

      DateTime now = DateTime.now();
      DateTime expiryDate = DateTime(now.year, now.month + 1, now.day);

      var newUser =
          await FirebaseFirestore.instance.collection('sys-users').add({
        "user_name": userName.text,
        "email": email.text,
        "password": hashedPassword,
        "roles": roleIDFromList,
        "expiry_date": expiryDate.toString(),
        "added_date": DateTime.now().toString(),
        "status": true,
        "company_id": newCompany.id,
      });

      await FirebaseFirestore.instance
          .collection('companies')
          .doc(newCompany.id)
          .update({
        'contact_details': {
          'address': address.text,
          'city': selectedCityId.value,
          'country': selectedCountryId.value,
          'phone': phoneNumber.text,
          'user_id': newUser.id,
        },
      });

      addingNewCompanyProcess.value = false;
    } catch (e) {
      addingNewCompanyProcess.value = false;
    }
  }

  updateCompany(companyID, userId) async {
    try {
      addingNewCompanyProcess.value = true;

      var newCompanyData = {
        'company_name': companyName.text,
        'industry': industryId.value,
        'contact_details': {
          'address': address.text,
          'city': selectedCityId.value,
          'country': selectedCountryId.value,
          'phone': phoneNumber.text,
          'user_id': userId,
        }
      };

      if (imageBytes != null && imageBytes!.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'images/${formatPhrase(companyName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes!,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          logoUrl.value = await storageRef.getDownloadURL();
        });
        newCompanyData['company_logo'] = logoUrl.value;
      }

      var newUserData = {
        'user_name': userName.text,
        'roles': roleIDFromList,
      };
      if (password.text.isNotEmpty) {
        // Hash the password using SHA-256
        var bytes = utf8.encode(password.text); // Convert password to bytes
        var digest = sha256.convert(bytes); // Hash the password
        String hashedPassword = digest.toString();
        newUserData['password'] = hashedPassword;
      }

      await FirebaseFirestore.instance
          .collection('companies')
          .doc(companyID)
          .update(newCompanyData);

      await FirebaseFirestore.instance
          .collection('sys-users')
          .doc(userId)
          .update(newUserData);

      addingNewCompanyProcess.value = false;
      Get.back();
    } catch (e) {
      addingNewCompanyProcess.value = false;
    }
  }

// this function is to remove spaces from company name
  String formatPhrase(String phrase) {
    return phrase.replaceAll(' ', '_');
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
  getCountries() {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .snapshots()
          .listen((countries) {
        allCountries.value = {
          for (var doc in countries.docs) doc.id: doc.data()
        };
        update();
      });
    } catch (e) {
      //
    }
  }

  getCitiesByCountryID(countryID) {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryID)
          .collection('values')
          .snapshots()
          .listen((cities) {
        allCities.value = {for (var doc in cities.docs) doc.id: doc.data()};
        update();
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

  // void onSelect(String selectedId) {
  //   filterdCitiesByCountry.clear();
  //   filterdCitiesByCountry.addAll(
  //     Map.fromEntries(
  //       allCities.entries.where((entry) {
  //         return entry.value['restricted_by']
  //             .toString()
  //             .toLowerCase()
  //             .contains(selectedId.toLowerCase());
  //       }),
  //     ),
  //   );
  // }

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
  getResponsibilities() {
    FirebaseFirestore.instance
        .collection('sys-roles')
        .where('is_shown_for_users', isEqualTo: true)
        .snapshots()
        .listen((roles) {
      for (var role in roles.docs) {
        allRoles[role.id] = role.data()['role_name'];
      }
    });
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
      // print(e);
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
      // Listen to the companies collection changes
      FirebaseFirestore.instance
          .collection('companies')
          .snapshots()
          .listen((companySnapshot) {
        // Update allCompanies with the latest data
        allCompanies.assignAll(companySnapshot.docs);

        // Fetch user details for each company contact
        for (var com in companySnapshot.docs) {
          var userId = com.data()['contact_details']['user_id'];
          if (userId != null) {
            // Listen to the specific user document changes
            FirebaseFirestore.instance
                .collection('sys-users')
                .doc(userId)
                .snapshots()
                .listen((userSnapshot) {
              if (userSnapshot.exists) {
                userDetails[userSnapshot.id] = {
                  'user_name': userSnapshot.data()!['user_name'],
                  'email': userSnapshot.data()!['email'],
                  'roles': userSnapshot.data()!['roles'],
                };
              }
            });
          }
        }
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
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
