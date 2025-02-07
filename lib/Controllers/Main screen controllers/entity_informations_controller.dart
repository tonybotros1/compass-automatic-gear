import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Models/primary_model.dart';
import 'package:datahubai/Models/type_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class EntityInformationsController extends GetxController {
  TextEditingController entityName = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController creditLimit = TextEditingController();
  TextEditingController trn = TextEditingController();
  Rx<TextEditingController> industry = TextEditingController().obs;
  Rx<TextEditingController> salesMAn = TextEditingController().obs;
  Rx<TextEditingController> entityType = TextEditingController().obs;
  RxString industryId = RxString('');
  RxString salesManId = RxString('');
  RxString entityTypeId = RxString('');
  RxList<TypeModel> phoneTypesControllers = RxList<TypeModel>([]);
  RxList<PrimaryModel> phonePrimary = RxList<PrimaryModel>([]);
  RxList<PrimaryModel> addressPrimary = RxList<PrimaryModel>([]);
  RxList<TypeModel> socialTypesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> countriesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> citiesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> linesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> phoneNumbersControllers = RxList<TypeModel>([]);
  RxList<TypeModel> linksControllers = RxList<TypeModel>([]);
  RxList<TypeModel> emailsControllers = RxList<TypeModel>([]);
  RxList<TypeModel> namesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> jobTitlesControllers = RxList<TypeModel>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allEntities = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredEntities =
      RxList<DocumentSnapshot>([]);
  RxBool addingNewEntity = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool isVendorSelected = RxBool(false);
  RxBool isCustomerSelected = RxBool(true);
  RxBool isCompanySelected = RxBool(true);
  RxBool isIndividualSelected = RxBool(false);
  RxString logoUrl = RxString('');
  RxMap industryMap = RxMap({});
  RxMap salesManMap = RxMap({});
  RxMap entityTypeMap = RxMap({});
  RxMap typeOfSocialsMap = RxMap({});
  RxMap phoneTypesMap = RxMap({});
  Uint8List? imageBytes;
  RxMap allCities = RxMap({});
  RxMap allCountries = RxMap({});
  // RxMap filterdCitiesByCountry = RxMap({});
  RxList entityCode = RxList([]);
  RxString entityStatus = RxString('');
  final GlobalKey<AnimatedListState> listKeyForPhoneLine =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> listKeyForSocialLine =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> listKeyForAddressLine =
      GlobalKey<AnimatedListState>();

  RxList contactPhone = RxList([
    {
      'type': '',
      'number': '',
      'name': '',
      'email': '',
      'tob_title': '',
      'isPrimary': true,
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
      'isPrimary': true,
    }
  ]);

  @override
  void onInit() {
    // getCountriesAndCities()
    getCountries();
    getEntities();

    generateControllerForAdressCountriesAndCities();
    generateControllerForPhoneTypes();
    generateControllerForSocialTypes();
    getEntityType();
    getIndustries();
    getTypeOfSocial();
    getPhoneTypes();
    getSalesMan();
    search.value.addListener(() {
      filterEntities();
    });
    super.onInit();
  }

  clearAllVariables() {
    entityName.clear();
    entityCode.clear();
    // isCustomerSelected.value = false;
    isVendorSelected.value = false;
    creditLimit.clear();
    salesMAn.value.clear();
    salesManId.value = '';
    logoUrl.value = '';
    imageBytes = null;
    entityStatus.value = '';
    // isCompanySelected.value = false;
    isIndividualSelected.value = false;
    groupName.clear();
    industry.value.clear();
    industryId.value = '';
    trn.clear();
    entityType.value.clear();
    entityTypeId.value = '';
    contactAddress.clear();
    contactAddress.add({
      'line': '',
      'country': '',
      'city': '',
      'isPrimary': true,
    });

    contactPhone.clear();
    contactPhone.add({
      'type': '',
      'number': '',
      'name': '',
      'email': '',
      'tob_title': '',
      'isPrimary': true,
    });
    contactSocial.clear();
    contactSocial.add({
      'type': '',
      'link': '',
    });
    socialTypesControllers.clear();
    linksControllers.clear();
    phoneTypesControllers.clear();
    phonePrimary.clear();
    phoneNumbersControllers.clear();
    emailsControllers.clear();
    namesControllers.clear();
    jobTitlesControllers.clear();
    countriesControllers.clear();
    addressPrimary.clear();
    citiesControllers.clear();
    linesControllers.clear();
    generateControllerForAdressCountriesAndCities();
    generateControllerForPhoneTypes();
    generateControllerForSocialTypes();
  }

  String formatPhrase(String phrase) {
    return phrase.replaceAll(' ', '_');
  }

  addNewEntity() async {
    try {
      addingNewEntity.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');
      if (imageBytes != null && imageBytes!.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'entities_pictures/${formatPhrase(entityName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes!,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          logoUrl.value = await storageRef.getDownloadURL();
        });
      }

      FirebaseFirestore.instance.collection('entity_informations').add({
        'entity_name': entityName.text,
        'entity_picture': logoUrl.value,
        'entity_code': entityCode,
        'credit_limit': int.parse(creditLimit.text),
        'sales_man': salesManId.value,
        'entity_status': entityStatus.value,
        'group_name': groupName.text,
        'industry': industryId.value,
        'trn': trn.text,
        'entity_type': entityTypeId.value,
        'entity_address': contactAddress,
        'entity_phone': contactPhone,
        'entity_social': contactSocial,
        'added_date': DateTime.now().toString(),
        'company_id': companyId,
        'status': true,
      });
      addingNewEntity.value = false;
      Get.back();
    } catch (e) {
      addingNewEntity.value = false;
    }
  }

  editEntity(entityId) async {
    try {
      addingNewEntity.value = true;

      var newEntityData = {
        'entity_name': entityName.text,
        'entity_code': entityCode,
        'credit_limit': int.parse(creditLimit.text),
        'sales_man': salesManId.value,
        'entity_status': entityStatus.value,
        'group_name': groupName.text,
        'industry': industryId.value,
        'trn': trn.text,
        'entity_type': entityTypeId.value,
        'entity_address': contactAddress,
        'entity_phone': contactPhone,
        'entity_social': contactSocial,
      };

      if (imageBytes != null && imageBytes!.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'images/${formatPhrase(entityName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes!,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          logoUrl.value = await storageRef.getDownloadURL();
        });
        newEntityData['entity_picture'] = logoUrl.value;
      }

      await FirebaseFirestore.instance
          .collection('entity_informations')
          .doc(entityId)
          .update(newEntityData);
      addingNewEntity.value = false;
      Get.back();
    } catch (e) {
      addingNewEntity.value = false;
    }
  }

