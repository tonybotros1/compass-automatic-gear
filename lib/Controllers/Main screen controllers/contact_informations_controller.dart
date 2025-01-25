import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Models/type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

import '../../Models/menu_model.dart';
import '../../Widgets/main screen widgets/contacts_informations_widgets/address_card.dart';
import '../../Widgets/main screen widgets/contacts_informations_widgets/contacts_card.dart';
import '../../Widgets/main screen widgets/contacts_informations_widgets/social_card.dart';

class ContactInformationsController extends GetxController {
  TextEditingController contactName = TextEditingController();
  TextEditingController groupName = TextEditingController();
  Rx<TextEditingController> typrOfBusiness = TextEditingController().obs;
  RxString typrOfBusinessId = RxString('');
  // Rx<TextEditingController> phoneTypeSection = TextEditingController().obs;
  RxList<TypeModel> phoneTypesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> socialTypesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> countriesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> citiesControllers = RxList<TypeModel>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allContacts = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredContacts =
      RxList<DocumentSnapshot>([]);
  RxBool addingNewValue = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxInt selectedTap = RxInt(0);

  final taps = <MenuModel>[
    MenuModel(title: 'Address Card', isPressed: true),
    MenuModel(title: 'Contact Card', isPressed: false),
    MenuModel(title: 'Social Card', isPressed: false),
  ];
  RxList contactPhone = RxList([
    {
      'type': '',
      'number': '',
      'name': '',
      'email': '',
    }
  ]);

  RxList contactSocial = RxList([
    {
      'type': '',
      'link': '',
    }
  ]);

  RxList contactAddress = RxList([
    {
      'line': '',
      'country': '',
      'city': '',
    }
  ]);
  RxMap typeOfBusinessMap = RxMap({});
  RxMap typeOfSocialsMap = RxMap({});
  RxMap phoneTypesMap = RxMap({});
  Uint8List? imageBytes;
  RxMap allCities = RxMap({});
  RxMap allCountries = RxMap({});

  final GlobalKey<AnimatedListState> listKeyForPhoneLine =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> listKeyForSocialLine =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> listKeyForAddressLine =
      GlobalKey<AnimatedListState>();

  @override
  void onInit() {
    generateControllerForAdressCountriesAndCities();
    generateControllerForPhoneTypes();
    generateControllerForSocialTypes();
    getCountriesAndCities();
    getTypeOfBusiness();
    getTypeOfSocial();
    getContacts();
    getPhoneTypes();
    search.value.addListener(() {
      filterContacts();
    });
    super.onInit();
  }

  selectFromTaps(i) {
    selectedTap.value = i;
    for (int index = 0; index < taps.length; index++) {
      taps[index].isPressed = (index == i);
    }
    update();
  }

  Widget buildTapsContent(int index, controller) {
    switch (index) {
      case 0:
        return addressCardSection(controller);
      case 1:
        return contactsCardSection(controller);
      case 2:
        return socialCardSection(controller);

      default:
        return const Text('4');
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

      update();
    } catch (e) {
      // print(e);
    }
  }

  generateControllerForPhoneTypes() {
    phoneTypesControllers.value = List.generate(
      contactPhone.length + 1,
      (index) =>
          TypeModel(controller: TextEditingController()), // Return a TestModel
    );
  }

  generateControllerForSocialTypes() {
    socialTypesControllers.value = List.generate(
      contactSocial.length + 1,
      (index) =>
          TypeModel(controller: TextEditingController()), // Return a TestModel
    );
  }

  generateControllerForAdressCountriesAndCities() {
    countriesControllers.value = List.generate(
      contactAddress.length + 1,
      (index) =>
          TypeModel(controller: TextEditingController()), // Return a TestModel
    );
    citiesControllers.value = List.generate(
      contactAddress.length + 1,
      (index) =>
          TypeModel(controller: TextEditingController()), // Return a TestModel
    );
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

// this function is to get the business types
  getTypeOfBusiness() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'TYPE_OF_BUSINESS')
        .get();

    var typrId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typrId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((business) {
      typeOfBusinessMap.value = {
        for (var doc in business.docs) doc.id: doc.data()
      };
    });
  }

