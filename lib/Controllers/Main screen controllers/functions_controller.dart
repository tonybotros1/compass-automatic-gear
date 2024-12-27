import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FunctionsController extends GetxController {
  late TextEditingController screenName = TextEditingController();
  late TextEditingController route = TextEditingController();
  final RxList<DocumentSnapshot> allScreens = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredScreens = RxList<DocumentSnapshot>([]);
  RxBool isLoading = RxBool(true);
  RxBool isScreenLoding = RxBool(true);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool addingNewScreenProcess = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  @override
  void onInit() {
    // init();
    getScreens();
    search.value.addListener(() {
      filterScreens();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allScreens.sort((screen1, screen2) {
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allScreens.sort((screen1, screen2) {
        final String? value1 = screen1.get('added_date');
        final String? value2 = screen2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allScreens.sort((screen1, screen2) {
        final String? value1 = screen1.get('routeName');
        final String? value2 = screen2.get('routeName');

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

// this functions is to get the screens in system and its details
  getScreens() {
    try {
      FirebaseFirestore.instance
          .collection('screens')
          .snapshots()
          .listen((screens) {
        allScreens.assignAll(screens.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  // this function is to update screen details
  updateScreen(screenID) async {
    try {
      addingNewScreenProcess.value = true;
      await FirebaseFirestore.instance
          .collection('screens')
          .doc(screenID)
          .update({
        'name': screenName.text,
        'routeName': route.text,
      });
      addingNewScreenProcess.value = true;
      showSnackBar('Done', 'Screen Updated successfully');
    } catch (e) {
      addingNewScreenProcess.value = true;
      showSnackBar('failed', 'Please try again');
    }
  }

  // this function is to filter the search results for web
  void filterScreens() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredScreens.clear();
    } else {
      filteredScreens.assignAll(
        allScreens.where((screen) {
          return screen['name'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  // this function is to show a snackbae with the state of the login process:
  void showSnackBar(title, body) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.grey,
      colorText: Colors.white,
    );
  }

// this function is to add new screen to the system
  addNewScreen() {
    try {
      addingNewScreenProcess.value = true;
      if (screenName.text.isEmpty || route.text.isEmpty) {
        throw Exception();
      }
      FirebaseFirestore.instance.collection('screens').add({
        "name": screenName.text,
        "routeName": route.text,
        "added_date": DateTime.now().toString(),
      });
      addingNewScreenProcess.value = false;
      showSnackBar('Done', 'New Screen added successfully');
    } on FirebaseAuthException catch (e) {
      addingNewScreenProcess.value = false;
      showSnackBar('warning', e);
    } catch (e) {
      addingNewScreenProcess.value = false;
      //
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