// this functions is to change the user status from active / inactive
  changeEntityStatus(String entityId, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('entity_informations')
          .doc(entityId)
          .update({'status': status});
    } catch (e) {
      //
    }
  }

  deleteEntity(entityId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('entity_informations')
          .doc(entityId)
          .delete();
    } catch (e) {
      //
    }
  }

  String? getSaleManName(String saleManId) {
    try {
      final salesMan = salesManMap.entries.firstWhere(
        (saleMan) => saleMan.key == saleManId,
      );
      return salesMan.value['name'];
    } catch (e) {
      return '';
    }
  }

  String? getIndustryName(String industryId) {
    try {
      final industry = industryMap.entries.firstWhere(
        (industryy) => industryy.key == industryId,
      );
      return industry.value['name'];
    } catch (e) {
      return '';
    }
  }

  String? getEntityTypeName(String entityTypeId) {
    try {
      final entityType = entityTypeMap.entries.firstWhere(
        (entityTypee) => entityTypee.key == entityTypeId,
      );
      return entityType.value['name'];
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

  String? getPhoneTypeName(String typeId) {
    try {
      final type = phoneTypesMap.entries.firstWhere(
        (type) => type.key == typeId,
      );
      return type.value['name'];
    } catch (e) {
      return '';
    }
  }

  String? getSocialTypeName(String socialId) {
    try {
      final social = typeOfSocialsMap.entries.firstWhere(
        (social) => social.key == socialId,
      );
      return social.value['name'];
    } catch (e) {
      return '';
    }
  }

  selectVendor(bool value) {
    isVendorSelected.value = value;
    if (value == true) {
      entityCode.add('Vendor');
    } else {
      entityCode.remove('Vendor');
    }
  }

  selectCustomer(bool value) {
    isCustomerSelected.value = value;
    if (value == true) {
      entityCode.add('Customer');
    } else {
      entityCode.remove('Customer');
    }
  }

// this function is to set the entity code fro edit
  void updateEntityCode(List entityCodes) {
    isCustomerSelected.value = entityCodes.contains('Customer');
    isVendorSelected.value = entityCodes.contains('Vendor');

    entityCode.clear();
    entityCode.addAll(entityCodes.toSet());
  }

// this function is to set the entity status fro edit
  void updateEntityStatus(String entityStatusText) {
    isCompanySelected.value = entityStatusText == 'Company';
    isIndividualSelected.value = entityStatusText == 'Individual';
    entityStatus.value = isCompanySelected.isTrue ? 'Company' : 'Individual';
  }

  void updateEntityAddress(List entityAddressFromData) {
    // contactAddress.clear();
    contactAddress.value = entityAddressFromData;
    generateControllerForAdressCountriesAndCities();

    final length = contactAddress.length;
    for (var i = 0; i < length; i++) {
      final address = contactAddress[i];

      countriesControllers[i].controller?.text =
          getCountryName(address['country']) ?? '';
      addressPrimary[i].isPrimary = address['isPrimary'];
      citiesControllers[i].controller?.text =
          getCityName(address['city']) ?? '';
      linesControllers[i].controller?.text = address['line'] ?? '';
    }
  }

  void updateEntityPhone(List entityPhoneFromData) {
    // contactPhone.clear();
    contactPhone.value = entityPhoneFromData;
    generateControllerForPhoneTypes();

    final length = contactPhone.length;
    for (var i = 0; i < length; i++) {
      final phone = contactPhone[i];

      phoneTypesControllers[i].controller?.text =
          getPhoneTypeName(phone['type']) ?? '';
      phonePrimary[i].isPrimary = phone['isPrimary'];
      phoneNumbersControllers[i].controller?.text = phone['number'] ?? '';
      emailsControllers[i].controller?.text = phone['email'] ?? '';
      namesControllers[i].controller?.text = phone['name'] ?? '';
      jobTitlesControllers[i].controller?.text = phone['tob_title'] ?? '';
    }
  }

  void updateEntitySocial(List entitySocialFromData) {
    contactSocial.value = entitySocialFromData;
    generateControllerForSocialTypes();

    final length = contactSocial.length;
    for (var i = 0; i < length; i++) {
      final social = contactSocial[i];

      socialTypesControllers[i].controller?.text =
          getSocialTypeName(social['type']) ?? '';
      linksControllers[i].controller?.text = social['link'] ?? '';
    }
  }

  void selectCompanyOrIndividual(String selected, bool value) {
    bool isCompany = selected == 'company';

    isCompanySelected.value = isCompany ? value : false;
    isIndividualSelected.value = isCompany ? false : value;
    entityStatus.value = isCompany ? 'Company' : 'Individual';
  }

  // void selectPrimaryAddressField(int index, bool value) {
  //   for (var i = 0; i < contactAddress.length; i++) {
  //     contactAddress[i]['isPrimary'] = false;
  //     addressPrimary[i].isPrimary = false;
  //   }

  //   contactAddress[index]['isPrimary'] = true;
  //   addressPrimary[index].isPrimary = true;

  //   update();
  // }
  void selectPrimaryAddressField(int index, bool value) {
    if (contactAddress[index]['isPrimary'] == true) {
      return;
    }

    final previousPrimaryIndex =
        contactAddress.indexWhere((e) => e['isPrimary'] == true);
    if (previousPrimaryIndex != -1) {
      contactAddress[previousPrimaryIndex]['isPrimary'] = false;
      addressPrimary[previousPrimaryIndex].isPrimary = false;
    }

    contactAddress[index]['isPrimary'] = true;
    addressPrimary[index].isPrimary = true;

    update();
  }

  // void selectPrimaryPhonesField(int index, bool value) {
  //   for (var i = 0; i < contactPhone.length; i++) {
  //     contactPhone[i]['isPrimary'] = false;
  //     phonePrimary[i].isPrimary = false;
  //   }

  //   contactPhone[index]['isPrimary'] = true;
  //   phonePrimary[index].isPrimary = true;

  //   update();
  // }
  void selectPrimaryPhonesField(int index, bool value) {
    if (contactPhone[index]['isPrimary'] == true) {
      return; // Exit early if already primary
    }

    final previousPrimaryIndex =
        contactPhone.indexWhere((e) => e['isPrimary'] == true);
    if (previousPrimaryIndex != -1) {
      contactPhone[previousPrimaryIndex]['isPrimary'] = false;
      phonePrimary[previousPrimaryIndex].isPrimary = false;
    }

    contactPhone[index]['isPrimary'] = true;
    phonePrimary[index].isPrimary = true;

    update();
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

  generateControllerForPhoneTypes() {
    final length = contactPhone.length + 1;

    // Pre-generate the controllers and models once
    final controllersList = List.generate(
        length, (index) => TypeModel(controller: TextEditingController()));
    final primaryModelsList =
        List.generate(length, (index) => PrimaryModel(isPrimary: index == 0));

    // Assign values to the respective controller lists
    phoneTypesControllers.value = controllersList;
    phoneNumbersControllers.value = controllersList;
    emailsControllers.value = controllersList;
    namesControllers.value = controllersList;
    jobTitlesControllers.value = controllersList;
    phonePrimary.value = primaryModelsList;
  }

  generateControllerForSocialTypes() {
    final length = contactSocial.length;

    // Pre-generate the controllers once
    final controllersList = List.generate(
        length, (index) => TypeModel(controller: TextEditingController()));

    // Assign values to the respective controller lists
    socialTypesControllers.value = controllersList;
    linksControllers.value = controllersList;
  }

  generateControllerForAdressCountriesAndCities() {
    final length = contactAddress.length;

    final controllersList = List.generate(
        length, (index) => TypeModel(controller: TextEditingController()));
    final primaryModelsList =
        List.generate(length, (index) => PrimaryModel(isPrimary: index == 0));

    countriesControllers.value = controllersList;
    citiesControllers.value = controllersList;
    linesControllers.value = controllersList;
    addressPrimary.value = primaryModelsList;
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

// this function is to get the entity types
  getEntityType() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ENTITY_TYPES')
        .get();

    var typrId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typrId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((entity) {
      entityTypeMap.value = {for (var doc in entity.docs) doc.id: doc.data()};
    });
  }

// this function is to get all sales man in the system
  getSalesMan() {
    FirebaseFirestore.instance
        .collection('sales_man')
        .snapshots()
        .listen((saleMan) {
      salesManMap.value = {for (var doc in saleMan.docs) doc.id: doc.data()};
    });
  }

// this function is to generate a new phone field
  addPhoneLine() {
    final index = contactPhone.length;

    contactPhone.add({
      'type': '',
      'number': '',
      'email': '',
      'name': '',
      'tob_title': '',
      'isPrimary': false,
    });
    listKeyForPhoneLine.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 300));

    phoneTypesControllers.add(TypeModel(controller: TextEditingController()));
    phoneNumbersControllers.add(TypeModel(controller: TextEditingController()));
    emailsControllers.add(TypeModel(controller: TextEditingController()));
    namesControllers.add(TypeModel(controller: TextEditingController()));
    jobTitlesControllers.add(TypeModel(controller: TextEditingController()));
    phonePrimary.add(PrimaryModel(isPrimary: false));
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
    linksControllers.add(TypeModel(controller: TextEditingController()));
  }

  // this function is to generate a new address field
  addAdressLine() {
    final index = contactAddress.length;

    contactAddress.add({
      'line': '',
      'country': '',
      'city': '',
      'isPrimary': false,
    });
    listKeyForAddressLine.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 300));
    countriesControllers.add(TypeModel(controller: TextEditingController()));
    citiesControllers.add(TypeModel(controller: TextEditingController()));
    linesControllers.add(TypeModel(controller: TextEditingController()));
    addressPrimary.add(PrimaryModel(isPrimary: false));
  }