// this function is to generate a new phone field
  addPhoneLine() {
    final index = contactPhone.length;

    contactPhone.add({
      'type': '',
      'number': '',
      'name': '',
    });
    listKeyForPhoneLine.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 300));

    phoneTypesControllers.add(TypeModel(controller: TextEditingController()));
  }

  // this function is to generate a new social field
  addSocialLine() {
    final index = contactSocial.length;

    contactSocial.add({
      'type': '',
      'link': '',
    });
    listKeyForSocialLine.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 300));
    socialTypesControllers.add(TypeModel(controller: TextEditingController()));
  }

  // this function is to generate a new address field
  addAdressLine() {
    final index = contactAddress.length;

    contactAddress.add({
      'line': '',
      'country': '',
      'city': '',
    });
    listKeyForAddressLine.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 300));
    countriesControllers.add(TypeModel(controller: TextEditingController()));
    citiesControllers.add(TypeModel(controller: TextEditingController()));
  }

// this function is to remove a phone field
  void removePhoneField(int index) {
    // if (index >= 0 && index < contactPhone.length) {
    // }
    contactPhone.removeAt(index);
    phoneTypesControllers.removeAt(index);
  }

// this function is to remove a social field
  void removeSocialField(int index) {
    // if (index >= 0 && index < contactPhone.length) {
    // }
    contactSocial.removeAt(index);
    socialTypesControllers.removeAt(index);
  }
  // this function is to remove a address field
  void removeAddressField(int index) {
    // if (index >= 0 && index < contactPhone.length) {
    // }
    contactAddress.removeAt(index);
    countriesControllers.removeAt(index);
    citiesControllers.removeAt(index);
  }



  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allContacts.sort((screen1, screen2) {
        final String? value1 = screen1.get('code');
        final String? value2 = screen2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allContacts.sort((screen1, screen2) {
        final String? value1 = screen1.get('value');
        final String? value2 = screen2.get('value');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allContacts.sort((screen1, screen2) {
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

// this functions is to get all contacts in the current company
  getContacts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');
      FirebaseFirestore.instance
          .collection('all_contacts')
          .where('company_id', isEqualTo: companyId)
          .snapshots()
          .listen((contacts) {
        allContacts.assignAll(contacts.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  addNewContact() async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance.collection('all_contacts').add({});
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  // this function is to filter the search results for web
  void filterContacts() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredContacts.clear();
    } else {
      filteredContacts.assignAll(
        allContacts.where((screen) {
          return screen['name'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<void> getPhoneTypes() async {
    try {
      // Query for the document with code 'PHONE_TYPES'
      var type = await FirebaseFirestore.instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CONTACT_TYPES')
          .get();

      if (type.docs.isNotEmpty) {
        // Access the 'values' subcollection using the document ID
        FirebaseFirestore.instance
            .collection('all_lists')
            .doc(type.docs.first.id) // Use the document ID
            .collection('values')
            .where('available', isEqualTo: true)
            .snapshots()
            .listen((types) {
          phoneTypesMap.value = {
            for (var doc in types.docs) doc.id: doc.data()
          };
          // phoneTypeSection.value.text = types.docs.first.data()['name'];
          phoneTypesControllers[0].controller!.text =
              types.docs.first.data()['name'];
          contactPhone[0]['type'] = types.docs.first.data()['name'];
        });
      }
    } catch (e) {
//
    }
  }

// this function is to get the business types
  getTypeOfSocial() async {
    try {
      var typeDoc = await FirebaseFirestore.instance
          .collection('all_lists')
          .where('code', isEqualTo: 'SOCIAL_MEDIA')
          .get();

      var typrId = typeDoc.docs.first.id;

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(typrId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((socials) {
        typeOfSocialsMap.value = {
          for (var doc in socials.docs) doc.id: doc.data()
        };
        socialTypesControllers[0].controller!.text =
            socials.docs.first.data()['name'];
        contactSocial[0]['type'] = socials.docs.first.data()['name'];
      });
    } catch (e) {
      print(e);
    }
  }
}
