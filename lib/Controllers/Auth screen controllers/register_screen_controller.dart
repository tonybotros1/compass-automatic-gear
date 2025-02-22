import 'dart:convert';
import 'dart:typed_data';
import 'package:datahubai/j_s_uint8_array_factory.dart';
import 'package:web/web.dart' as web;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/menu_model.dart';
import '../../Screens/Auth Screens/register_screen.dart';
import '../../consts.dart';

class RegisterScreenController extends GetxController {
  RxInt selectedMenu = RxInt(0);
  TextEditingController companyName = TextEditingController();
  TextEditingController industry = TextEditingController();
  RxString industryID = RxString('');
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  Uint8List? imageBytes;
  RxMap allRoles = RxMap({});
  RxMap allCountries = RxMap({});
  RxMap allCities = RxMap({});
  // RxMap filterdCitiesByCountry = RxMap({});
  RxList roleIDFromList = RxList([]);
  RxBool addingProcess = RxBool(false);
  RxString logoUrl = RxString('');
  RxBool obscureText = RxBool(true);
  RxBool warningForImage = RxBool(false);
  final GlobalKey<FormState> formKeyForFirstMenu = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyForSecondMenu = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyForThirdMenu = GlobalKey<FormState>();
  RxString query = RxString('');
  RxString selectedCountryId = RxString('');
  RxString selectedCityId = RxString('');
  RxMap industryMap = RxMap({});

  final menu = <MenuModel>[
    MenuModel(title: 'Company Details', isPressed: true),
    MenuModel(title: 'Contact Details', isPressed: false),
    MenuModel(title: 'Responsibilities', isPressed: false),
  ];

  @override
  void onInit() {
    // getCountriesAndCities();
    getCountries();
    getIndustries();
    getResponsibilities();

    super.onInit();
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
  //   update();
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

  // this function is to remove a menu from the list
  removeMenuFromList(index) {
    roleIDFromList.removeAt(index);
  }

  String getRoleName(String menuID) {
    // Find the entry with the matching key
    final matchingEntry = allRoles.entries.firstWhere(
      (entry) => entry.key == menuID,
      orElse: () =>
          const MapEntry('', 'Unknown'), // Handle cases where no match is found
    );
    final menuName =
        matchingEntry.value.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();

    return menuName;
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

// this function is to select an image for logo

  Future<void> pickImage() async {
    try {
      // Create a file input element using web.HTMLInputElement.
      final uploadInput =
          web.document.createElement('input') as web.HTMLInputElement;
      uploadInput.type = 'file';
      uploadInput.accept = 'image/*';
      uploadInput.click();

      // Listen for changes on the file input element.
      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files != null && files.length > 0) {
          final file = files.item(0);
          if (file != null) {
            final reader = web.FileReader();
            // Read the file as an ArrayBuffer.
            reader.readAsArrayBuffer(file);
            reader.onLoadEnd.listen((event) {
              if (reader.result != null) {
                // Convert the JS ArrayBuffer to a Dart Uint8List.
                imageBytes = convertJSArrayBufferToUint8List(reader.result!);
                update();
              }
            });
          }
        }
      });
    } catch (e) {
      // print('Error picking image: $e');
    }
  }

  selectFromLeftMenu(i) {
    selectedMenu.value = i;
    for (int index = 0; index < menu.length; index++) {
      menu[index].isPressed = (index == i);
    }
    update();
  }

  goToNextMenu() {
    selectedMenu.value += 1;
    selectFromLeftMenu(selectedMenu.value);
    update();
  }

  String formatPhrase(String phrase) {
    return phrase.replaceAll(' ', '_');
  }

  // this function is to change the obscureText value:
  void changeObscureTextValue() {
    if (obscureText.value == true) {
      obscureText.value = false;
    } else {
      obscureText.value = true;
    }
    update();
  }

  addNewCompany() async {
    try {
      addingProcess.value = true;

      var userDataSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('email', isEqualTo: email.text) // Check for existing email
          .get();

      if (userDataSnapshot.docs.isNotEmpty) {
        addingProcess.value = false;
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

      var bytes = utf8.encode(password.text); // Convert password to bytes
      var digest = sha256.convert(bytes); // Hash the password
      String hashedPassword = digest.toString();

      var newCompany =
          await FirebaseFirestore.instance.collection('companies').add({
        'company_logo': logoUrl.value,
        'company_name': companyName.text,
        'industry': industryID.value,
        'added_date': DateTime.now().toString(),
        'status': true,
        'contact_details': {
          'address': address.text,
          'city': city.text,
          'country': country.text,
          'phone': phoneNumber.text,
        },
      });

      DateTime now = DateTime.now(); // Current date and time
      DateTime expiryDate =
          DateTime(now.year, now.month + 1, now.day); // Add one month

      var newUser =
          await FirebaseFirestore.instance.collection('sys-users').add({
        "user_name": userName.text,
        "email": email.text,
        "password": hashedPassword, // Store hashed password
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

      await saveUserIdAndCompanyIdInSharedPref(newUser.id, newCompany.id);
      showSnackBar('Registeration Success', 'Welcome');

      Get.offAllNamed('/mainScreen');

      addingProcess.value = false;
    } catch (e) {
      addingProcess.value = false;
    }
  }

// this function is to save user id in shared pref
  saveUserIdAndCompanyIdInSharedPref(userId, companyId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('companyId', companyId);
  }

  Widget buildRightContent(int index, controller, constraints) {
    switch (index) {
      case 0:
        return companyDetails(controller: controller);
      case 1:
        return contactDetails(controller: controller);
      case 2:
        return responsibilities(controller: controller);

      default:
        return const Text('4');
    }
  }

// this function is to get the industries
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
}
