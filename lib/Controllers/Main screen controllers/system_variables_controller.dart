import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SystemVariablesController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController value = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allVariables = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredVariables =
      RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);

  @override
  void onInit() {
    getVariables();
    search.value.addListener(() {
      filterVariables();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allVariables.sort((screen1, screen2) {
        final String? value1 = screen1.get('code');
        final String? value2 = screen2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allVariables.sort((screen1, screen2) {
        final String? value1 = screen1.get('value');
        final String? value2 = screen2.get('value');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allVariables.sort((screen1, screen2) {
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

  addNewVariable() async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance.collection('system_variables').add({
        'code': code.text,
        'value': value.text,
        'added_date': DateTime.now().toString(),
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  deleteVariable(variableId) async {
    try {
      await FirebaseFirestore.instance
          .collection('system_variables')
          .doc(variableId)
          .delete();

      Get.back();
    } catch (e) {
      //
    }
  }

  editVariable(variableId) async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance
          .collection('system_variables')
          .doc(variableId)
          .update({
        'code': code.text,
        'value': value.text,
      });

      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

// this functions is to get all variables
  getVariables() {
    try {
      FirebaseFirestore.instance
          .collection('system_variables')
          .snapshots()
          .listen((variables) {
        allVariables.assignAll(variables.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  // this function is to filter the search results for web
  void filterVariables() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredVariables.clear();
    } else {
      filteredVariables.assignAll(
        allVariables.where((variable) {
          return variable['code'].toString().toLowerCase().contains(query) ||
              variable['value'].toString().toLowerCase().contains(query);
        }).toList(),
      );
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
