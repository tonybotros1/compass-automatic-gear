import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactInformationsController extends GetxController {
  TextEditingController contactName = TextEditingController();
  TextEditingController contactAdress = TextEditingController();
  Rx<TextEditingController> phoneTypeSection = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberSection = TextEditingController().obs;
  Rx<TextEditingController> phoneNameSection = TextEditingController().obs;
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allContacts = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredContacts =
      RxList<DocumentSnapshot>([]);
  RxBool addingNewValue = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxList phoneTypes = RxList([]);
  RxList contactPhone = RxList([
    {
      'type': '',
      'number': '',
      'name': '',
    }
  ]);

  @override
  void onInit() {
    getContacts();
    getPhoneTypes();
    search.value.addListener(() {
      filterContacts();
    });
    super.onInit();
  }

  addPhoneLine() {
    contactPhone.add({
      'type': '',
      'number': '',
      'name': '',
    });
  }

  removePhoneLine(i) {
    contactPhone.removeAt(i);
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
          .where('code', isEqualTo: 'PHONE_TYPES')
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
          phoneTypes.value = types.docs;
          phoneTypeSection.value.text = types.docs.first.data()['name'];
          contactPhone[0]['type'] = types.docs.first.data()['name'];
        });
      }
    } catch (e) {
//
    }
  }
}
