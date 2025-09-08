import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';

class CompanyController extends GetxController {
  RxBool isScreenLoding = RxBool(true);
  TextEditingController companyName = TextEditingController();
  Rx<TextEditingController> industry = TextEditingController().obs;
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

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

// this function is to get industries
  Future<void> getIndustries() async {
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

  Future<void> deletCompany(String companyId) async {
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

  Future<void> editActiveOrInActiveStatus(String companyId, bool status) async {
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

  Future<void> addNewCompany() async {
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

  Future<void> updateCompany(String companyID,String userId) async {
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

  void getCountries() {
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

  void getCitiesByCountryID(String countryID) {
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

  Future<String?> getCityName(String countryId,String cityId) async {
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

  String? getIndustryName(String industryId) {
    try {
      final industry = industryMap.entries.firstWhere(
        (industry) => industry.key == industryId,
      );
      return industry.value['name'];
    } catch (e) {
      return '';
    }
  }

 // this function is to select an image for logo
 Future<void> pickImage() async {
    try {
      // Use file_picker to pick an image file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Filter by image file types
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // Store the file bytes directly into imageBytes
        imageBytes = file.bytes;
        update(); // Trigger any necessary update in your controller
      }
    } catch (e) {
      // Handle error
      // print('Error picking image: $e');
    }
  }

  // this function is to remove a menu from the list
  void removeMenuFromList(int index) {
    roleIDFromList.removeAt(index);
  }

  // this function is to get Responsibilities
  void getResponsibilities() {
    FirebaseFirestore.instance
        .collection('sys-roles')
        .where('is_shown_for_users', isEqualTo: true)
        .snapshots()
        .listen((roles) {
      allRoles.value = {
        for (var doc in roles.docs) doc.id: doc.data()
        
      };
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
          matchingEntry.value['role_name'].replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();

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
  void getCompanies() {
    try {
      // Listen to the companies collection changes
      FirebaseFirestore.instance
          .collection('companies')
          .snapshots()
          .listen((companySnapshot) {
        // Update allCompanies with the latest data
        allCompanies
            .assignAll(List<DocumentSnapshot>.from(companySnapshot.docs));

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
