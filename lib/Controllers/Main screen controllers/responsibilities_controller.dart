import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../consts.dart';

class ResponsibilitiesController extends GetxController {
  final RxMap allResponsibilities = RxMap({});
  final RxMap filteredResponsibilities = RxMap({});
  RxBool addingNewResponsibilityProcess = RxBool(false);
  TextEditingController responsibilityName = TextEditingController();
  TextEditingController menuName = TextEditingController();
  RxMap<String, String> selectFromMenus = RxMap({});
  RxString menuIDFromList = RxString('');

  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool loadingMenus = RxBool(false);
  RxBool deleteingResponsibility = RxBool(false);
  RxBool viewLoading = RxBool(false);

  @override
  void onInit() {
    getResponsibilities();
    search.value.addListener(() {
      filterResponsibilities();
    });

    super.onInit();
  }

// this function is to update the role details
  updateResponsibility(roleID) async {
    addingNewResponsibilityProcess.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('sys-roles')
          .doc(roleID)
          .update({
        'role_name': responsibilityName.text,
        'menuID': menuIDFromList.value,
      });
      addingNewResponsibilityProcess.value = false;
    } catch (e) {
      addingNewResponsibilityProcess.value = false;
      print(e);
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    // Convert allMenus map to a list of entries for sorting
    final entries = allResponsibilities.entries.toList();

    if (columnIndex == 0) {
      // Sort by 'name' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value['role_name'] as String?;
        final String? value2 = entry2.value['role_name'] as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      // Sort by 'added_date' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value['added_date'] as String?;
        final String? value2 = entry2.value['added_date'] as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }

    // Re-construct the sorted map
    allResponsibilities
      ..clear()
      ..addEntries(entries);

    // Update sorting state
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  deleteResponsibility(resID) async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('sys-roles').doc(resID).delete();
      var users = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('roles', arrayContains: resID)
          .get();

      WriteBatch batch = firestore.batch();

      for (var doc in users.docs) {
        batch.update(doc.reference, {
          'roles': FieldValue.arrayRemove([resID])
        });
      }
      await batch.commit();
      await getResponsibilities();
      deleteingResponsibility.value = false;
    } catch (e) {
      deleteingResponsibility.value = false;
    }
  }

  addNewResponsibility() {
    try {
      if (menuIDFromList.isEmpty) {
        showSnackBar('Can not complete', 'please try again later');
      } else {
        FirebaseFirestore.instance.collection('sys-roles').add({
          'role_name': responsibilityName.text,
          'menuID': menuIDFromList.value,
          'added_date': DateTime.now().toString(),
        });
      }
    } catch (e) {
      //
    }
  }

// this functions is to get the Responsibilities in system and its details
  getResponsibilities() {
    try {
      allResponsibilities.clear();
      FirebaseFirestore.instance
          .collection('sys-roles')
          .snapshots()
          .listen((roles) async {
        for (var role in roles.docs) {
          allResponsibilities[role.id] = {
            'role_name': role['role_name'],
            'menu': await getMenuDetails(role['menuID']),
            'added_date': role['added_date']
          };
        }
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  // this function to get list of menus to select of them
  listOfMenus() async {
    try {
      var menus = await FirebaseFirestore.instance.collection('menus ').get();

      if (menus.docs.isNotEmpty) {
        for (var menu in menus.docs) {
          selectFromMenus[menu.id] =
              '${menu.data()['name']} (${menu.data()['description']})';
        }
      }
    } catch (e) {
//
    }
  }

  // this function is to get menu details
  Future<Map> getMenuDetails(menuID) async {
    try {
      var menu = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, isEqualTo: menuID)
          .get();

      var id = menu.docs.first.id;
      var details = menu.docs.first.data();

      return {
        'id': id,
        'name': details['name'],
        'description': details['description']
      };
    } catch (e) {
      print(e);
      return {
        'id': '',
        'name': '',
        'description': ''
      };
    }
  }

  // this function is to filter the search results for web
  void filterResponsibilities() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredResponsibilities.clear();
    } else {
      filteredResponsibilities.assignAll(
        Map.fromEntries(
          allResponsibilities.entries
              .where((entry) =>
                  entry.value['role_name']
                      .toString()
                      .toLowerCase()
                      .contains(query.value) ||
                  entry.value['menuID']
                      .toString()
                      .toLowerCase()
                      .contains(query.value))
              .map((entry) => MapEntry(
                  entry.key as String, entry.value as Map<String, dynamic>)),
        ),
      );
    }
  }

  // function to convert text to date and make the format dd-mm-yyyy
  String textToDate(dynamic inputDate) {
    try {
      if (inputDate is String) {
        // Match the actual date format of the input
        DateTime parsedDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(inputDate);
        return DateFormat("dd-MM-yyyy").format(parsedDate);
      } else if (inputDate is DateTime) {
        return DateFormat("dd-MM-yyyy").format(inputDate);
      } else {
        throw FormatException("Invalid input type for textToDate: $inputDate");
      }
    } catch (e) {
      return "Invalid Date"; // Return a default or placeholder string
    }
  }
}
