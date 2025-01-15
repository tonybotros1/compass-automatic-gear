import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListOfValuesController extends GetxController {
  late TextEditingController listName = TextEditingController();
  late TextEditingController code = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool isScreenLoding = RxBool(true);
  final GlobalKey<FormState> formKeyForAddingNewList = GlobalKey<FormState>();
  final RxList<DocumentSnapshot> allLists = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allValues = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredLists = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredValues = RxList<DocumentSnapshot>([]);
  RxBool addingNewListProcess = RxBool(false);
  RxBool editingListProcess = RxBool(false);
  RxBool deletingListProcess = RxBool(false);
  RxBool loadingValues = RxBool(false);
  RxBool addingNewListValue = RxBool(false);

  @override
  void onInit() {
    getLists();
    // editCities();
    search.value.addListener(() {
      filterLists();
    });
    super.onInit();
  }

  // editCities() async {
  //   try {
  //     // Fetch all documents that match the conditions
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('all_lists')
  //         .where('list_name', isEqualTo: "cities")
  //         .get();

  //     for (var doc in snapshot.docs) {
  //       // Access the 'values' sub-collection of the current document
  //       QuerySnapshot valuesSnapshot = await doc.reference
  //           .collection('values')
  //           .where('country_id', isEqualTo: 'I78CXdMEcMOrk8ViVU0o')
  //           .get();

  //       // Iterate through the documents in the 'values' sub-collection
  //       for (var valueDoc in valuesSnapshot.docs) {
  //         // Update the required fields
  //         await valueDoc.reference.update({
  //           'code': 'UAE', // Replace 'field1' with the actual field name
  //           // Add additional fields as needed
  //         });
  //       }
  //     }

  //     print('All fields updated successfully!');
  //   } catch (e) {
  //     print('Error updating fields: $e');
  //   }
  // }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allLists.sort((screen1, screen2) {
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allLists.sort((screen1, screen2) {
        final String? value1 = screen1.get('routeName');
        final String? value2 = screen2.get('routeName');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allLists.sort((screen1, screen2) {
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

  // this function is to filter the search results for web
  void filterLists() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredLists.clear();
    } else {
      filteredLists.assignAll(
        allLists.where((list) {
          return list['list_name'].toString().toLowerCase().contains(query) ||
              list['code'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  getLists() {
    try {
      FirebaseFirestore.instance
          .collection('all_lists')
          .snapshots()
          .listen((lists) {
        allLists.assignAll(lists.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  getListValues(listId) async {
    try {
      loadingValues.value = true;
      var listValues = await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .collection('values')
          .orderBy('name', descending: false)
          .get();

      allValues.assignAll(listValues.docs);
      loadingValues.value = false;
    } catch (e) {
      loadingValues.value = false;
    }
  }

// this function is to add new list
  addNewList() async {
    try {
      addingNewListProcess.value = true;
      await FirebaseFirestore.instance.collection('all_lists').add({
        'list_name': listName.text,
        'code': code.text,
        'added_date': DateTime.now().toString(),
      });
      addingNewListProcess.value = false;
      Get.back();
    } catch (e) {
      addingNewListProcess.value = false;
    }
  }

// thisfunction is to delete a list
  deleteList(listId) async {
    try {
      deletingListProcess.value = true;
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .delete();
      deletingListProcess.value = false;

      Get.back();
    } catch (e) {
      deletingListProcess.value = false;
    }
  }

  editList(listId) async {
    try {
      editingListProcess.value = true;
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .update({
        'list_name': listName.text,
        'code': code.text,
      });
      editingListProcess.value = false;
      Get.back();
    } catch (e) {
      editingListProcess.value = true;
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
}
