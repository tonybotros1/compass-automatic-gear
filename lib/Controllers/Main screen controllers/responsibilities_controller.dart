import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts.dart';

class ResponsibilitiesController extends GetxController {
  final RxMap allResponsibilities = RxMap({});
  final RxMap filteredResponsibilities = RxMap({});
  RxBool addingNewResponsibilityProcess = RxBool(false);
  TextEditingController responsibilityName = TextEditingController();
  TextEditingController menuName = TextEditingController();
  RxString menuIDFromList = RxString('');

  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoading = RxBool(true);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxMap menuMap = RxMap({});

  RxList selectedRow = RxList([]);

  @override
  void onInit() {
    getResponsibilities();
    search.value.addListener(() {
      filterResponsibilities();
    });

    super.onInit();
  }

  // Future<void> updateDescriptions() async {
  //   try {
  //     // Reference to the 'menus' collection
  //     CollectionReference menus =
  //         FirebaseFirestore.instance.collection('sys-roles');

  //     // Fetch all documents in the collection
  //     QuerySnapshot snapshot = await menus.get();

  //     // Batch write to avoid multiple writes
  //     WriteBatch batch = FirebaseFirestore.instance.batch();

  //     // Iterate through documents and update the 'description' field
  //     for (var doc in snapshot.docs) {
  //       batch.update(doc.reference, {'is_shown_for_users': false});
  //     }

  //     // Commit the batch
  //     await batch.commit();
  //     print("All documents updated with the 'description' field.");
  //   } catch (e) {
  //     print("Error updating descriptions: $e");
  //   }
  // }

// this function is to choose the roles to be shown for the other users or not
  updateRoleStatus(roleID, status) async {
    await FirebaseFirestore.instance
        .collection('sys-roles')
        .doc(roleID)
        .update({
      'is_shown_for_users': status,
    });
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
      Get.back();
    } catch (e) {
      addingNewResponsibilityProcess.value = false;
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
      await firestore.collection('sys-roles').doc(resID).delete();
      Get.back();
      // await getResponsibilities();
    } catch (e) {
      //
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
          'is_shown_for_users': true
        });
        Get.back();
      }
    } catch (e) {
      //
    }
  }

// this functions is to get the Responsibilities in system and its details
  Future<void> getResponsibilities() async {
    try {
      // Fetch menus once to avoid redundant calls
      final menuSnapshot =
          await FirebaseFirestore.instance.collection('menus ').get();

      // Convert menus to a Map for easier access
      menuMap.value = {for (var doc in menuSnapshot.docs) doc.id: doc.data()};

      FirebaseFirestore.instance
          .collection('sys-roles')
          .orderBy('role_name', descending: false)
          .snapshots()
          .listen((roles) {
        allResponsibilities.clear();

        for (var role in roles.docs) {
          allResponsibilities[role.id] = {
            'role_name': role['role_name'],
            'menu': menuMap[role['menuID']] ?? {}, // Fetch menu data as Map
            'menu_id': role['menuID'],
            'added_date': role['added_date'],
            'is_shown_for_users': role['is_shown_for_users'],
          };
        }

        isScreenLoading.value = false;
      });
    } catch (e) {
      // Log the error for debugging
      isScreenLoading.value = false;
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

  // // function to convert text to date and make the format dd-mm-yyyy
  // String textToDate(dynamic inputDate) {
  //   try {
  //     if (inputDate is String) {
  //       // Match the actual date format of the input
  //       DateTime parsedDate =
  //           DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(inputDate);
  //       return DateFormat("dd-MM-yyyy").format(parsedDate);
  //     } else if (inputDate is DateTime) {
  //       return DateFormat("dd-MM-yyyy").format(inputDate);
  //     } else {
  //       throw FormatException("Invalid input type for textToDate: $inputDate");
  //     }
  //   } catch (e) {
  //     return "Invalid Date"; // Return a default or placeholder string
  //   }
  // }
}