// this function is to remove a phone field
  void removePhoneField(int index) {
    // if (index >= 0 && index < contactPhone.length) {
    // }
    contactPhone.removeAt(index);
    phoneTypesControllers.removeAt(index);
    phoneNumbersControllers.removeAt(index);
    emailsControllers.removeAt(index);
    namesControllers.removeAt(index);
    jobTitlesControllers.removeAt(index);
    phonePrimary.removeAt(index);
  }

// this function is to remove a social field
  void removeSocialField(int index) {
    // if (index >= 0 && index < contactPhone.length) {
    // }
    contactSocial.removeAt(index);
    socialTypesControllers.removeAt(index);
    linksControllers.removeAt(index);
  }

  // this function is to remove a address field
  void removeAddressField(int index) {
    // if (index >= 0 && index < contactPhone.length) {
    // }
    contactAddress.removeAt(index);
    countriesControllers.removeAt(index);
    citiesControllers.removeAt(index);
    linesControllers.removeAt(index);
    addressPrimary.removeAt(index);
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allEntities.sort((screen1, screen2) {
        final String? value1 = screen1.get('entity_name');
        final String? value2 = screen2.get('entity_name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allEntities.sort((screen1, screen2) {
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
  getEntities() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('company_id', isEqualTo: companyId)
          .snapshots()
          .listen((contacts) {
        allEntities.assignAll(contacts.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  void filterEntities() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredEntities.clear();
    } else {
      filteredEntities.assignAll(
        allEntities.where((entity) {
          bool nameMatches =
              entity['entity_name'].toString().toLowerCase().contains(query);

          // Check if any phone number in entity_phone contains the query
          bool phoneMatches = (entity['entity_phone'] as List).any(
              (phoneData) => phoneData['number'].toString().contains(query));

          return nameMatches || phoneMatches;
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
      });
    } catch (e) {
      //
    }
  }
}
