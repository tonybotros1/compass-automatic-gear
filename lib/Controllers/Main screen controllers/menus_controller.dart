import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MenusController extends GetxController {
  // final RxList<DocumentSnapshot> allMenus = RxList<DocumentSnapshot>([]);
  RxMap allMenus = RxMap();
  RxList menusSubMenusChildren = RxList([]);
  RxList menusSscreensChildren = RxList([]);
  RxMap<String, Map<String, dynamic>> filteredMenus =
      RxMap<String, Map<String, dynamic>>();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool addingNewMenuProcess = RxBool(false);
  RxBool isScreenLoading = RxBool(true);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);

  @override
  void onInit() {
    // init();
    getMenus();
    search.value.addListener(() {
      filterMenus();
    });
    super.onInit();
  }

  // this function is to sort data in table
  // void onSort(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     allMenus.sort((menu1, menu2) {
  //       final String? value1 = menu1.get('name');
  //       final String? value2 = menu2.get('name');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   } else if (columnIndex == 2) {
  //     allMenus.sort((menu1, menu2) {
  //       final String? value1 = menu1.get('added_date');
  //       final String? value2 = menu2.get('added_date');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   }
  //   sortColumnIndex.value = columnIndex;
  //   isAscending.value = ascending;
  // }

  // int compareString(bool ascending, String value1, String value2) {
  //   int comparison = value1.compareTo(value2);
  //   return ascending ? comparison : -comparison; // Reverse if descending
  // }

  // this function is to filter the search results for web
  void filterMenus() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredMenus.clear();
    } else {
      filteredMenus.assignAll(
        Map.fromEntries(
          allMenus.entries
              .where((entry) => entry.value['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.value))
              .map((entry) => MapEntry(
                  entry.key as String, entry.value as Map<String, dynamic>)),
        ),
      );
    }
  }

// Function to get all menus in the system
  getMenus() async {
    try {
      isScreenLoading.value = true; // Start loading

      FirebaseFirestore.instance
          .collection('menus ')
          .snapshots()
          .listen((menus) async {
        allMenus.clear();

        for (var doc in menus.docs) {
          // Get details for children IDs
          var childrenIDs = doc.data()['children'] ?? [];
          var childrenDetails = await getMenusChildrenDetails(childrenIDs);

          // Build menu object
          allMenus[doc.id] = {
            'name': doc.data()['name'],
            'added_date': doc.data()['added_date'],
            'sub_menus': childrenDetails['subMenus'],
            'screens': childrenDetails['screens'],
          };
        }
        isScreenLoading.value = false; // Stop loading
      });
    } catch (e) {
      isScreenLoading.value = false; // Stop loading in case of error
    }
  }

// Function to get details of children (sub-menus and screens)
  Future<Map<String, dynamic>> getMenusChildrenDetails(
      List<dynamic> childrenIDs) async {
    Map<String, dynamic> result = {
      'subMenus': [],
      'screens': [],
    };

    if (childrenIDs.isEmpty) return result;

    try {
      // Fetch sub-menus
      var subMenusSnapshot = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, whereIn: childrenIDs)
          .get();

      result['subMenus'] =
          subMenusSnapshot.docs.map((doc) => doc.data()).toList();

      // Fetch screens
      var screensSnapshot = await FirebaseFirestore.instance
          .collection('screens')
          .where(FieldPath.documentId, whereIn: childrenIDs)
          .get();

      result['screens'] =
          screensSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching children details: $e');
    }

    return result;
  }

// this function is to add new menu to the system
  addNewMenu() {}

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
